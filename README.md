## Internals

This is a swift project that contains some C++ and Prolog parts. It may, in the future, contain some Rust and Haskell parts, too.

Simple C and C++ targets are handled by CMake (vcpkg support)
 * Mixed Swift/C++ targets are also handled by CMake (no SPM support, vcpkgs are supported, though)
 * Swift targets required in other mixed Swift/C++ targets are handled by CMake (no SPM support)
     --> some libraries are built here
 * Pure Swift targets are built by the Swift Package Manager (subsequently invoked by CMake, do not invoke manually!), can 

Currently, we are relying on the Docker-Devcontainer, but I would love to:
 a. replace it by nix (nearly finished, waiting for a more recent Swift version (Swift 6))
 b. ship the resulting binary as a 100% static build (that may take some time)

### Misc
Where to update stuff? Dependencies.cmake, flake.nix, .gitmodules
