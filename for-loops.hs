import Data.Foldable (for_)
import Data.Traversable (for)

import Control.Monad (when)

main =
  do
    putStr "Numbers:"
    for_ [1..5] $ \i ->
      do
        putStr " "
        putStr (show i)
    putStr "\n"

    putStr "Odds:"
    for_ [1..5] $ \i ->
        when (odd i) $
          do
            putStr " "
            putStr (show i)
    putStr "\n"

    putStr "Odds:"
    for_ (filter odd [1..5]) $ \i ->
      do
        putStr " "
        putStr (show i)
    putStr "\n"

    tens <-
      for [1..3] $ \i ->
        do
          putStr (show i ++ " ")
          return (i * 10)
    putStr ("(sum: " ++ show (sum tens) ++ ")\n")
