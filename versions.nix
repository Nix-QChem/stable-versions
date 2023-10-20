#
# This file contains the helpers to import different versions
#
rec {
  sha = with builtins; fromJSON (readFile ./versions.json);

  # latest, stable release string (without the dot):
  stable = "2305";

  getNixpkgs = ver: import ( builtins.fetchTarball
    "https://github.com/NixOS/nixpkgs/archive/${sha."${ver}".nixpkgs}.tar.gz");

  getNixOS-QChem = ver: import (builtins.fetchTarball
    "https://github.com/markuskowa/NixOS-QChem/archive/${sha."${ver}".NixOS-QChem}.tar.gz");
}
