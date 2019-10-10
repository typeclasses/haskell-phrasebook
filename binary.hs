binario :: Int->[Int]
binario 1 = [1]
binario m = binario (div m 2) ++ [m `mod` 2]