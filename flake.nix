# alternative to the devcontainer infrastructure
{
  description = "LegalXML";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/63dacb46bf939521bdc93981b4cbb7ecb58427a0";
    flake-utils.url = "github:numtide/flake-utils/04c1b180862888302ddfb2e3ad9eaa63afc60cf8";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachSystem [
    # supported linux systems
    flake-utils.lib.system.x86_64-linux
    flake-utils.lib.system.aarch64-linux

    # supported darwin systems
    flake-utils.lib.system.x86_64-darwin
    flake-utils.lib.system.aarch64-darwin
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
          xz

          # Low-level (Objective) C/++ toolchain
          clangStdenv
          clang_18
          clang-tools
      ] ++
        (if stdenv.isDarwin then [
          darwin.libobjc
        ] else if stdenv.isLinux then [
          gnustep.stdenv
          gnustep.make
          gnustep.base
          gnustep.libobjc
        ] else [])
      ++ [
          # High-level swift toolchain
          swift
          swiftPackages.Foundation

          # toolchain needed for webassembly
          emscripten # keep version in sync with Dockerfile !!! https://search.nixos.org/packages?show=emscripten&from=0&size=50&sort=relevance&type=packages&query=emscripten

          # build tools
          cmake
          ninja
          perl

          # for building the documentation
          texliveFull
      ];

      shellEnvironment = ''
          export CC=${pkgs.clang_18.out}/bin/clang
          export OBJC=${pkgs.clang_18.out}/bin/clang
          export CXX=${pkgs.clang_18.out}/bin/clang++
          export OBJCXX=${pkgs.clang_18.out}/bin/clang++
          export SWIFTC=${pkgs.swift}/bin/swiftc
          export OBJCFLAGS="$CFLAGS $(gnustep-config --objc-flags) $(gnustep-config --base-libs)"
          export OBJCXXFLAGS="$CFLAGS $(gnustep-config --objc-flags) $(gnustep-config --base-libs)"
          export LDFLAGS="$LDFLAGS $(gnustep-config --objc-flags) $(gnustep-config --base-libs)"
      '';
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
                  ];
              })

              # neovim environment
              neovim

              # useful for development
              swiProlog
            ];

            shellHook = shellEnvironment + ''
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
            ./Testing
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
          ];          

          shellHook = shellEnvironment;
        };
      };
    }
  );
}