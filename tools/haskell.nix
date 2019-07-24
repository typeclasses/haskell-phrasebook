{ haskellPackages }:

haskellPackages.ghcWithPackages (p: [
  p.bytestring
  p.hashable
  p.pipes
  p.stm
  p.text
])
