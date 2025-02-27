// build.rs

use std::env;
use std::process::Command;

#[cfg(debug_assertions)]
const DOTENV_DEBUG_PROFILE: &str = "development";

#[cfg(not(debug_assertions))]
const DOTENV_DEBUG_PROFILE: &str = "production";

use std::path::PathBuf;

fn build_lxui() {
    let npm_path = "../lxui";

    // Change the current directory to the specified build directory
    env::set_current_dir(npm_path).expect("Failed to change directory");

    // Execute the `npm run build` command
    let status = Command::new("npm")
        .arg("run")
        .arg("build")
        .arg("--")
        .arg("--mode")
        .arg(DOTENV_DEBUG_PROFILE)
        .status()
        .expect("Failed to execute npm command");

    // Check if the command was successful
    if !status.success() {
        panic!("npm run build failed with status: {}", status);
    }
}

fn build_swift_bindings() {
    let out_dir = PathBuf::from("./generated");

    let bridges: Vec<&str> = vec!["src/lib.rs"];
    for path in &bridges {
        println!("cargo:rerun-if-changed={}", path);
    }

    swift_bridge_build::parse_bridges(bridges)
        .write_all_concatenated(out_dir, env!("CARGO_PKG_NAME"));
}

fn main() {
    build_swift_bindings();
    build_lxui();
}
