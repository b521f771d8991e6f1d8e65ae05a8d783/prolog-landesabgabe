#[derive(rust_embed::Embed)]
#[folder = "Sources/Corpus"]
struct Asset;

pub fn fetch_from_corpus(file_path: &str) -> Option<String> {
    let Some(resource) = Asset::get(file_path) else {
        return None;
    };

    let Ok(string_data) = std::str::from_utf8(resource.data.as_ref()) else {
        return None;
    };

    return Some(string_data.to_string());
}

#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        pub fn fetch_from_corpus(file_path: &str) -> Option<String>;
    }
}
