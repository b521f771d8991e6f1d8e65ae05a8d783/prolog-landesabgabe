#![allow(non_snake_case)]

pub struct PrologVM {
    js_runtime: deno_core::JsRuntime,
}

impl PrologVM {
    pub fn new() -> Self {
        let js_runtime = deno_core::JsRuntime::new(deno_core::RuntimeOptions {
            module_loader: Some(std::rc::Rc::new(deno_core::FsModuleLoader)),
            ..Default::default()
        });

        return Self {
            js_runtime: js_runtime,
        };
    }
}

#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        type PrologVM;
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}
