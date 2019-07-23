rec {

  versions = import ./versions.nix;

  pkgs = import versions.nixpkgs {};

  inherit (pkgs) callPackage haskellPackages;

  ghc = haskellPackages.ghcWithPackages (p: [
    p.bytestring
    p.text
  ]);

  inherit (haskellPackages) ghcid;

  outputs = callPackage ./outputs.nix { inherit ghc; };

}
