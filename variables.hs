main =
  do
    let x = 2
    putStrLn (show (x + x))

    let (b, c) = ("one", "two")
    putStrLn b
    putStrLn c

    let
        d = True
        e = [1,2,3]
    putStrLn (show d)
    putStrLn (show e)
