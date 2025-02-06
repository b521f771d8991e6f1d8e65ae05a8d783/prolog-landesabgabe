## Internals

### Frontend
The frontend is written in React and Typescript. Ideally, we compile the
backend parts using WASM into the frontend to use the same code there, but we
are currently not there yet.

### Backend

This is a swift project that contains some C++ and Prolog parts. It may, in the future, contain some Haskell parts, too.
 * Simple C and C++ targets are handled by CMake (vcpkg support)
 * Mixed Swift/C++ targets are also handled by CMake (no SPM support, vcpkgs are supported, though)
 * Swift targets required in other mixed Swift/C++ targets are handled by CMake (no SPM support)
     --> some libraries are built here
 * Rust targets are build by Cargo, which is invoked by CMake. Do not invoke manually.
 * Pure Swift targets are built by the Swift Package Manager (subsequently invoked by CMake, do not invoke manually!), here you can use SPM
     --> use this as much as possible

Currently, we are relying on the Docker-Devcontainer, but I would love to:
 1. replace it by nix (nearly finished, waiting for a more recent Swift version (Swift 6 needed for C++20 support))
    - https://github.com/NixOS/nixpkgs/issues/343210
 2. ship the resulting binary as a 100% static build (that may take some time)

Dependencies:
 * use vcpkg, cargo, SPM as much as possible
 * for packages where this is not an option, use a git submodule in the Dependencies folder
 * do not rely on nix or Docker, except for the build infrastructure

Where to update dependencies? (Please see priorities above !!!)
 - Package.swift (for dependencies needed in Swift) 
 - Cargo.toml (for dependencies needed in Rust)
 - ./vcpkg.json (for dependencies needed in C++)
 - ./Dependencies/Dependencies.cmake && ./gitmodules (for dependencies included as an git submodule)
