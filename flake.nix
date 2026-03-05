# for good documentation, see here: https://nixos.org/manual/nixpkgs/stable/
# @AI-Agents: do not add a devshell. Just don't. `nix develop` works just fine without one

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    flake-utils.url = "github:numtide/flake-utils";
    self.submodules = true;
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem
      [
        flake-utils.lib.system.x86_64-linux
        flake-utils.lib.system.aarch64-linux
        flake-utils.lib.system.x86_64-darwin
        flake-utils.lib.system.aarch64-darwin
      ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = {
              allowUnfree = false;
            };
          };

          # Build tools shared by both web-app and native targets.
          commonNativeBuildInputs = with pkgs; [
            # general tools
            git
            zsh
            pkg-config
            cmake
            ninja
            python3
            which
            scryer-prolog

            # native tools
            clang
            lld
            clang-tools

            # rust tools
            cargo
            rustc
            rustfmt
            bacon

            # node tools
            nodejs
            pkgs.importNpmLock.npmConfigHook

            (vscode-with-extensions.override {
              vscode = vscodium;
              vscodeExtensions =
                with vscode-extensions;
                [
                  # generic tools
                  bbenoist.nix
                  streetsidesoftware.code-spell-checker
                  humao.rest-client
                  ms-vscode.cmake-tools
                  esbenp.prettier-vscode
                  dbaeumer.vscode-eslint
                  github.github-vscode-theme
                  christian-kohler.npm-intellisense
                  wix.vscode-import-cost
                  bradlc.vscode-tailwindcss

                  # languages
                  rust-lang.rust-analyzer
                  llvm-vs-code-extensions.vscode-clangd
                ]
                ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                  {
                    name = "excalidraw-editor";
                    publisher = "pomdtr";
                    version = "3.9.1";
                    sha256 = "sha256-/LqC8GUBEDs+yGYCIX8RQtxDmWogTTiTiF/WJiCuEj4=";
                  }
                  {
                    name = "vsc-prolog";
                    publisher = "arthurwang";
                    version = "0.8.23";
                    sha256 = "sha256-Da2dCpruVqzP3g1hH0+TyvvEa1wEwGXgvcmIq9B/2cQ=";
                  }
                ];
            })
          ];

          # Web-app target: compiles Rust → WASM (wasm-pack) and native C → WASM (emscripten).
          webApp = pkgs.rustPlatform.buildRustPackage {
            name = "web-app";
            src = ./.;

            cargoLock = {
              lockFile = ./Cargo.lock;
            };

            env = {
              CC = "${pkgs.clang}/bin/clang";
              CXX = "${pkgs.clang}/bin/clang++";
              OBJC = webApp.CC;
              OBJCXX = webApp.CXX;

              VARIANT = "release";
              NODE_ENV = "production";
              PROJECT_NAME = "web-app";

              # .env vars needed at build time (normally injected via dotenvx)
              VITE_LX_API_PREFIX = "api";
              VITE_LX_PRIVATE_API_PREFIX = "private";
              VARIABLE_PREFIX = "LX_";
              LIST_SEPERATOR = ",";
              APP_CONFIG_EXPORT_TO_FRONTEND_PREFIXES = "LX_KEYCLOAK,VITE_LX,LX_NO_";
              APP_CONFIG_EXPORT_TO_FRONTEND_EXCLUDE = "";
              LX_NO_AUTH = "true";
              LX_WORKER_LISTEN_ON = "0.0.0.0";
              LX_WORKER_LISTEN_PORT = "1337";
              LX_JWT_ROLE = "";
              LX_ALLOWED_CORS_ORIGIN = "localhost:1337";
            };

            npmDeps = pkgs.importNpmLock { npmRoot = ./.; };

            nativeBuildInputs = commonNativeBuildInputs ++ (with pkgs; [
              # wasm toolchain
              wasmtime
              emscripten
              wasm-pack
              wasm-bindgen-cli_0_2_104
              binaryen
            ]);

            nativeTools = with pkgs; [
              nodejs-slim
            ];

            buildInputs =
              with pkgs;
              webApp.nativeTools;

            buildPhase = ''
              export EM_CACHE=$TMPDIR/emscripten-cache HOME=$TMPDIR/home
              mkdir -p $EM_CACHE $HOME

              # wasm-pack needs unwrapped clang for the wasm32 target
              CC=${pkgs.llvmPackages.clang-unwrapped}/bin/clang \
              CXX=${pkgs.llvmPackages.clang-unwrapped}/bin/clang++ \
              wasm-pack build \
                --out-dir ../../generated/npm-pkgs/prolog_landesabgabe Sources/Backend --mode no-install

              # frontend
              npm run build:web

              # cmake projects
              for dir in $(find Sources -maxdepth 2 -type f -name 'CMakeLists.txt' -exec dirname {} \;); do
                cmake -G Ninja -S "$dir" -B ".cmake/$dir" --preset $VARIANT
                cmake --build ".cmake/$dir"
              done
              cmake -G Ninja -S . -B .cmake/root
              cmake --build .cmake/root

              # backend
              cargo build --target $(rustc -vV | awk '/^host:/ {print $2}') --release --features backend
            '';

            checkPhase = ''
              ctest --test-dir .cmake
              cargo test
            '';

            installPhase = ''
              mkdir -p $out/bin

              # frontend static assets
              cp -a generated/web-dist/frontend/* $out/bin/

              # backend binary + cpack artifacts
              cd .cmake/root && cpack
              cd ../..
              mkdir -p ./output
              mv .cmake/root/prolog-landesabgabe* ./output/ 2>/dev/null || true
              mv ./output/* $out
            '';

            meta.mainProgram = "backend";
          };

          # Frontend-only target for static deployment (Cloudflare Workers, etc.)
          frontend = pkgs.stdenvNoCC.mkDerivation {
            name = "frontend";
            src = ./.;

            npmDeps = pkgs.importNpmLock { npmRoot = ./.; };

            nativeBuildInputs = with pkgs; [
              nodejs
              pkgs.importNpmLock.npmConfigHook
            ];

            buildPhase = ''
              export HOME=$TMPDIR/home
              mkdir -p $HOME
              npm run build:web
            '';

            installPhase = ''
              mkdir -p $out
              cp -a generated/web-dist/frontend/* $out/
            '';
          };

          webAppDebug = webApp.overrideAttrs (old: {
            name = "web-app-debug";
            env = old.env // {
              VARIANT = "debug";
              NODE_ENV = "development";
              PROJECT_NAME = old.name;
            };
          });

          # Native target: compiles Rust and C/C++/ObjC to native platform binaries.
          native = webApp.overrideAttrs (old: {
            name = "native";
            env = old.env // {
              PROJECT_NAME = "native";
            };
            nativeBuildInputs = builtins.filter
              (input: !builtins.elem input (with pkgs; [
                wasmtime
                emscripten
                wasm-pack
                wasm-bindgen-cli_0_2_104
                binaryen
              ]))
              old.nativeBuildInputs;
            buildPhase = ''
              export HOME=$TMPDIR/home
              mkdir -p $HOME

              # cmake projects
              for dir in $(find Sources -maxdepth 2 -type f -name 'CMakeLists.txt' -exec dirname {} \;); do
                CC=${webApp.CC} CXX=${webApp.CXX} cmake -G Ninja -S "$dir" -B ".cmake/$dir" --preset $VARIANT
                cmake --build ".cmake/$dir"
              done
              CC=${webApp.CC} CXX=${webApp.CXX} cmake -G Ninja -S . -B .cmake/root
              cmake --build .cmake/root

              # backend
              CC=${webApp.CC} CXX=${webApp.CXX} cargo build \
                --target $(rustc -vV | awk '/^host:/ {print $2}') --release --features backend
            '';
            checkPhase = ''
              ctest --test-dir .cmake
              cargo test
            '';
            installPhase = ''
              mkdir -p $out
              cd .cmake/root && cpack
              cd ../..
              mv .cmake/root/prolog-landesabgabe* ./output/ 2>/dev/null || true
              mv ./output/* $out
            '';
          });

          nativeDebug = native.overrideAttrs (old: {
            name = "native-debug";
            env = old.env // {
              VARIANT = "debug";
              NODE_ENV = "development";
            };
          });

          buildImage =
            pkg:
            (pkgs.dockerTools.buildLayeredImage (
              let
                backendListenPort = "1337";
              in
              {
                name = pkg.name;
                contents = pkg.nativeTools ++ [
                  pkgs.busybox
                ];

                config = {
                  Cmd = [ "${pkg}/bin/${pkg.meta.mainProgram}" ];
                  User = "65534:65534";
                  WorkingDir = "/app";

                  Env = [
                    "LX_WORKER_LISTEN_PORT=${backendListenPort}"
                    "LX_WORKER_LISTEN_ON=0.0.0.0"
                  ];

                  ExposedPorts = {
                    "${backendListenPort}" = { };
                  };

                  Healthcheck = {
                    Test = [
                      "${pkgs.curlMinimal}/bin/curl"
                      "-f"
                      "-s"
                      "localhost:${backendListenPort}/api/status"
                    ];
                    Interval = 30000000000;
                    Timeout = 10000000000;
                    Retries = 3;
                  };

                  Volumes = {
                    "/app" = { };
                  };
                };
              }
            ));
        in
        rec {
          packages = {
            "web-app" = webApp;
            "web-app-debug" = webAppDebug;
            inherit frontend;
            native = native;
            native-debug = nativeDebug;
            docker-image = buildImage webApp;
            "docker-image-debug" = buildImage webAppDebug;
            default = webApp;
          };

          checks = builtins.removeAttrs packages [ "default" ];

          formatter = pkgs.nixfmt-tree;
        }
      );
}
