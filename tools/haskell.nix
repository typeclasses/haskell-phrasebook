{ haskellPackages }:

haskellPackages.ghcWithPackages (p: [
  p.async
  p.containers
  p.cryptonite
  p.generic-deriving
  p.hashable
  p.memory
  p.mwc-random
  p.optics
  p.safe-exceptions
  p.stm
  p.time
  p.utf8-string
])
