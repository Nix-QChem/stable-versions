jq -r '
  to_entries[]
  | "echo \\\"\(.key)\\\": \\{
     echo \\\"nixpkgs\\\": \\{
       echo \\\"rev\\\": \\\"\(.value.nixpkgs)\\\",
       hash256=$(nix-prefetch-url https://github.com/NixOS/nixpkgs/archive/\(.value.nixpkgs).tar.gz)
       hash_sri=$(nix hash convert --hash-algo sha256 $hash256)
       echo \\\"hash\\\": \\\"${hash_sri}\\\"
     echo \\},
     echo \\\"NixOS-QChem\\\": \\{
       echo \\\"rev\\\": \\\"\(.value.["NixOS-QChem"])\\\",
       hash256=$(nix-prefetch-url https://github.com/Nix-QChem/NixOS-QChem/archive/\(.value.["NixOS-QChem"]).tar.gz)
       hash_sri=$(nix hash convert --hash-algo sha256 $hash256)
       echo \\\"hash\\\": \\\"${hash_sri}\\\"
     echo \\}
     echo \\}
     echo ,"
  ' \
  versions.json > fetch_script.sh

  echo \{ > versions_full.json.tmp
  sh fetch_script.sh >> versions_full.json.tmp
  head -n-1 versions_full.json.tmp | { cat; echo '}'; } | jq  > versions_full.json
