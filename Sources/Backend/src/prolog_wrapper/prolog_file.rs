use serde::{Deserialize, Serialize};
use wasm_bindgen::prelude::wasm_bindgen;

#[wasm_bindgen(getter_with_clone)]
#[derive(Serialize, Deserialize, Debug, Clone, PartialEq, Eq, Hash)]
pub struct PrologFile {
    pub title: String,
    pub content: String,
}

#[wasm_bindgen]
impl PrologFile {
    #[wasm_bindgen(constructor)]
    pub fn new(title: String, content: String) -> Self {
        PrologFile { title, content }
    }
}
