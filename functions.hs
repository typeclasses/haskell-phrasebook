next x = x + 1

hypotenuse x y = sqrt (x^2 + y^2)

greet name = "hello" ++ " " ++ name

greet2 :: String -> String
greet2 name = "hello" ++ " " ++ name

greetNext x = (next x, greet (show (next x)))

hello :: String -> String
hello "Olafur" = "hello, Olafur!"
hello "Rocamadour" = "hey!"
hello x = greet x

main =
  do
    putStrLn (show (next 4))
    putStrLn (show (next (next 4)))

    putStrLn (show (hypotenuse 3 4))

    putStrLn (greet "world")
    putStrLn (greet2 "world")

    putStrLn (show (greetNext 7))

    let (x, y) = greetNext 7
    putStrLn (show x)
    putStrLn y

    putStrLn (hello "Olafur")
    putStrLn (hello "Rocamadour")
    putStrLn (hello "Jane")
