ghci

potencia :: Int -> Int -> Int
potencia b 0 = 1
potencia b e = b * potencia b (e-1)
