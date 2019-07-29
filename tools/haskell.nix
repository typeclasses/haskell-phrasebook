{ haskellPackages }:

haskellPackages.ghcWithPackages (p: [
  p.bytestring
  p.mwc-random
  p.hashable
  p.pipes
  p.stm
  p.text
  p.vector
])
