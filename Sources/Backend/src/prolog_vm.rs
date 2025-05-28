use actix_web::{HttpResponse, Responder, get, web};
use log::log;
use prolog_vm::{prolog_file::PrologFile, prolog_vm::PrologVM};

use crate::corpus::get_from_corpus;

#[get("/query")]
async fn query(query: web::Query<Params>) -> impl Responder {
    let laws: Vec<&str> = query.laws.split(',').map(|s| s.trim()).collect();
    let code = &query.code;

    log::info!("Executing {} on {:?}", code, laws);

    let laws_content: Result<Vec<PrologFile>, HttpResponse> = laws
        .iter()
        .map(|x| match get_from_corpus(x) {
            Some(content) => Ok(PrologFile {
                title: x.to_string(),
                content,
            }),
            None => Err(HttpResponse::BadRequest().body(format!("Could not find law {}", x))),
        })
        .collect();

    let laws_content = match laws_content {
        Ok(laws_content) => laws_content,
        Err(resp) => return resp,
    };

    let mut prolog_vm = PrologVM::new_with_loaded_prolog_files(laws_content).await;
    let result = prolog_vm.execute(code.to_string()).await;

    HttpResponse::Ok().body(format!("{:?}", result))
}

#[derive(serde::Deserialize)]
pub struct Params {
    pub laws: String,
    pub code: String,
}
