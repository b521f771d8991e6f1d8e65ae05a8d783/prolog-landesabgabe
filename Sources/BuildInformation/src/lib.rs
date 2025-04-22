use wasm_bindgen::prelude::wasm_bindgen;

#[derive(serde::Serialize, Debug, Eq, PartialEq)]
#[wasm_bindgen]
pub struct BuildInformation {
    cargo_build_profile: String,
    cargo_package_version: String,
    git_commit: String,
    git_branch: String,
    git_commit_date: u128,
    git_status: String,
}

#[wasm_bindgen]
impl BuildInformation {
    #[wasm_bindgen(js_name = fromEnv)]
    pub fn from_env() -> Self {
        BuildInformation {
            cargo_build_profile: env!("CARGO_BUILD_PROFILE").to_string(),
            cargo_package_version: env!("CARGO_PKG_VERSION").to_string(),
            git_commit: env!("GIT_HASH").to_string(),
            git_branch: env!("GIT_BRANCH").to_string(),
            git_status: env!("GIT_STATUS").to_string(),
            git_commit_date: env!("GIT_DATE")
                .parse()
                .expect("error on decoding the date of the last git commit"),
        }
    }

    #[wasm_bindgen(js_name = getVersion)]
    pub fn get_version(&self) -> String {
        format!("{}@{}", self.git_branch, self.git_commit_date)
    }
}

#[swift_bridge::bridge]
mod ffi {
    extern "Rust" {
        type BuildInformation;
        #[swift_bridge(init)]
        fn from_env() -> BuildInformation;
        fn get_version(self: &BuildInformation) -> String;
    }
}
