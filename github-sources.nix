{ lib,
  fetchFromGitHub,
}:

let
  versions = with builtins; fromJSON (readFile ./versions_full.json);
  paths = lib.mapAttrs (name: value: {
      nixpkgs = fetchFromGitHub {
        owner = "NixOS";
        repo = "nixpkgs";
        rev = value.nixpkgs.rev;
        inherit (value.nixpkgs) hash;
      };
      NixOS-QChem = fetchFromGitHub {
        owner = "Nix-QChem";
        repo = "NixOS-QChem";
        rev = value.NixOS-QChem.rev;
        inherit (value.NixOS-QChem) hash;
      };
      version = name;
    }) versions;

in
lib.mapAttrs' (name: value:
  lib.nameValuePair "qchem-${name}"
  value
) paths

