use deno_core::{error::CoreError, url::Url};

use crate::{assets::PrologVMAssets, prolog_file::PrologFile};

pub struct PrologVM {
    js_runtime: deno_core::JsRuntime,
}

#[derive(Debug, Eq, PartialEq)]
pub enum PrologVMError {
    DenoError(String),
}

impl PrologVM {
    pub fn from_options(options: deno_core::RuntimeOptions) -> Self {
        let js_runtime = deno_core::JsRuntime::new(options);

        return Self {
            js_runtime: js_runtime,
        };
    }

    pub fn new() -> Self {
        let options = deno_core::RuntimeOptions {
            module_loader: Some(std::rc::Rc::new(deno_core::FsModuleLoader)),
            ..Default::default()
        };

        return Self::from_options(options);
    }

    pub async fn new_with_default_runtime() -> Self {
        let mut pvm = Self::new();

        if let Err(e) = pvm.load_module_from_embedded_file("index.js").await {
            eprintln!("Error while loading embedded file: {}", e)
        }

        return pvm;
    }

    pub async fn new_with_loaded_prolog_files(modules: Vec<PrologFile>) -> Self {
        let mut pvm = Self::new_with_default_runtime().await;

        for module in modules {
            if let Err(err) = pvm.load_module_from_prolog_file(&module).await {
                eprintln!("Error loading module '{}': {:?}", module.title, err);
            }
        }

        pvm
    }

    pub async fn load_module_from_file(
        &mut self,
        file_path: &str,
    ) -> Result<deno_core::ModuleId, deno_core::error::CoreError> {
        let main_module = deno_core::resolve_path(file_path, &std::env::current_dir()?)
            .expect("Error converting path to URL");
        let mod_id = self.js_runtime.load_main_es_module(&main_module).await?;
        return Ok(mod_id);
    }

    pub async fn load_module_from_file_and_evaluate(
        &mut self,
        file_path: &str,
    ) -> Result<(), CoreError> {
        let mod_id = self
            .load_module_from_file(file_path)
            .await
            .expect("could not load module from file");

        self.evaluate_module(mod_id).await
    }

    pub async fn load_module_from_code(
        &mut self,
        specifier: Url,
        code: &str,
    ) -> Result<(), deno_core::error::CoreError> {
        let code_str = code.to_string();

        let module_id = self
            .js_runtime
            .load_main_es_module_from_code(&specifier, code_str)
            .await
            .expect("Could not load module from code");

        return self.evaluate_module(module_id).await;
    }

    pub async fn load_module_from_embedded_file(&mut self, name: &str) -> Result<(), CoreError> {
        let file = PrologVMAssets::get(name)
            .expect("could not load embedded file")
            .data
            .clone();

        let file_name = format!("file:///{}", name);

        let specifier = deno_core::resolve_url_or_path(&file_name, std::path::Path::new("."))
            .expect("Could not resolve URL");

        let code = String::from_utf8(file.to_vec()).expect("could not convert to utf-8");

        self.load_module_from_code(specifier, &code).await
    }

    pub async fn load_module_from_prolog_file(
        &mut self,
        prolog_file: &PrologFile,
    ) -> Result<(), deno_core::error::CoreError> {
        todo!("Implement this");
        Ok(())
    }

    pub async fn evaluate_module(
        &mut self,
        mod_id: deno_core::ModuleId,
    ) -> Result<(), deno_core::error::CoreError> {
        let result = self.js_runtime.mod_evaluate(mod_id).await?;
        self.js_runtime.run_event_loop(Default::default()).await?;
        return Ok(result);
    }

    pub async fn execute(
        &mut self,
        script: String,
    ) -> Result<deno_core::v8::Global<deno_core::v8::Value>, deno_core::error::CoreError> {
        self.js_runtime.execute_script("main.js", script)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[tokio::test]
    async fn test_execute_script() -> Result<(), deno_core::error::AnyError> {
        let mut vm = PrologVM::new();
        let script = "let x = 2 + 2; x;".to_string();
        let result = vm.execute(script).await?;
        let scope = &mut vm.js_runtime.handle_scope();
        let value = result.open(scope);
        let value = value.to_integer(scope).unwrap().value();
        assert_eq!(value, 4);
        Ok(())
    }

    #[tokio::test]
    async fn test_load_module() {
        let mut vm = PrologVM::new_with_default_runtime().await;
        let result = vm
            .execute("1".to_string())
            .await
            .expect("Error while constructing PrologVM");
    }
}
