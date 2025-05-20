#[derive(rust_embed::Embed)]
#[folder = "../LogicKit/dist"]
pub struct PrologVMAssets;

pub fn get_index_js() -> std::option::Option<String> {
    PrologVMAssets::get("index.js")
        .map(|file| String::from_utf8(file.data.to_vec()).expect("could not convert to utf-8"))
}

#[cfg(test)]
mod test {
    use super::*;

    #[tokio::test]
    async fn test_logic_kit_embedding() {
        assert!(get_index_js().is_some());
    }

    #[tokio::test]
    async fn test_load_deno_module_from_code() {
        let options = deno_core::RuntimeOptions {
            module_loader: Some(std::rc::Rc::new(deno_core::FsModuleLoader)),
            ..Default::default()
        };

        let mut js_runtime = deno_core::JsRuntime::new(options);
        let specifier =
            deno_core::resolve_url_or_path("file:///main.js", std::path::Path::new(".")).unwrap();
        let file = PrologVMAssets::get("index.js").expect("could not load");
        let file_data = file.data.clone();
        let code = String::from_utf8(file_data.to_vec()).expect("could not convert to utf-8");

        let module_id = js_runtime
            .load_main_es_module_from_code(&specifier, code)
            .await
            .expect("Could not load module from code");

        js_runtime
            .mod_evaluate(module_id)
            .await
            .expect("Could not evaluate module");
    }
}
