#[derive(rust_embed::Embed)]
#[folder = "../Corpus"]
struct Corpus;

#[derive(rust_embed::Embed)]
#[folder = "../lxui/dist"]
struct WebAppData;

pub fn get_from_corpus(file_name: &str) -> Option<String> {
    Corpus::get(file_name).map(|data| String::from_utf8_lossy(&data.data).to_string())
}

pub fn list_corpus() -> Vec<String> {
    fn remove_file_suffix(i: &str) -> String {
        let mut result = i.to_string();

        if let Some(index) = result.rfind('.') {
            result.truncate(index);
        }

        return result;
    }

    return Corpus::iter()
        .into_iter()
        .map(|file| return remove_file_suffix(&file))
        .collect();
}

pub fn get_from_web_app_data(file_name: &str) -> Option<String> {
    WebAppData::get(file_name).map(|data| String::from_utf8_lossy(&data.data).to_string())
}

#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        fn get_from_corpus(file_name: &str) -> Option<String>;
        fn list_corpus() -> Vec<String>;
        fn get_from_web_app_data(file_name: &str) -> Option<String>;
    }
}

#[cfg(test)]
mod tests {
    use super::*;
}
