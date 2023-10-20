{ lib ? (import <nixpkgs> {}).lib
, config ? {}
}:

let
  inherit (lib) mapAttrs' nameValuePair;

  v = import ./versions.nix;

  # assemble nixpkgs + overlay
  buildPkgs = ver: v.getNixpkgs ver {
    inherit config;
    overlays = [ (v.getNixOS-QChem ver) ];
  };

  # extract qchem subset (no subset for 20.03 and 20.09)
  getQchem = version:
    let
      pkgs = buildPkgs version;
    in
      if pkgs ? qchem then pkgs.qchem
      else pkgs;

  # create all versions as qchem-XXYY sets
  sets = mapAttrs' (version: _:
    nameValuePair
      ("qchem-${version}")
      (getQchem version)
  ) v.sha;

in
  sets //
  {
    # latest stable as a static named subset
    "qchem-stable" = getQchem v.stable;
  }
