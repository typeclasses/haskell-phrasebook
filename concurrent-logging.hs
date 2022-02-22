import Control.Applicative (liftA2)
import Control.Monad (unless, replicateM_)
import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.Async (concurrently_, forConcurrently_)
import Control.Monad.STM (atomically)
import Data.Foldable (for_)
import System.Environment (lookupEnv)
import System.Random (randomRIO)
import Text.Read (readMaybe)

import qualified Control.Concurrent.STM.TQueue as TQ
import qualified Control.Concurrent.STM.TVar as TV

randomDelay =
  do
    i <- randomRIO (1, 1000)
    threadDelay i

-- Here we have a concurrent program that is parameterized on how to write log messages.
choir log =
    -- Run three concurrent threads, each singing a different tune.
    forConcurrently_ ["Do Re Mi", "Fa Sol", "La Ti Do"] $ \tune ->
        replicateM_ 3 $ -- Each member of the choir sings its tune 3 times.
          do
            randomDelay -- ... with some random delays between each repetition.
            log tune

-- Our demonstration program runs the "choir" two different ways:
main =
  do
    choir putStrLn -- The first way has a serious flaw, which we shall see in the output.
    putStrLn "---"
    withConcurrentLog choir -- The second way uses a queue to orchestrate the printing.

withConcurrentLog go = do
    queue <- TQ.newTQueueIO
    stopVar <- TV.newTVarIO False

    let
      logToQueue msg = atomically (TQ.writeTQueue queue msg)

      printFromQueue = do
        randomDelay
        stop <- atomically (liftA2 (&&) (TQ.isEmptyTQueue queue) (TV.readTVar stopVar))
        unless stop $ do
          msg <- atomically (TQ.readTQueue queue)
          putStrLn msg
          printFromQueue

    let stop = atomically (TV.writeTVar stopVar True)

    concurrently_ printFromQueue (go logToQueue *> stop)
