primo :: Int -> Bool
primo n
 | n < 3                 = True
 | otherwise             = primoAux n (n-1)

primoAux :: Int -> Int -> Bool
primoAux n m
 | m < 2                 = True
 | n `mod` m == 0        = False
 | otherwise             = primoAux n (m-1)