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
              npm run vitest
              npm run build:web
            '';

            installPhase = ''
              mkdir -p $out
              cp -a generated/web-dist/frontend/* $out/
            '';
          };

          # Runnable wrapper: serves the static frontend via lighttpd
          # Usage: nix run -- [PORT]  or  PORT=3000 nix run
          serve = pkgs.writeShellScriptBin "prolog-landesabgabe" ''
            PORT="''${1:-''${PORT:-8080}}"
            CONF=$(mktemp)
            trap "rm -f $CONF" EXIT
            cat > "$CONF" <<EOF
            server.document-root = "${frontend}"
            server.port = $PORT
            server.bind = "0.0.0.0"
            index-file.names = ( "index.html" )
            mimetype.assign = (
              ".html" => "text/html",
              ".css"  => "text/css",
              ".js"   => "application/javascript",
              ".json" => "application/json",
              ".svg"  => "image/svg+xml",
              ".png"  => "image/png",
              ".wasm" => "application/wasm",
            )
            EOF
            echo "Serving on http://localhost:$PORT"
            ${pkgs.lighttpd}/bin/lighttpd -D -f "$CONF"
          '';
        in
        rec {
          packages = {
            inherit frontend serve;
            default = frontend;
          };

          apps.default = {
            type = "app";
            program = "${serve}/bin/prolog-landesabgabe";
          };

          checks = packages;

          formatter = pkgs.nixfmt-tree;
        }
      );
}
