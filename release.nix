{
  nixpkgs ? <nixpkgs>,
  ...
}@args:

let
  pkgs = import nixpkgs {};

  inherit (pkgs.lib)
    isDerivation
    filterAttrs
    mapAttrs
  ;

  sources = pkgs.callPackages ./github-sources.nix {};

in
mapAttrs (_: releases:
    filterAttrs (_: v: isDerivation v) releases
 ) sources

