use actix_cors::Cors;
use actix_web::{
    App, HttpServer,
    middleware::NormalizePath,
    web::{self},
};
use std::env;

use crate::routes::keycloak_config;

mod app_config;
mod build_information;
mod prolog_vm;
mod prolog_wrapper;
mod routes;
mod testing;

async fn do_health_check() -> std::io::Result<()> {
    let url = format!(
        "http://{}:{}/{}/status",
        env::var("LX_WORKER_LISTEN_ON").unwrap(),
        env::var("LX_WORKER_LISTEN_PORT").unwrap(),
        env::var("VITE_LX_API_PREFIX").unwrap()
    );

    let response = reqwest::get(&url).await.map_err(|err| {
        eprintln!("Failed to send health check request: {}", err);
        std::io::Error::new(std::io::ErrorKind::Other, "Health check failed")
    })?;

    if response.status().is_success() {
        println!("Health check passed: {}", url);
        Ok(())
    } else {
        eprintln!(
            "Health check failed with status {}: {}",
            response.status(),
            url
        );
        Err(std::io::Error::new(
            std::io::ErrorKind::Other,
            "Health check failed",
        ))
    }
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    if let Some(arg) = env::args().nth(1) {
        match arg.as_str() {
            "check" => return do_health_check().await,
            _ => {
                eprintln!("Unknown argument: {}", arg);
                std::process::exit(1);
            }
        }
    }

    let app_state = web::Data::new(routes::app_state::AppState::from_environment().await);
    let server_binding = (
        app_state.server_host().clone(),
        app_state.server_port().clone(),
    );

    const API_PREFIX: &str = env!("VITE_LX_API_PREFIX");
    const PRIVATE_API_PREFIX: &str = env!("VITE_LX_PRIVATE_API_PREFIX");

    println!(
        "Launching backend service on port {} listening on {} using api prefix '{}'",
        server_binding.1, server_binding.0, API_PREFIX
    );

    env_logger::init_from_env(env_logger::Env::new().default_filter_or("info"));

    // set up the http server

    // TODO make this more concise
    if env::var("LX_NO_AUTH").is_err() {
        log::info!("Launching with keycloak");
        // wrap keycloak here
        let keycloak_config = keycloak_config::create_keycloak_config().await;

        HttpServer::new(move || {
            let allowed_origins = env::var("LX_ALLOWED_CORS_ORIGIN")
                .map(|origins| {
                    origins
                        .split(env!("LIST_SEPERATOR"))
                        .map(|s| s.trim().to_string())
                        .collect::<Vec<_>>()
                })
                .expect("LX_ALLOWED_CORS_ORIGIN not set");

            let cors = Cors::default()
                .allowed_origin_fn(move |origin, _req_head| {
                    allowed_origins.contains(&origin.to_str().unwrap_or_default().to_string())
                })
                .allow_any_method()
                .allow_any_header();

            App::new()
                .wrap(actix_web::middleware::Logger::default())
                .wrap(NormalizePath::new(
                    actix_web::middleware::TrailingSlash::Trim,
                ))
                .wrap(cors)
                .app_data(app_state.clone())
                .configure(routes::frontend_routes::add_services)
                .service(
                    web::scope(API_PREFIX)
                        .service(routes::util_services::build_information)
                        .service(routes::util_services::version)
                        .service(routes::util_services::status)
                        .service(routes::util_services::convert_to_teapot)
                        .service(routes::app_config::app_config)
                        .service(
                            web::scope(PRIVATE_API_PREFIX)
                                .wrap(keycloak_config.clone())
                                .service(routes::prolog_vm::query)
                                .service(routes::corpus::corpus),
                        ),
                )
        })
        .bind(server_binding)?
        .run()
        .await
    } else {
        log::warn!("Launching without keycloak");

        HttpServer::new(move || {
            let allowed_origins = env::var("LX_ALLOWED_CORS_ORIGIN")
                .map(|origins| {
                    origins
                        .split(env!("LIST_SEPERATOR"))
                        .map(|s| s.trim().to_string())
                        .collect::<Vec<_>>()
                })
                .expect("LX_ALLOWED_CORS_ORIGIN not set");

            let cors = Cors::default()
                .allowed_origin_fn(move |origin, _req_head| {
                    allowed_origins.contains(&origin.to_str().unwrap_or_default().to_string())
                })
                .allow_any_method()
                .allow_any_header();

            App::new()
                .wrap(actix_web::middleware::Logger::default())
                .wrap(NormalizePath::new(
                    actix_web::middleware::TrailingSlash::Trim,
                ))
                .wrap(cors)
                .app_data(app_state.clone())
                .configure(routes::frontend_routes::add_services)
                .service(
                    web::scope(API_PREFIX)
                        .service(routes::util_services::build_information)
                        .service(routes::util_services::version)
                        .service(routes::util_services::status)
                        .service(routes::util_services::convert_to_teapot)
                        .service(routes::app_config::app_config)
                        .service(
                            web::scope(PRIVATE_API_PREFIX)
                                .service(routes::prolog_vm::query)
                                .service(routes::corpus::corpus),
                        ),
                )
        })
        .bind(server_binding)?
        .run()
        .await
    }
}
