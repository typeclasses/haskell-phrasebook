{-# LANGUAGE NumericUnderscores #-}

module Main where

import Control.Concurrent
import Control.Concurrent.Async
import Control.Concurrent.STM
import Control.Exception.Safe
import System.IO

import qualified System.Random.MWC as R

vendorApiCall :: R.GenIO -> Int -> IO Int
vendorApiCall rng n =
  do
    t <- R.uniformR (500_000, 1_500_000) rng
    threadDelay t
    return (n * n)

main :: IO ()
main =
  do
    hSetBuffering stdout LineBuffering

    rng <- R.createSystemRandom

    bq <- atomically (newTBQueue 5)
    let
      acquire = atomically (writeTBQueue bq ())
      release = atomically (readTBQueue bq)

    forConcurrently_ [1 .. 10] $ \x ->
        bracket_ acquire release $
          do
            putStrLn ("start: " ++ show x)
            result <- vendorApiCall rng x
            putStrLn ("finish: " ++ show x ++ ", result: " ++ show result)
