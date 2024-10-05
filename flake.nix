{
  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
          pkgs = import nixpkgs { system = system; };
      in {
        packages = {
          perforator = pkgs.callPackage ./perforator.nix { };
          scnlib = pkgs.callPackage ./scnlib.nix { };
          kantu_compare = pkgs.callPackage ./kantu_compare/default.nix { };

          igraph_0_5_8 = pkgs.callPackage ./igraph.nix { };
          ggen = pkgs.callPackage ./ggen.nix { igraph = self.packages.${system}.igraph_0_5_8; };

          # Custom glibc and libgcc to build with -fPIC
          glibc = pkgs.glibc.overrideAttrs (oldAttrs: {
            env = oldAttrs.env // {
              NIX_CFLAGS_COMPILE = oldAttrs.env.NIX_CFLAGS_COMPILE + " -fPIC -ffunction-sections";
            };
          });
          libgcc = pkgs.libgcc.overrideAttrs (oldAttrs: {
            env = oldAttrs.env // {
              NIX_CFLAGS_COMPILE = "-fPIC";
            };
          });
        };
      
        defaultPackage = pkgs.mkShell {
          buildInputs = [ self.packages.${system}.scnlib pkgs.fmt ];
          nativeBuildInputs = with pkgs; [ clang cmake ];
        };
      });
}
