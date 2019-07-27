import Control.Monad.STM
import Control.Concurrent.STM.TVar

main =
  do
    a <- atomically (newTVar 3)
    b <- atomically (newTVar 5)

    let
      printVars label =
        do
          x1 <- atomically (readTVar a)
          x2 <- atomically (readTVar b)
          putStrLn ("a = " ++ show x1 ++ ", b = " ++ show x2
                    ++ " (" ++ label ++ ")")

    printVars "initial values"

    atomically (writeTVar a 7)
    printVars "changed a to 7"

    atomically (modifyTVar' b (* 2))
    printVars "doubled b"

    let
        increment ref = atomically (modifyTVar' ref (+ 1))

        swap ref1 ref2 =
          atomically $
            do
              x1 <- readTVar ref1
              x2 <- readTVar ref2
              writeTVar ref1 x2
              writeTVar ref2 x1

    increment a
    increment a
    increment b
    printVars "incremented"

    swap a b
    printVars "swapped"
