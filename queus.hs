module Main where

import Control.Monad
import System.IO
import Control.Concurrent
import Control.Concurrent.STM
import System.Random

tictoc :: TQueue String -> [Int] -> IO ()
tictoc q xs = forM_ xs $ \x -> threadDelay 100000 >>
                               atomically (writeTQueue q ("tictoc: " ++ show x))

-- polling unstable API with 5 simultaneous proccesses
startPollingUnstable :: TQueue String -> [Int] -> IO ()
startPollingUnstable q xs = do
    -- magic is here. Bounded Queue that can contain only 5 elements
    bq <- atomically $ newTBQueue 5
    vars <- forM xs $ \x -> do
        -- capture empty cell in queue. Or wait for it.
        atomically $ writeTBQueue bq ()
        -- Haskell can't wait implicitly. To wait excplicitly we need this vars
        var <- newEmptyTMVarIO :: IO (TMVar ())
        atomically $ writeTQueue q ("start: " ++ show x)
        _ <- forkFinally (unstableProc x)
                         (\r -> do case r of
                                       Right x' -> atomically $
                                                     writeTQueue q ("finish: " ++ show x
                                                                    ++ ", result: " ++ show x')
                                       _ -> return ()
                                   -- free cell in bounded queue. Next request is already waiting.
                                   atomically $ readTBQueue bq
                                   -- this process is finished.
                                   atomically $ putTMVar var ())
        return var
    -- and now we need to wait for all requests
    forM_ vars $ \v -> atomically $ readTMVar v

-- Request to vendor's API can be here.
unstableProc :: Int -> IO Int
unstableProc n = do
    t <- getStdRandom (randomR (500000,1500000))
    threadDelay t >> return (n * n)

-- Let's pretend we have vendors API.
-- And vendor can block us if we make too many simultaneous requests
main :: IO ()
main = do
    q <- atomically newTQueue
    -- Print numbers from 1 to ... each 500ms and write them in queue.
    tt <- forkIO $ tictoc q [1..]
    -- Haskell should eixplicitly wait for response
    v <- newEmptyTMVarIO
    -- Print numbers from 1000 1010 and fill queue with values
    _ <- forkFinally (startPollingUnstable q [1000..1010])
                     (\r -> do killThread tt
                               atomically $ putTMVar v ())
    -- wait while v become full, empty it and exit...
    atomically $ takeTMVar v
    -- now let's check what we have in queue
    atomically (flushTQueue q) >>= mapM_ putStrLn
