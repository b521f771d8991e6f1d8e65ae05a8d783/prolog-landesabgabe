pub mod prolog_vm;

use prolog_vm::*;

#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        type PrologVM;

        #[swift_bridge(init)]
        fn new() -> PrologVM;
        fn execute_js(self: &mut PrologVM, script: String) -> ();
        fn execute_prolog(self: &mut PrologVM, script: String) -> ();
    }
}
