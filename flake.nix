{
  description = "Stable versions and utilities";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = function:
        nixpkgs.lib.genAttrs [
          "x86_64-linux"
          "aarch64-linux"
        ] (system: function nixpkgs.legacyPackages.${system} system);
    in {
      legacyPackages = forAllSystems (pkgs: system:
          import ./default.nix {
            inherit
              pkgs
              system
            ;
          }
      );

      hydraJob = forAllSystems (pkgs: system:
        pkgs.callPackages ./github-sources.nix {}
      );

    };
}
