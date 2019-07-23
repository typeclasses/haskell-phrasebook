let
  inherit (import ./default.nix) pkgs ghc ghcid;
in
  pkgs.mkShell { buildInputs = [ ghc ghcid ]; }
