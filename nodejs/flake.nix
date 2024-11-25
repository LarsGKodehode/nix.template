{
  description = "A Nix-flake-based Node.js development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";

  outputs =
    { self, nixpkgs }:
    let
      # Systems supported
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      # Helper for generating attribute sets
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          # Development Environment
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              nodejs_22
              deno # Alternative JS/TS runtime and package manager
            ];
          };
        }
      );

      # TODO: Figure out how to best package node projects
      # Addendum: Look into Deno for doing this
      # Inspirations:
      # https://www.nmattia.com/posts/2022-12-18-lockfile-trick-package-npm-project-with-nix/
      # packages = {
      #   default = nixpkgs.lib.mkPackage {
      #     pname = "a-node-project";
      #     version = "0.1.0";

      #     src = ./.;

      #     buildInputs = [ nixpkgs.nodejs ];

      #     buildPhase = ''
      #       mkdir -p $out/bin
      #       npm run build
      #     '';

      #     meta = with nixpkgs.lib; {
      #       description = "A basic node project";
      #       license = licenses.mit;
      #     };
      #   };
      # };

      # For formatting nix files
      # "nix fmt"
      formatter = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        pkgs.nixfmt-rfc-style
      );
    };
}
