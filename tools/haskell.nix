{ haskell }:

haskell.packages.ghc8103.ghcWithPackages (p: [
  p.async
  p.containers
  p.cryptonite
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
