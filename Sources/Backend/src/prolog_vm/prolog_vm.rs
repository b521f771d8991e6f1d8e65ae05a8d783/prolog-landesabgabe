use deno_core::{error::CoreError, url::Url};
use either::Either::{self, Left};
use serde::{Deserialize, Serialize};

use crate::prolog_vm::assets::PrologVMAssets;
use crate::prolog_wrapper::prolog_file::PrologFile;
use rand::{Rng, distr::Alphanumeric};

#[derive(Debug, Eq, PartialEq, PartialOrd, Ord, Serialize, Deserialize)]
pub struct QueryBinding {
    query: String,
    variable_name: String,
}

#[derive(Debug, Eq, PartialEq, PartialOrd, Ord, Serialize, Deserialize)]
pub struct VariableBinding {
    name: String,
    value: Option<Vec<String>>,
}

#[derive(Debug)]
pub enum VariableParseError {
    InvalidFormat,
    ParseError,
}

impl VariableBinding {
    pub fn from_string(variable_name: &str, value_str: &str) -> Result<Self, VariableParseError> {
        if !value_str.starts_with('[') || !value_str.ends_with(']') {
            return Err(VariableParseError::InvalidFormat);
        }

        let inner = &value_str[1..value_str.len() - 1];
        if inner.trim().is_empty() {
            return Result::Ok(Self {
                name: variable_name.to_string(),
                value: Some(vec![]),
            });
        }

        let values: Vec<String> = inner.split(',').map(|s| s.trim().to_string()).collect();

        Result::Ok(Self {
            name: variable_name.to_string(),
            value: Some(values),
        })
    }
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

    // Add this static function in the PrologVM impl block:
    fn generate_temp_variable_name() -> String {
        let random_suffix: String = rand::rng()
            .sample_iter(&Alphanumeric)
            .take(8)
            .map(char::from)
            .collect();
        format!("tmp_var_{}", random_suffix)
    }

    /*pub async fn execute_module_multiple_variable_bindings(
        &mut self,
        script: &str,
        queries: Vec<QueryBinding>,
        fact_base: Vec<String>,
    ) -> Result<Vec<VariableBinding>, Either<deno_core::anyhow::Error, VariableParseError>> {
    }*/

    pub async fn execute_module_as_variable_bindings(
        &mut self,
        script: &str,
        variable: &str,
        fact_base: Vec<String>,
    ) -> Result<Vec<VariableBinding>, Either<deno_core::anyhow::Error, VariableParseError>> {
        let tmp_variable_name = Self::generate_temp_variable_name();
        let js_script =
            create_js_script_from_prolog_env(script, variable, fact_base, &tmp_variable_name);

        self.evaluate_prolog_binding(variable, tmp_variable_name, js_script)
            .await
    }

    pub async fn evaluate_prolog_binding(
        &mut self,
        variable: &str,
        tmp_variable_name: String,
        js_script: String,
    ) -> Result<Vec<VariableBinding>, Either<deno_core::anyhow::Error, VariableParseError>> {
        match self
            .execute_module(js_script.as_str(), tmp_variable_name.as_str())
            .await
        {
            Result::Ok(execution_result) => {
                match VariableBinding::from_string(variable, execution_result.as_str()) {
                    Result::Ok(variable_binding) => Result::Ok(vec![variable_binding]),
                    Err(_) => todo!(),
                }
            }
            Err(err) => Err(Left(err)),
        }
    }

    // returns a json string
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

fn create_js_script_from_prolog_env(
    script: &str,
    variable: &str,
    fact_base: Vec<String>,
    tmp_variable_name: &String,
) -> String {
    format!(
        "globalThis.{} = await runQuery([{}], '{}', '{}')",
        tmp_variable_name,
        fact_base
            .iter()
            .map(|s| format!("\"{}\"", s.replace('\n', " ")))
            .collect::<Vec<_>>()
            .join(", "),
        script,
        variable
    )
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
            .execute_module_as_variable_bindings("X = 1.", "X", vec!["".to_string()])
            .await
            .expect("Error while executing test script in prolog.");
        assert_eq!(
            vec![VariableBinding {
                name: "X".to_string(),
                value: Some(vec!["1".to_string()])
            }],
            result
        )
    }

    #[tokio::test]
    async fn test_run_query_with_variable() {
        let mut vm = PrologVM::new_with_default_runtime().await;
        let result = vm
            .execute_module_as_variable_bindings(
                "parent(john, X).",
                "X",
                vec!["parent(john, mary). \n parent(john, bob).".to_string()],
            )
            .await
            .expect("Error while executing test script in prolog.");

        assert_eq!(
            vec![VariableBinding {
                name: "X".to_string(),
                value: Some(vec!["mary".to_string(), "bob".to_string()])
            }],
            result
        );
    }
}
