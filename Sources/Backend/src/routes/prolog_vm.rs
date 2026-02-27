#[cfg(save_query)]
use crate::prolog_vm::prolog_vm::PrologVM;
use crate::prolog_wrapper::prolog_file::PrologFile;
use crate::routes::corpus::get_from_corpus;
use actix_web::http::Error;
use actix_web::{HttpResponse, Responder, get, web};
use log::{log, warn};

#[get("/query")]
async fn query(
    query: web::Query<std::collections::HashMap<String, String>>,
) -> Result<HttpResponse, Error> {
    let Some(laws_query) = query.get("laws") else {
        return Ok(HttpResponse::BadRequest().body("missing 'laws' parameter"));
    };
    let laws: Vec<&str> = laws_query.split(",").map(|x| x.trim()).collect();
    let Some(code) = query.get("query") else {
        return Ok(HttpResponse::BadRequest().body("missing 'query' parameter"));
    };

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
        Err(resp) => return Ok(resp),
    };

    #[cfg(save_query)]
    {
        let mut prolog_vm = PrologVM::new_with_loaded_prolog_files(laws_content).await;
        let result = prolog_vm.execute(code.as_str()).await;

        HttpResponse::Ok().body(format!("{:?}", result))
    }

    #[cfg(not(save_query))]
    {
        use crate::prolog_wrapper;

        log::warn!(
            "Warning: Save queries are not enabled, your backend is at risk! Do not use this in production!"
        );
        let result = prolog_wrapper::scryer::execute_query_on_files(laws_content, code.as_str())
            .unwrap();
        Ok(HttpResponse::Ok().json(result))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use actix_web::{App, test};

    #[test]
    async fn test_query() {
        let app = test::init_service(App::new().service(query)).await;
        let req = test::TestRequest::get()
            .uri("/query?laws=empty&query=true.")
            .to_request();
        let resp = test::call_and_read_body(&app, req).await;
        assert_eq!(resp, "\"True\"");
    }
}
