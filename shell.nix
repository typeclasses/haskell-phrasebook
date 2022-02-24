let
  inherit (import ./tools/default.nix) pkgs haskell ghcid;
  inherit (pkgs) cacert cachix nix rsync cabal-install;
in
  pkgs.mkShell {
    buildInputs = [ haskell ghcid cacert nix rsync cachix cabal-install ];
    shellHook = ''
      export NIX_GHC="${haskell}/bin/ghc"
      export NIX_GHCPKG="${haskell}/bin/ghc-pkg"
      export NIX_GHC_DOCDIR="${haskell}/share/doc/ghc/html"
      export NIX_GHC_LIBDIR=$( $NIX_GHC --print-libdir )
    '';
  }
