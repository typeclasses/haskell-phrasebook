#! /usr/bin/env nix-shell
#! nix-shell --pure shell.nix
#! nix-shell --keep NIX_PATH
#! nix-shell -i runhaskell

import System.Process

main = build >>= copy

build = fmap (head . lines) $ readProcess "nix-build" ["--attr", "outputs", "--no-out-link", "tools/default.nix"] ""

copy src = callProcess "rsync" ["--copy-links", "--recursive", "--chmod=ugo=rwX", src <> "/", "outputs"]
