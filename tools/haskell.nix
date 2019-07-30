{ haskellPackages }:

haskellPackages.ghcWithPackages (p: [
  p.containers
  p.mwc-random
  p.hashable
  p.stm
  p.text
  p.time
])
