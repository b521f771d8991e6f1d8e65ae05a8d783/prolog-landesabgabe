use crate::prolog_wrapper::prolog_file::PrologFile;
use scryer_prolog::{
    self,
    machine::{Machine, config::MachineConfig, parsed_results::QueryResolution},
};

pub fn execute_query_on_files(
    files: Vec<PrologFile>,
    query: &str,
) -> Result<QueryResolution, String> {
    let mut wam = Machine::new(MachineConfig::default());

    for i in files {
        log::debug!(
            "Loading file '{}' into PrologVM ({} bytes)",
            i.title,
            i.content.bytes().len()
        );
        wam.load_module_string(&i.title, i.content);
    }

    wam.run_query(query.to_string())
}

#[wasm_bindgen::prelude::wasm_bindgen(js_name = "executeQueryOnFiles",)]
pub fn execute_query_on_files_to_json(files: Vec<PrologFile>, query: &str) -> String {
    let result = execute_query_on_files(files, query);
    serde_json::to_string(&result).unwrap_or_else(|e| {
        log::error!("Failed to serialize result: {}", e);
        "{}".to_string()
    })
}

#[cfg(test)]
mod tests {
    use std::vec;

    use scryer_prolog::machine::parsed_results::QueryResolution;

    use crate::prolog_wrapper::{prolog_file::PrologFile, scryer::execute_query_on_files};

    #[tokio::test]
    async fn test_execute_on_files() {
        let i = execute_query_on_files(
            vec![
                PrologFile {
                    title: "Test".to_string(),
                    content: r#"person(harry).
                        person(hermoine)."#
                        .to_string(),
                },
                PrologFile {
                    title: "V".to_string(),
                    content: r#"person(ron)."#.to_string(),
                },
            ],
            "person(ron).",
        );
        assert_eq!(i.clone().unwrap(), QueryResolution::True);
    }

    #[tokio::test]
    async fn test_execute_on_files2() {
        let u = execute_query_on_files(
            vec![PrologFile {
                title: "Test".to_string(),
                content: r#"person(harry)."#.to_string(),
            }],
            "person(ron).",
        );
        assert_eq!(u.clone().unwrap(), QueryResolution::False);
    }
}
