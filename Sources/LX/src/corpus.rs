use actix_web::{Error, HttpResponse, get, web};
use serde::Deserialize;

#[derive(rust_embed::Embed)]
#[folder = "../Corpus"]
struct Corpus;

pub fn get_from_corpus(file_name: &str) -> Option<String> {
    let file_name = if file_name.ends_with(".pl") {
        file_name.to_string()
    } else {
        format!("{}.pl", file_name)
    };
    Corpus::get(&file_name).map(|data| String::from_utf8_lossy(&data.data).to_string())
}

pub fn list_corpus() -> Vec<String> {
    fn remove_file_suffix(i: &str) -> String {
        let mut result = i.to_string();

        if let Some(index) = result.rfind('.') {
            result.truncate(index);
        }

        result
    }

    Corpus::iter()
        .into_iter()
        .filter(|file| file.ends_with(".pl"))
        .map(|file| remove_file_suffix(&file))
        .collect()
}

#[get("/fetch-law")]
async fn corpus(
    query: web::Query<std::collections::HashMap<String, String>>,
) -> Result<HttpResponse, Error> {
    if let Some(kurztitel) = query.get("kurztitel") {
        let file_name = format!("{}.pl", kurztitel);
        match get_from_corpus(&file_name) {
            Some(content) => Ok(HttpResponse::Ok()
                .content_type("application/x-prolog")
                .body(content)),
            None => Ok(HttpResponse::NotFound().body("Law not found")),
        }
    } else if query.is_empty() {
        let corpus_list = list_corpus();
        Ok(HttpResponse::Ok().json(corpus_list))
    } else {
        Ok(HttpResponse::BadRequest().body("Missing 'kurztitel' parameter"))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_list_corpus() {
        let files = list_corpus();
        assert!(!files.is_empty(), "No .pl files found in corpus");

        for file in &files {
            // Check that the original file exists and is not empty
            let file_name = format!("{}.pl", file);
            let content = get_from_corpus(&file_name);
            assert!(content.is_some(), "File {} not found in corpus", file_name);
            assert!(!content.unwrap().is_empty(), "File {} is empty", file_name);
        }
    }
}
