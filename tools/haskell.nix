{ haskellPackages }:

(haskellPackages.override { overrides = import ./overrides.nix; }).ghcWithPackages (p: [
  p.aeson-optics
  p.containers
  p.cryptonite
  p.memory
  p.mwc-random
  p.hashable
  p.optics
  p.stm
  p.time
  p.utf8-string
])
