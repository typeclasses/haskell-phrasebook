rec {

  versions = import ./versions.nix;

  pkgs = import versions.nixpkgs {};

  inherit (pkgs) callPackage haskellPackages;

  haskell = callPackage ./haskell.nix {};

  inherit (haskellPackages) ghcid;

  ghcide = (import versions.ghcide {}).ghcide-ghc865;

  outputs = callPackage ./outputs.nix { inherit haskell; };

}
