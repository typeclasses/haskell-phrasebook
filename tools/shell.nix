let
  inherit (import ./default.nix) pkgs haskell ghcid;
in
  pkgs.mkShell { buildInputs = [ haskell ghcid ]; }
