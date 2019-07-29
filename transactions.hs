{-# LANGUAGE NumericUnderscores #-}

import Data.Foldable (for_, asum)
import Data.Traversable (for)

import System.IO
import Control.Concurrent (forkIO, threadDelay)
import Control.Monad (when, forever)

import Control.Monad.STM
import Control.Concurrent.STM.TVar

import System.Random.MWC (createSystemRandom, uniformR)
import qualified Data.Vector as Vector

main =
  do
    hSetBuffering stderr LineBuffering

    accountList <-
        for [1..10] $ \_ ->
            atomically (newTVar (100 :: Integer))

    let
        accountVector = Vector.fromList accountList

        randomAccount rng =
          do
            i <- uniformR (1, Vector.length accountVector) rng
            return (Vector.unsafeIndex accountVector (i - 1))

    for_ [1..20] $ \_ ->
        forkIO $
          do
            rng <- createSystemRandom
            forever $ do
                sender <- randomAccount rng
                recipient <- randomAccount rng
                amount <- toInteger <$> uniformR (1, 10 :: Int) rng

                atomically $
                    asum
                        [ do
                            check (sender /= recipient)
                            modifyTVar' sender (\x -> x - amount)
                            modifyTVar' recipient (\x -> x + amount)
                            readTVar sender >>= \x -> check (x >= 0)
                        , return ()
                        ]

    for_ [1..4] $ \_ ->
      do
        threadDelay 500_000
        balances <- atomically (for accountList readTVar)
        hPutStrLn stderr (show balances)
        putStrLn ("Total: " ++ show (sum balances))
