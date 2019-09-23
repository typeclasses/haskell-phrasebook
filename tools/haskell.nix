{ haskellPackages }:

haskellPackages.ghcWithPackages (p: [
  p.containers
  p.cryptonite
  p.memory
  p.mwc-random
  p.generic-deriving
  p.hashable
  p.stm
  p.time
  p.utf8-string
])
