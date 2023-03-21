{-# LANGUAGE QuasiQuotes #-}

import Control.Monad (filterM)
import Data.Foldable (for_)
import Data.Traversable (for)
import Path (reldir, (</>))
import Path.IO (doesDirExist, getHomeDir, listDir)

myDirs = [ [reldir|typeclasses|]
         , [reldir|julie|]
         , [reldir|chris|]
         ]

isGitRepo dir = doesDirExist (dir </> dotGit)
    where dotGit = [reldir|.git|]

listRepos parentdir = do
    (subdirs, _) <- listDir parentdir
    filterM isGitRepo subdirs

main = do
    home <- getHomeDir
    let fullPaths = map (home </>) myDirs
    repos <- fmap concat (for fullPaths listRepos)
    for_ repos print
