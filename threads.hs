import Control.Concurrent (forkIO)
import Control.Concurrent.STM.TVar
import Control.Monad.STM
import Data.Foldable (for_)
import System.IO

main =
  do
    hSetBuffering stdout LineBuffering

    tasksCompleted <- atomically (newTVar 0)

    let
        task x =
          do
            for_ [1..3] $ \i ->
                putStrLn (x ++ ": " ++ show i)
            atomically $
                modifyTVar' tasksCompleted (+ 1)

    task "main"
    forkIO (task "forkA")
    forkIO (task "forkB")

    atomically $
      do
        x <- readTVar tasksCompleted
        check (x == 3)

    putStrLn "done"
