use actix_web::{HttpResponse, Responder, get, web};
use log::log;

use crate::corpus::{PrologFile, get_from_corpus};
#[get("/query")]
async fn query(query: web::Query<Params>) -> impl Responder {
    let laws: Vec<&str> = query.laws.split(',').map(|s| s.trim()).collect();
    let code = &query.code;

    log::info!("Executing {} on {:?}", code, laws);

    let laws_content: Vec<PrologFile> = laws
        .iter()
        .map(|x| PrologFile {
            title: x.to_string(),
            content: get_from_corpus(x),
        })
        .collect();

    HttpResponse::Ok().body(())
}

#[derive(serde::Deserialize)]
pub struct Params {
    pub laws: String,
    pub code: String,
}
