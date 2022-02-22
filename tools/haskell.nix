{ haskell }:

let

  overrides = self: super:
    {
      optics = self.callHackage "optics" "0.4" {};
      optics-core = self.callHackage "optics-core" "0.4" {};
      optics-extra = self.callHackage "optics-extra" "0.4" {};
      optics-th = self.callHackage "optics-th" "0.4" {};
    };

in

(haskell.packages.ghc901.override { inherit overrides; }).ghcWithPackages (p: [
  p.async
  p.bytestring
  p.containers
  p.cryptonite
  p.directory
  p.filepath
  p.generic-deriving
  p.hashable
  p.memory
  p.mwc-random
  p.network
  p.optics
  p.safe-exceptions
  p.signal
  p.stm
  p.time
  p.utf8-string
])
