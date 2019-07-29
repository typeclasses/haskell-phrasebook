{ haskellPackages }:

haskellPackages.ghcWithPackages (p: [
  p.mwc-random
  p.hashable
  p.stm
  p.vector
])
