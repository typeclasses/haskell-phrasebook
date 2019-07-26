{-# LANGUAGE LambdaCase, NumericUnderscores #-}

module Main where

import Data.Foldable (asum)

import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.STM (atomically, retry)
import Control.Concurrent.STM.TVar

main =
  do
    timeout <- atomically (newTVar False)
    forkIO $ do threadDelay 1_000_000
                atomically (writeTVar timeout True)

    result <- atomically (newTVar Nothing)
    forkIO $ do threadDelay 2_000_000
                atomically (writeTVar result (Just
                    "Task A completed in two seconds"))

    message <- atomically $
      asum
        [ readTVar result >>=
            \case
              Nothing  ->  retry
              Just x   ->  return x
        , readTVar timeout >>=
            \case
              False    ->  retry
              True     ->  return "Task A timed out after one second"
        ]
    putStrLn message

    ---------------------------------------

    timeout <- atomically (newTVar False)
    forkIO $
      do
        threadDelay 1_000_000
        atomically (writeTVar timeout True)

    result <- atomically (newTVar Nothing)
    forkIO $
      do
        threadDelay (500_000)
        atomically (writeTVar result (Just
            "Task B completed in half a second"))

    message <- atomically $
      asum
        [ readTVar result >>=
            \case
              Nothing  ->  retry
              Just x   ->  return x
        , readTVar timeout >>=
            \case
              False    ->  retry
              True     ->  return "Task B timed out after one second"
        ]
    putStrLn message
