## Reminders
- Do not forget to init the submodules after cloning, "make init" is your friend

## Internals

### Frontend
The frontend is written in React and Typescript..

### Backend

This is a Swift project that contains some parts written in C++, Rust and Prolog.
 * Typescript targets are managed by npm
 * Simple C and C++ targets are handled by CMake (vcpkg support)
 * Pure Swift targets are built by the Swift Package Manager, here you can use SPM
     --> use this as much as possible

Currently, we are relying on the Docker-Devcontainer, but I would love to:
 1. replace it by nix (nearly finished, waiting for a more recent Swift version (Swift 6 needed for C++20 support))
    - https://github.com/NixOS/nixpkgs/issues/343210
 2. ship the resulting binary as a 100% static build (that may take some time)

Dependencies:
 * use vcpkg, SPM as much as possible
 * for packages where this is not an option, use a git submodule in the Dependencies folder
 * do not rely on nix or Docker, except for the build infrastructure

Where to update dependencies? (Please see priorities above !!!)
 - Package.swift (for dependencies needed in Swift)
 - ./vcpkg.json (for dependencies needed in C++)
 - ./Dependencies/Dependencies.cmake && ./gitmodules (for dependencies included as an git submodule)
