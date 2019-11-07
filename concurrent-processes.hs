import Control.Concurrent.Async (forConcurrently_)
import Data.Traversable (for)
import Path (toFilePath, (</>))
import Path.IO (getHomeDir)
import System.Exit (ExitCode(ExitSuccess))
import System.Process ( CreateProcess(cwd)
                      , createProcess
                      , shell
                      , waitForProcess
                      )

myDirs = undefined -- import from paths-and-directories.hs
listRepos = undefined -- import from paths-and-directories.hs

fetchRepo dir =
    (shell "git fetch --prune --all") {cwd = Just (toFilePath dir)}

retryForever proc = do
    (_, _, _, handle) <- createProcess proc
    exitCode <- waitForProcess handle
    if (exitCode == ExitSuccess) then return ()
    else retryForever proc

main = do
    home <- getHomeDir
    let fullPaths = map (home </>) myDirs
    repos <- fmap concat (for fullPaths listRepos)
    forConcurrently_ repos $ \repo -> retryForever (fetchRepo repo)
