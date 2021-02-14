#! /usr/bin/env nix-shell
#! nix-shell --pure shell.nix
#! nix-shell --keep NIX_PATH
#! nix-shell -i runhaskell

-- We use this script to upload the Nix shell environment to Cachix.

import Control.Monad
import Data.Foldable
import System.Process

main = traverse_ (build >=> push) ["haskell", "ghcid"]

build attr = fmap (head . lines) $ readProcess "nix-build" ["tools", "--attr", attr, "--no-out-link"] ""

push path = callProcess "cachix" ["push", "typeclasses", path]
