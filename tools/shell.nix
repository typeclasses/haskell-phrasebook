let
  inherit (import ./default.nix) pkgs haskell ghcid ghcide;
in
  pkgs.mkShell {
    buildInputs = [ haskell ghcid ghcide ];
    shellHook = ''
      export NIX_GHC="${haskell}/bin/ghc"
      export NIX_GHCPKG="${haskell}/bin/ghc-pkg"
      export NIX_GHC_DOCDIR="${haskell}/share/doc/ghc/html"
      export NIX_GHC_LIBDIR=$( $NIX_GHC --print-libdir )
    '';
  }
