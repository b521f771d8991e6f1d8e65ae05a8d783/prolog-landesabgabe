{
  inputs = {
    # https://github.com/NixOS/nixpkgs/commit/8b27c1239e5c421a2bbc2c65d52e4a6fbf2ff296
    nixpkgs.url = "github:NixOS/nixpkgs/8b27c1239e5c421a2bbc2c65d52e4a6fbf2ff296";
    flake-utils.url = "github:numtide/flake-utils/04c1b180862888302ddfb2e3ad9eaa63afc60cf8";
  };

  outputs = { self, nixpkgs, flake-utils }:
  flake-utils.lib.eachSystem [
    # supported linux systems
    flake-utils.lib.system.x86_64-linux
  ] ( system:
    let
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = false;
      };

      # this includes clang, etc
      lxStdEnv = pkgs.swiftPackages.stdenv;

      lxPackages = with pkgs; [
          # system tools
          zsh
          git
          curl

          # for building the documentation
          texliveFull
          
          # for the web part
          nodejs_22

          # build tools
          cmake
          ninja
          # clang is included in the frontend
          swift
          cargo
          rustc

          # frontend
          nodejs_23
      ];

      environment = {};
    in {
      devShells = {
        default = pkgs.mkShell.override
          {
            stdenv = lxStdEnv;
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
          };

          env = environment;
      };

      packages = {
        default =  lxStdEnv.mkDerivation {
          name = "lx";
          src = ./.;
          
          buildInputs = lxPackages; # TODO: convert to nativeBuildInputs, make swift static

          cmakeFlags = [
            "-G Ninja"
            "--preset release-x86-64-unknown-linux-gnu"
          ];

          env = environment;
        };
      };
    }
  );
}