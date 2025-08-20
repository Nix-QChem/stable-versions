{
  nixpkgs ? <nixpkgs>,
  ...
}@args:

let
  pkgs = import nixpkgs {};

  inherit (pkgs.lib)
    mapAttrs'
    nameValuePair
    toInt
    attrsToList
    filterAttrs
    last
  ;

  sources = pkgs.callPackages ./github-sources.nix {};

in
sources

