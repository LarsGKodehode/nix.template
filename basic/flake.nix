{
  description = "A Nix-flake-based development environment";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  };

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
              # Add packages here
              # https://search.nixos.org/packages
              git
            ];
          };
        }
      );

      # The set of packages buildable through Nix
      packages = {
        default = project-name;

        project-name = nixpkgs.lib.mkPackage {
          pname = "a-project";
          version = "0.1.0";

          # Metadata
          # https://ryantm.github.io/nixpkgs/stdenv/meta/
          meta = with lib; {
            description = "";
            longDescription = '''';
            branch = "";
            mainProgram = "";
            homepage = "";
            changelog = "";
            license = licenses.mit;
            maintainers = [ ];
            platforms = platforms.all;
          };

          # Source files to include
          src = ./.;

          # Lists of packages to include
          nativeBuildInputs = [ ];
          buildInputs = [ ];

          buildPhase = '''';

          installPhase = '''';
        };
      };

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
