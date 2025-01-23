use rust_embed::Embed;

#[derive(Embed)]
#[folder = "Sources/Corpus"]
struct Asset;

pub fn fetch_from_corpus(file_path: &str) -> String {
    let resource = Asset::get(file_path).unwrap();
    let string_data = std::str::from_utf8(resource.data.as_ref());
    return string_data.unwrap().to_string();
}