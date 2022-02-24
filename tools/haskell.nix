{ haskell }:

let

  overrides = self: super:
    {
      hashable = self.callHackage "hashable" "1.3.5.0" {};
      optics = self.callHackage "optics" "0.4" {};
      optics-core = self.callHackage "optics-core" "0.4" {};
      optics-extra = self.callHackage "optics-extra" "0.4" {};
      optics-th = self.callHackage "optics-th" "0.4" {};
      relude = self.callHackage "relude" "1.0.0.1" {};
    };

in

(haskell.packages.ghc902.override { inherit overrides; }).ghcWithPackages (p: [
  p.async
  p.bytestring
  p.containers
  p.cryptonite
  p.directory
  p.filepath
  p.generic-deriving
  p.hashable
  p.hedgehog
  p.megaparsec
  p.memory
  p.mwc-random
  p.neat-interpolation
  p.network
  p.optics
  p.process
  p.relude
  p.safe-exceptions
  p.signal
  p.stm
  p.temporary
  p.time
  p.utf8-string
])
