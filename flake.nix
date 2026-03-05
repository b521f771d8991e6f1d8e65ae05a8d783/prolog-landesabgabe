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
        in
        rec {
          packages = {
            inherit frontend;
            default = frontend;
          };

          checks = packages;

          formatter = pkgs.nixfmt-tree;
        }
      );
}
