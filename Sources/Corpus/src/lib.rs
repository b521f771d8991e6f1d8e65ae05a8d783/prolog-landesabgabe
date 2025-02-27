use rust_embed::Embed;
#[derive(Embed)]
#[folder = "../Corpus"]
#[include = "*.pl"]
#[exclude = "*.rs"]
#[exclude = "Testing/*"]
#[exclude = "stdlib/*"]
#[exclude = "src/*"]
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

pub fn list_corpus() -> Vec<String> {
    fn remove_file_suffix(i: &str) -> String {
        let mut result = i.to_string();

        if let Some(index) = result.rfind('.') {
            result.truncate(index);
        }

        return result;
    }

    return Asset::iter()
        .into_iter()
        .map(|file| return remove_file_suffix(&file))
        .collect();
}

#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        pub fn fetch_from_corpus(file_path: &str) -> Option<String>;
        pub fn list_corpus() -> Vec<String>;
    }
}
