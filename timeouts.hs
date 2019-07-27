{-# LANGUAGE LambdaCase, NumericUnderscores #-}

import Data.Foldable (asum)

import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.STM (atomically, retry)
import Control.Concurrent.STM.TVar

main =
  do
    result <- atomically (newTVar Nothing)
    forkIO $
      do
        threadDelay 2_000_000
        atomically (writeTVar result (Just
            "Task A: Completed in two seconds"))

    timeout <- atomically (newTVar False)
    forkIO $
      do
        threadDelay 1_000_000
        atomically (writeTVar timeout True)

    message <- atomically $
      asum
        [ readTVar result >>=
            \case
              Nothing -> retry
              Just x  -> return x
        , readTVar timeout >>=
            \case
              False -> retry
              True  -> return "Task A: Gave up after one second"
        ]
    putStrLn message

    ----

    result <- atomically (newTVar Nothing)
    forkIO $
      do
        threadDelay (500_000)
        atomically (writeTVar result (Just
            "Task B: Completed in half a second"))

    timeout <- atomically (newTVar False)
    forkIO $
      do
        threadDelay 1_000_000
        atomically (writeTVar timeout True)

    message <- atomically $
      asum
        [ readTVar result >>=
            \case
              Nothing -> retry
              Just x  -> return x
        , readTVar timeout >>=
            \case
              False -> retry
              True  -> return "Task B: Gave up after one second"
        ]
    putStrLn message
