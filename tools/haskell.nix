{ haskellPackages }:

haskellPackages.ghcWithPackages (p: [
  p.async
  p.containers
  p.cryptonite
  p.memory
  p.mwc-random
  p.generic-deriving
  p.hashable
  p.safe-exceptions
  p.stm
  p.time
  p.utf8-string
])
