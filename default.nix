{
  pkgs ? import <nixpkgs> {},
  system ? builtins.currentSystem,
  config ? {},
}:

let

  inherit (pkgs.lib)
    mapAttrs'
    nameValuePair
    toInt
    attrsToList
    last
  ;

  channels = pkgs.callPackages ./github-sources.nix {};

  # Assemble nixpkgs + overlay
  buildPkgs = c:
    # 21.05 and older needs to be pinned manually
    if (toInt c.version <= 2105) then
      (import c.nixpkgs {
        inherit system;
        overlays = [ (import c.NixOS-QChem) ];
        inherit config;
      })
      else
      (import c.nixpkgs {
        inherit system;
        overlays = [ (import c.NixOS-QChem) ];
        inherit config;
      })
   ;

  # extract qchem subset (no subset for 20.03 and 20.09)
  getQchem = p:  if p ? qchem then p.qchem else p;

  sets = mapAttrs' (name: channel:
  nameValuePair "${name}"
  (let
     pkgs = buildPkgs channel;
   in getQchem pkgs)
  ) channels;

in
sets //
{
  qchem-stable = (last (attrsToList sets)).value;
}

