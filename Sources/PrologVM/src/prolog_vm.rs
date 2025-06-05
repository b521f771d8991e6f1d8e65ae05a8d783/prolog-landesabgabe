use deno_core::{anyhow::Ok, error::CoreError, url::Url};
use serde::{Deserialize, Serialize};

use crate::{assets::PrologVMAssets, prolog_file::PrologFile};
use rand::{Rng, distr::Alphanumeric};

#[derive(Debug, Eq, PartialEq, PartialOrd, Ord, Serialize, Deserialize)]
pub struct VariableBinding {
    name: String,
    value: Option<String>,
}

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

        self.evaluate_module(module_id).await?;

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

        self.evaluate_module(module_id).await?;

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
        _prolog_file: &PrologFile,
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

    pub async fn execute_prolog_query(
        &mut self,
        files: Vec<String>,
        query: &str,
        variables: Vec<String>,
    ) -> Vec<VariableBinding> {
        let js_code = format!(
            "globalThis.__prolog_results = await runQuery([{}], '{}', [{}]);",
            files.join(", "),
            query.replace('\'', "\\'"),
            variables.join(", ")
        );

        log::info!("Executing JS command {}", js_code);

        // Execute the JS code as a module
        if let Err(e) = self.execute_module(&js_code, "__prolog_results").await {
            log::error!("Failed to execute prolog query: {}", e);
            return vec![];
        }

        vec![]
    }

    pub async fn execute_module(
        &mut self,
        script: &str,
        variable: &str,
    ) -> Result<String, deno_core::anyhow::Error> {
        // Create a unique specifier for the module
        let module_name = Self::generate_inline_module_name();
        log::info!("Creating inline module with name: {}", module_name);
        let specifier = Self::resolve_module_specifier(&module_name)?;

        // Load the code as a side module and evaluate it
        log::info!("Loading and evaluating side module from code...");
        self.load_side_module_from_code(specifier, script).await?;

        // Now, get the value of the variable from the global scope
        let value_str = self.get_global_variable_as_string(variable)?;

        log::info!("Returning value for variable '{}': {}", variable, value_str);
        Ok(value_str)
    }

    fn generate_inline_module_name() -> String {
        let random_suffix: String = rand::rng()
            .sample_iter(&Alphanumeric)
            .take(8)
            .map(char::from)
            .collect();
        format!("file:///inline_module_{}.js", random_suffix)
    }

    fn resolve_module_specifier(module_name: &str) -> Result<Url, deno_core::anyhow::Error> {
        deno_core::resolve_url_or_path(module_name, std::path::Path::new("."))
            .map_err(|e| deno_core::anyhow::anyhow!("Could not resolve URL: {}", e))
    }

    fn get_global_variable_as_string(
        &mut self,
        variable: &str,
    ) -> Result<String, deno_core::anyhow::Error> {
        log::info!(
            "Attempting to retrieve variable '{}' from global scope",
            variable
        );
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

        match value {
            Some(val) => {
                if val.is_string() {
                    log::info!("Variable '{}' is a string", variable);
                    Ok(val.to_rust_string_lossy(scope))
                } else if val.is_undefined() {
                    log::info!("Variable '{}' is undefined", variable);
                    Err(deno_core::anyhow::anyhow!(
                        "Variable '{}' is undefined in global scope",
                        variable
                    ))
                } else if val.is_null() {
                    log::info!("Variable '{}' is null", variable);
                    Err(deno_core::anyhow::anyhow!(
                        "Variable '{}' is null in global scope",
                        variable
                    ))
                } else {
                    // Try to convert to string
                    log::info!(
                        "Variable '{}' is not a string, attempting to convert to string",
                        variable
                    );
                    match val.to_string(scope) {
                        Some(s) => Ok(s.to_rust_string_lossy(scope)),
                        None => {
                            log::info!("Failed to convert value of '{}' to string", variable);
                            Err(deno_core::anyhow::anyhow!(
                                "Failed to convert value of '{}' to string",
                                variable
                            ))
                        }
                    }
                }
            }
            None => {
                log::info!("Variable '{}' not found in global scope", variable);
                Err(deno_core::anyhow::anyhow!(
                    "Variable '{}' not found in global scope",
                    variable
                ))
            }
        }
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
    async fn test_execute_prolog() {
        let mut vm = PrologVM::new_with_default_runtime().await;
        // Sample Prolog query: find all X such that X = 1; should return ["1"]
        let result = vm
            .execute_module("globalThis.x = await runQuery([], 'X = 1.', 'X')", "x")
            .await
            .expect("Error while executing test script in prolog.");
        assert_eq!("[1]", result)
    }

    #[tokio::test]
    async fn test_execute_simple_arithmetic() {
        let mut vm = PrologVM::new();
        let script = "let y = 10 * 3; y;".to_string();
        let result = vm.execute(script).await.unwrap();
        let scope = &mut vm.js_runtime.handle_scope();
        let value = result.open(scope);
        let value = value.to_integer(scope).unwrap().value();
        assert_eq!(value, 30);
    }

    #[tokio::test]
    async fn test_execute_module_returns_string() {
        let mut vm = PrologVM::new_with_default_runtime().await;
        let result = vm
            .execute_module("globalThis.answer = 'hello world';", "answer")
            .await
            .unwrap();
        assert_eq!(result, "hello world");
    }

    #[tokio::test]
    async fn test_execute_module_returns_number_as_string() {
        let mut vm = PrologVM::new_with_default_runtime().await;
        let result = vm
            .execute_module("globalThis.num = 42;", "num")
            .await
            .unwrap();
        assert_eq!(result, "42");
    }

    #[tokio::test]
    async fn test_execute_module_returns_array_as_string() {
        let mut vm = PrologVM::new_with_default_runtime().await;
        let result = vm
            .execute_module("globalThis.arr = [1, 2, 3];", "arr")
            .await
            .unwrap();
        assert_eq!(result, "1,2,3");
    }

    #[tokio::test]
    async fn test_run_query_with_variable() {
        let mut vm = PrologVM::new_with_default_runtime().await;
        // Define facts and query for variable
        let script = r#"
            await runQuery(["parent(john, mary). parent(john, bob)."], "parent(john, X).", "X");
        "#;
        let result = vm
            .execute_module(&format!("globalThis.res = {};", script), "res")
            .await
            .unwrap();
        // Should return all X such that parent(john, X)
        // The result is expected to be "[\"mary\",\"bob\"]" or "[mary,bob]"
        println!("{}", result);
        assert!(result.contains("mary"));
        assert!(result.contains("bob"));
    }
}
