{-# LANGUAGE TypeApplications #-}

import Data.Int (Int8)

data Rank =
      Rank2
    | Rank3
    | Rank4
    | Rank5
    | Rank6
    | Rank7
    | Rank8
    | Rank9
    | Rank10
    | Jack
    | Queen
    | King
    | Ace
    deriving (Bounded, Enum, Show)

main =
  do
    putStrLn (show [3 .. 8])
    putStrLn (show ['a' .. 'z'])

    putStrLn (show [Rank2 .. Rank10])
    putStrLn (show [Jack ..])

    putStrLn (show (minBound @Rank))
    putStrLn (show (maxBound @Rank))

    putStrLn (show (minBound @Int8))
    putStrLn (show (maxBound @Int8))

    putStrLn (show [minBound @Rank .. maxBound @Rank])
