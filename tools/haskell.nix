{ haskellPackages }:

haskellPackages.ghcWithPackages (p: [
  p.bytestring
  p.hashable
  p.stm
  p.text
])
