import Data.Time.Calendar

-- playing cards
data Rank = Rank2 | Rank3 | Rank4 | Rank5 | Rank6 | Rank7
          | Rank8 | Rank9 | Rank10 | Jack | Queen | King | Ace
            deriving (Bounded, Enum, Eq, Ord)

-- to be able to print them
instance Show Rank where
  show Rank2  = "Rank2"
  show Rank3  = "Rank3"
  show Rank4  = "Rank4"
  show Rank5  = "Rank5"
  show Rank6  = "Rank6"
  show Rank7  = "Rank7"
  show Rank8  = "Rank8"
  show Rank9  = "Rank9"
  show Rank10 = "Rank10"
  show Jack   = "Jack"
  show Queen  = "Queen"
  show King   = "King"
  show Ace    = "Ace"



main =
  do
    putStrLn (show [3 .. 8])
    putStrLn (show ['a' .. 'z'])
    putStrLn (show [Tuesday .. Friday])
    putStrLn (show [Rank2 .. Rank10])
    putStrLn (show [Jack ..])
    putStrLn (show [(minBound :: Rank) .. (maxBound :: Rank)])
  
