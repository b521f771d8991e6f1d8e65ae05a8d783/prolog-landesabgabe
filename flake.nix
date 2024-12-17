{
  description = "LX";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/8b27c1239e5c421a2bbc2c65d52e4a6fbf2ff296";
    flake-utils.url = "github:numtide/flake-utils/04c1b180862888302ddfb2e3ad9eaa63afc60cf8";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachSystem [
    # supported linux systems
    flake-utils.lib.system.x86_64-linux
    flake-utils.lib.system.aarch64-linux

    # supported darwin systems
    #flake-utils.lib.system.x86_64-darwin
    #flake-utils.lib.system.aarch64-darwin
  ] ( system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = false;
      };

      lxPackages = with pkgs; [
          # system tools
          zsh
          git
          curl

          # Low-level (Objective) C/++ toolchain
          gcc14
          clang-tools
          # High-level swift toolchain
          # TODO add swift here once the nix version is updated to 6, for now, we have to use debian
          # swift
          #swiftPackages.Foundation

          # to run the web app
          nodejs_23

          # toolchain needed for webassembly
          emscripten

          # build tools
          cmake
          ninja
          perl

          # for building the documentation
          texliveFull
          
          # for the web part
          nodejs_22
      ];
    in {
      devShells = {
        default = pkgs.mkShell.override
          {
            stdenv = pkgs.clangStdenv;
          }
          {
            packages = with pkgs; lxPackages ++ [
              # vscode environment
              (vscode-with-extensions.override {
                  vscode = vscodium;
                  vscodeExtensions = with vscode-extensions; [
                      bbenoist.nix
                      twxs.cmake
                      vadimcn.vscode-lldb
                      ms-vscode.cmake-tools
                      llvm-vs-code-extensions.vscode-clangd
                      streetsidesoftware.code-spell-checker
                      james-yu.latex-workshop
                      vscodevim.vim
                  ] ++ vscode-utils.extensionsFromVscodeMarketplace [
                      {
                        name = "swift-lang";
                        publisher = "sswg";
                        version = "1.10.4";
                        sha256 = "sha256-5NrWBuaNdDNF0ON0HUwdwPFsRO3Hfe0UW4AooJbjiA0=";
                      }
                      {
                        name = "vsc-prolog";
                        publisher = "arthurwang";
                        version = "0.8.23";
                        sha256 = "sha256-Da2dCpruVqzP3g1hH0+TyvvEa1wEwGXgvcmIq9B/2cQ=";
                      }
                  ];
              })

              # neovim environment
              neovim

              # useful for development
              swi-prolog
            ];

            shellHook = ''
                echo "Since nix does not have a recent swift version, we need to include it via apt"
                sudo apt install -y swiftlang
                export DONT_PROMPT_WSL_INSTALL=y
            '';
          };
      };

      packages = {
        default = 
        let
          fs = pkgs.lib.fileset;
          sourceFiles = fs.unions [
            ./CMakeLists.txt
            ./Sources
            ./Dependencies
          ];
        in
        pkgs.clangStdenv.mkDerivation {
          name = "lx";
          src = fs.toSource {
            root = ./.;
            fileset = sourceFiles;
            };
          
          buildInputs = lxPackages; # TODO: convert to nativeBuildInputs, make swift static

          cmakeFlags = [
            "-GNinja"
            "--preset release-x86-64-unknown-linux-gnu"
          ];
        };
      };
    }
  );
}