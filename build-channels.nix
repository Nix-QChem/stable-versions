{ lib,
  fetchurl,
  stdenvNoCC,
}:

let
  versions = with builtins; fromJSON (readFile ./versions_full.json);
  paths = lib.mapAttrs (name: value: {
      nixpkgs = fetchurl {
        name = "nixpkgs.tar.gz";
        url = "https://github.com/NixOS/nixpkgs/archive/${value.nixpkgs.rev}.tar.gz";
        inherit (value.nixpkgs) hash;
      };
      NixOS-QChem = fetchurl {
        name = "NixOS-QChem.tar.gz";
        url = "https://github.com/Nix-QChem/NixOS-QChem/archive/${value.NixOS-QChem.rev}.tar.gz";
        inherit (value.NixOS-QChem) hash;
      };
    }) versions;

in
lib.mapAttrs' (name: value:
  lib.nameValuePair name
  (stdenvNoCC.mkDerivation {
    pname = "nixos-qchem";
    version = name;

    srcs = [
      value.nixpkgs
      value.NixOS-QChem
    ];

    sourceRoot = ".";

    dontFixup = true;
    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
     mkdir -p $out/nixpkgs $out/NixOS-QChem
     cp -r nixpkgs*/* $out/nixpkgs
     cp -r NixOS-QChem*/* $out/NixOS-QChem
    '';
  })
) paths

