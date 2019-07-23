rec {

  versions = import ./versions.nix;

  pkgs = import versions.nixpkgs {};

  inherit (pkgs) callPackage haskellPackages;

  haskell = callPackage ./haskell.nix {};

  inherit (haskellPackages) ghcid;

  outputs = callPackage ./outputs.nix { inherit haskell; };

}
