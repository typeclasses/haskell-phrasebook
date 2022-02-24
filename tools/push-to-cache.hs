#! /usr/bin/env nix-shell
#! nix-shell --pure ../shell.nix
#! nix-shell --keep NIX_PATH
#! nix-shell -i runhaskell

-- We use this script to upload the Nix shell environment to Cachix.

import Control.Monad
import Data.Foldable
import System.Process

main = build >>= push

build = fmap (head . lines) $ readProcess "nix-build" ["shell.nix", "--attr", "buildInputs", "--no-out-link"] ""

push path = callProcess "cachix" ["push", "typeclasses", path]
