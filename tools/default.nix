rec {

  versions = import ./versions.nix;

  pkgs = import versions.nixpkgs {};

  unstable = import versions.unstable {};

  haskell = unstable.callPackage ./haskell.nix {};

  inherit (pkgs.haskellPackages) ghcid;

  outputs = pkgs.callPackage ./outputs.nix { inherit haskell; };

}
