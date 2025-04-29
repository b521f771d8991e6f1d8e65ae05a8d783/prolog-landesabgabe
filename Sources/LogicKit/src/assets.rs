#[derive(rust_embed::Embed)]
#[folder = "dist"]
struct LogicKit;

#[cfg(test)]
mod test {
    use futures::future::err;

    use super::*;

    #[test]
    fn test_logic_kit_embedding() {
        assert!(LogicKit::get("index.js").is_some());
    }

    #[tokio::test]
    async fn test_loading_into_deno() {
        let options = deno_core::RuntimeOptions {
            module_loader: Some(std::rc::Rc::new(deno_core::FsModuleLoader)),
            ..Default::default()
        };

        let mut js_runtime = deno_core::JsRuntime::new(options);
        let specifier =
            deno_core::resolve_url_or_path("file:///main.js", std::path::Path::new(".")).unwrap();
        let code = r#"
            console.log("Hello from Deno!");
        "#;

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
