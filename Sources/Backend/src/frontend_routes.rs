use actix_web::http::Error;
use actix_web::{web, HttpResponse };
use log::info;

#[derive(rust_embed::Embed)]
#[folder = "../../generated/web-dist/frontend"]
pub struct WebAppData;

impl WebAppData {
    fn lookup(path: &str) -> Result<HttpResponse, Error> {
        match Self::get(path) {
            Some(content) => Ok(HttpResponse::Ok()
                .content_type(mime_guess::from_path(path).first_or_octet_stream().as_ref())
                .body(content.data.to_owned())),
            None => Ok(HttpResponse::NotFound().body("404 Not Found")),
        }
    }

    pub fn debug_list() {
        info!("Found the following files in WebAppData:");
        for file in WebAppData::iter() {
            info!("- {}", file);
        }
    }
}

#[actix_web::get("/")]
async fn root() -> Result<HttpResponse, Error> {
    WebAppData::lookup("index.html")
}

#[actix_web::get("/index.html")]
async fn index() -> Result<HttpResponse, Error> {
    WebAppData::lookup("index.html")
}

#[actix_web::get("/explore.html")]
async fn explore() -> Result<HttpResponse, Error> {
    WebAppData::lookup("explore.html")
}

#[actix_web::get("/favicon.html")]
async fn favicon() -> Result<HttpResponse, Error> {
    WebAppData::lookup("favicon.ico")
}

#[actix_web::get("/+not-found.html")]
async fn not_found() -> Result<HttpResponse, Error> {
    WebAppData::lookup("+not-found.html")
}

#[actix_web::get("/_sitemap.html")]
async fn sitemap() -> Result<HttpResponse, Error> {
    WebAppData::lookup("_sitemap.html")
}

#[actix_web::get("/assets/{_:.*}")]
async fn assets(path: web::Path<String>) -> Result<HttpResponse, Error> {
    let file_path = format!("assets/{}", path);
    WebAppData::lookup(file_path.as_str())
}

#[actix_web::get("/_expo/{_:.*}")]
async fn expo(path: web::Path<String>) -> Result<HttpResponse, Error> {
    let file_path = format!("_expo/{}", path);
    WebAppData::lookup(file_path.as_str())
}

#[actix_web::get("/(tabs)/{_:.*}")]
async fn tabs(path: web::Path<String>) -> Result<HttpResponse, Error> {
    let file_path = format!("(tabs)/{}", path);
    WebAppData::lookup(file_path.as_str())
}

pub fn add_services(app: &mut web::ServiceConfig) {
    app.service(assets);
    app.service(root);
    app.service(index);
    app.service(expo);
    app.service(tabs);
    app.service(favicon);
    app.service(explore);
    app.service(sitemap);
    app.service(not_found);
}