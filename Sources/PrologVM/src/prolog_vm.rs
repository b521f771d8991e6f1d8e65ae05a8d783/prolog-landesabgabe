use deno_core::url::Url;
use futures::executor;

use crate::assets::PrologVMAssets;

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

    pub async fn new_with_modules() -> Self {
        let mut pvm = Self::new();

        let specifier =
            deno_core::resolve_url_or_path("file:///index.js", std::path::Path::new("."))
                .expect("Could not resolve URL");
        let file = PrologVMAssets::get("index.js")
            .expect("could not load")
            .data
            .clone();
        let code = String::from_utf8(file.to_vec()).expect("could not convert to utf-8");

        if let Err(err) = pvm.load_module_from_code(specifier, code).await {
            eprintln!("Error loading module from code: {:?}", err);
        }

        return pvm;
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

    pub async fn load_module_from_code(
        &mut self,
        specifier: Url,
        code: String,
    ) -> Result<(), deno_core::error::CoreError> {
        let module_id = self
            .js_runtime
            .load_main_es_module_from_code(&specifier, code)
            .await
            .expect("Could not load module from code");

        return self.js_runtime.mod_evaluate(module_id).await;
    }

    pub async fn evaluate_module(
        &mut self,
        mod_id: deno_core::ModuleId,
    ) -> Result<impl ?Sized, deno_core::error::CoreError> {
        let result = self.js_runtime.mod_evaluate(mod_id);
        self.js_runtime.run_event_loop(Default::default()).await?;
        return Ok(result);
    }

    pub async fn execute(
        &mut self,
        script: String,
    ) -> Result<deno_core::v8::Global<deno_core::v8::Value>, deno_core::error::CoreError> {
        self.js_runtime.execute_script("script.js", script)
    }

    pub fn execute_js(&mut self, script: String) -> () {
        let result: Result<
            deno_core::v8::Global<deno_core::v8::Value>,
            deno_core::error::CoreError,
        > = executor::block_on(self.execute(script));

        match result {
            Ok(value) => Ok(()),
            Err(error) => Err(PrologVMError::DenoError("".to_string())),
        };
    }

    pub fn execute_prolog(&mut self, prolog_expression: String) -> () {
        // TODO implement this
        self.execute_js(prolog_expression);
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
    async fn test_execute_js() {
        let mut vm = PrologVM::new();
        assert_eq!(
            vm.execute_js("console.log('Well, boys, this works!' 🍒);".to_string()),
            ()
        );
    }

    #[tokio::test]
    async fn test_load_module() {
        let mut vm = PrologVM::new();
    }
}
