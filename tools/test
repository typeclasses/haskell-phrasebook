#! /usr/bin/env nix-shell
#! nix-shell --pure shell.nix
#! nix-shell --keep NIX_PATH
#! nix-shell -i runhaskell

{-# language OverloadedStrings, ScopedTypeVariables #-}

-- This is the test script run by the CI server.

import Data.Foldable
import System.Directory
import System.Process
import System.Exit
import System.FilePath ((</>))
import Data.ByteString.Lazy (ByteString)
import qualified Data.ByteString.Lazy as ByteString
import qualified Data.Text.Lazy as Text
import qualified Data.Text.Lazy.Encoding as Text
import qualified Data.Text.Lazy.IO as Text

main = (build >>= copy) *> (findProblems >>= conclude)

-- Builds all of the example outputs in the Nix store and returns the path.
build :: IO FilePath =
    fmap (head . lines) $ readProcess "nix-build" ["--attr", "outputs", "--no-out-link", "tools/default.nix"] ""

-- Copies the example outputs from the Nix store into the "outputs-test" directory.
copy (src :: FilePath) =
    callProcess "rsync" ["--copy-links", "--recursive", "--chmod=ugo=rwX", src <> "/", "outputs-test"]

data Problem = Problem FilePath ByteString

-- The "outputs" and "outputs-test" directories should be identical. This action returns a list of the filenames that differ.
findProblems :: IO [Problem] =
    listDirectory "outputs" >>= mapM problemsForFile >>= (return . fold)

-- Given an output file name, returns a list of problems. If the file in "outputs" differs from the corresponding file in "outputs-test", that's a problem.
problemsForFile (filename :: FilePath) =
  do
    expected <- ByteString.readFile ("outputs" </> filename)
    actual <- ByteString.readFile ("outputs-test" </> filename)
    if expected == actual then return [] else return [Problem filename actual]

-- If the problem list is non-empty, prints the list of problems and exits with a nonzero status code to indicate failure.
conclude (problems :: [Problem]) =
    if null problems then putStrLn "Okay!"
    else Text.putStrLn (showProblems problems) *> exitFailure

showProblems (problems :: [Problem]) =
    Text.intercalate "\n------------------------\n"
        ("Problems!" : map showOneProblem problems)

showOneProblem (Problem filename content) =
    "The output for file " <> Text.pack filename <> " is:\n" <>
    Text.decodeUtf8 content
