import Control.Concurrent (forkIO, threadDelay)
import Control.Monad.STM (atomically)
import Data.Foldable (for_)
import System.Environment (lookupEnv)
import System.Random (randomRIO)
import Text.Read (readMaybe)

import qualified Control.Concurrent.STM.TBQueue as TBQ


seconds n = 1000000 * n


threadsafeLog maxQueue = do
  queue <- atomically (TBQ.newTBQueue maxQueue)

  let
    logToQueue msg = atomically (TBQ.writeTBQueue queue msg)

    printFromQueue = do
      threadDelay (seconds 1 `div` 2)
      emptyQueue <- atomically (TBQ.isEmptyTBQueue queue)
      if emptyQueue then
        return ()
      else do
        msg <- atomically (TBQ.readTBQueue queue)
        putStrLn msg
        printFromQueue

  return (logToQueue, printFromQueue)


sing phrase log =
  for_ [1..5] $ \n -> do
    i <- randomRIO (1, 10000)
    threadDelay (seconds 1 `div` i + n)
    log phrase


main = do
  (log, print) <- do
    maxQueue <- (readMaybe =<<) <$> lookupEnv "MAX_QUEUE"
    case maxQueue of
      Nothing -> return (putStrLn, threadDelay (seconds 3))
      Just n -> threadsafeLog n

  for_ [sing "Do Re Mi", sing "Fa Sol", sing "La Ti Do"] $
    \singPhrase -> forkIO (singPhrase log)

  print
