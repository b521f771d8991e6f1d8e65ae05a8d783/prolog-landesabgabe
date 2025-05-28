use deno_core::{anyhow::Ok, error::CoreError, url::Url};

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

        if let Err(e) = pvm.load_module_from_embedded_file("runtime.js").await {
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
    ) -> Result<deno_core::ModuleId, deno_core::anyhow::Error> {
        let main_module = deno_core::resolve_path(file_path, &std::env::current_dir()?)
            .expect("Error converting path to URL");
        let mod_id = self.js_runtime.load_main_es_module(&main_module).await?;
        return Ok(mod_id);
    }

    pub async fn load_module_from_file_and_evaluate(
        &mut self,
        file_path: &str,
    ) -> Result<(), deno_core::anyhow::Error> {
        let mod_id = self
            .load_module_from_file(file_path)
            .await
            .expect("could not load module from file");

        self.evaluate_module(mod_id).await
    }

    pub async fn load_main_module_from_code(
        &mut self,
        specifier: Url,
        code: &str,
    ) -> Result<usize, deno_core::anyhow::Error> {
        let code_str = code.to_string();

        let module_id = self
            .js_runtime
            .load_main_es_module_from_code(&specifier, code_str)
            .await
            .expect("Could not load module from code");

        self.evaluate_module(module_id).await;

        return Ok(module_id);
    }

    pub async fn load_side_module_from_code(
        &mut self,
        specifier: Url,
        code: &str,
    ) -> Result<usize, deno_core::anyhow::Error> {
        let code_str = code.to_string();

        let module_id = self
            .js_runtime
            .load_side_es_module_from_code(&specifier, code_str)
            .await
            .expect("Could not load module from code");

        self.evaluate_module(module_id).await;

        return Ok(module_id);
    }

    pub async fn load_module_from_embedded_file(
        &mut self,
        name: &str,
    ) -> Result<usize, deno_core::anyhow::Error> {
        let file = PrologVMAssets::get(name)
            .expect("could not load embedded file")
            .data
            .clone();

        let file_name = format!("file:///{}", name);

        let specifier = deno_core::resolve_url_or_path(&file_name, std::path::Path::new("."))
            .expect("Could not resolve URL");

        let code = String::from_utf8(file.to_vec()).expect("could not convert to utf-8");

        self.load_main_module_from_code(specifier, &code).await
    }

    pub async fn load_module_from_prolog_file(
        &mut self,
        prolog_file: &PrologFile,
    ) -> Result<(), deno_core::anyhow::Error> {
        todo!("Implement this");
    }

    pub async fn evaluate_module(
        &mut self,
        mod_id: deno_core::ModuleId,
    ) -> Result<(), deno_core::anyhow::Error> {
        let result = self.js_runtime.mod_evaluate(mod_id).await?;
        self.js_runtime.run_event_loop(Default::default()).await?;
        return Ok(result);
    }

    pub async fn execute(
        &mut self,
        script: String,
    ) -> Result<deno_core::v8::Global<deno_core::v8::Value>, CoreError> {
        self.js_runtime.execute_script("main.js", script)
    }

    pub async fn execute_module(
        &mut self,
        script: &str,
        variable: &str,
    ) -> Result<String, deno_core::anyhow::Error> {
        // Create a unique specifier for the module
        let specifier =
            deno_core::resolve_url_or_path("file:///inline_module.js", std::path::Path::new("."))
                .map_err(|e| deno_core::anyhow::anyhow!("Could not resolve URL: {}", e))?;

        // Load the code as a side module and evaluate it
        let module_id = self.load_side_module_from_code(specifier, script).await?;

        // Evaluate the module (already done in load_side_module_from_code)
        // Now, get the value of the variable from the global scope
        let scope = &mut self.js_runtime.handle_scope();
        let context = scope.get_current_context();
        let global = context.global(scope);

        let variable_key = deno_core::v8::String::new(scope, variable)
            .ok_or_else(|| {
                deno_core::anyhow::anyhow!(
                    "Failed to create V8 string for variable name '{}'",
                    variable
                )
            })?
            .into();

        let value = global.get(scope, variable_key);

        let value_str = match value {
            Some(val) => {
                if val.is_string() {
                    val.to_rust_string_lossy(scope)
                } else if val.is_undefined() || val.is_null() {
                    "undefined".to_string()
                } else {
                    // Try to convert to string
                    match val.to_string(scope) {
                        Some(s) => s.to_rust_string_lossy(scope),
                        None => {
                            return Err(deno_core::anyhow::anyhow!(
                                "Failed to convert value of '{}' to string",
                                variable
                            ));
                        }
                    }
                }
            }
            None => {
                return Err(deno_core::anyhow::anyhow!(
                    "Variable '{}' not found in global scope",
                    variable
                ));
            }
        };

        Ok(value_str)
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
        // Sample Prolog query: find all X such that X = 1; should return ["1"]
        let result = vm
            .execute_module("globalThis.x = await runQuery([], 'X = 1.', 'X')", "x")
            .await
            .expect("Error while executing test script in prolog.");
        assert_eq!("[1]", result)
    }
}
