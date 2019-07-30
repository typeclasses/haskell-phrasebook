import Control.Concurrent (forkIO, threadDelay)
import Control.Monad (forever, when)
import Data.Foldable (asum, for_)
import Data.Traversable (for)
import System.IO

import Control.Monad.STM
import Control.Concurrent.STM.TVar

import System.Random.MWC (createSystemRandom, uniformR)
import qualified Data.Sequence as Seq

main =
  do
    accountList <-
        for [1..10] $ \_ ->
            atomically (newTVar (100 :: Integer))

    let
        accountSeq = Seq.fromList accountList

        randomAccount rng =
          do
            i <- uniformR (1, Seq.length accountSeq) rng
            return (Seq.index accountSeq (i - 1))

    for_ [1..20] $ \_ ->
        forkIO $
          do
            rng <- createSystemRandom
            forever $
              do
                sender    <- randomAccount rng
                recipient <- randomAccount rng

                amount <-
                  do
                    x <- uniformR (1, 10) rng
                    return (toInteger (x :: Int))

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
        threadDelay 500000
        balances <- atomically (for accountList readTVar)
        hPutStrLn stderr (show balances)
        putStrLn ("Total: " ++ show (sum balances))
