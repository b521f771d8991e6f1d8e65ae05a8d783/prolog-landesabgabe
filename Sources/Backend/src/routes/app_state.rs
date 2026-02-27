use crate::routes::keycloak_config;
use actix_web_middleware_keycloak_auth::{AlwaysReturnPolicy, KeycloakAuth};
use std::env;

// can we use this here? https://diesel.rs/
// https://actix.rs/docs/application/
#[derive(derive_getters::Getters)]
pub struct AppState {
    server_port: u16,
    server_host: String,
    keycloak_enabled: bool,
    keycloak_config: Option<KeycloakAuth<AlwaysReturnPolicy>>,
}

impl AppState {
    pub async fn from_environment() -> AppState {
        let (server_host, server_port) = keycloak_config::setup_server_config();
        let has_auth = env::var("LX_NO_AUTH");

        let keycloak_enabled = if has_auth.is_ok() && has_auth.unwrap().eq("true") {
            false
        } else {
            true
        };

        let keycloak_config = if keycloak_enabled {
            Some(keycloak_config::create_keycloak_config().await)
        } else {
            None
        };

        AppState {
            server_port,
            server_host,
            keycloak_enabled,
            keycloak_config,
        }
    }
}
