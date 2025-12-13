{
  description = "Jaroslav Pesek's personal website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            hugo
            pandoc
            git
            go
            nixd
          ];
          shellHook = ''
            echo "Hugo site development shell"
            echo "  hugo version: $(hugo version)"
            echo "  pandoc version: $(pandoc --version | head -1)"
            echo ""
            echo "Commands:"
            echo "  hugo server -s site     # Start dev server"
            echo "  nix build .#site        # Build static site"
          '';
        };

        # Build script for CI/local use
        # Note: Hugo Modules require network access, so `nix build` won't work directly
        # Use the devShell for local builds or GitHub Actions for CI
        packages.build-script = pkgs.writeShellScriptBin "build-site" ''
          set -e
          cd "$(git rev-parse --show-toplevel)"
          mkdir -p site/data
          ${pkgs.pandoc}/bin/pandoc site/content/publications.bib -t csljson -o site/data/publications.json
          cd site
          ${pkgs.hugo}/bin/hugo mod tidy
          ${pkgs.hugo}/bin/hugo --minify -d ../dist
          echo "Site built to dist/"
        '';

        packages.default = self.packages.${system}.build-script;
      }
    );
}
