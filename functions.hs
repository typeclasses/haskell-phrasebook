vals = (3, 7)

f x = (x, x + 1)

g :: (Num a) => a -> (a, a)
g x = (x+1, x)

-- to show that type signatures are optional
greetings :: String -> String
greetings name = "hello" ++ " " ++ name

greet name = "hello" ++ " " ++ name

-- pattern matching
hello :: String -> String
hello "Olafur"     = "hello, Olafur!"
hello "Rocamadour" = "hey!"
hello _            = "Nice to meet you!"


myDouble  x = (if x > 145 then x else x*2) + 1
myDouble' x = if x > 145
                        then x
                        else x*2

-- show how to define functions using lambdas
notLambda = \x y -> x + y

-- recursion
factorial :: (Intergal a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n-1)


main =
  do
    let (a, b) = vals
    putStrLn (show a)
    putStrLn (show b)

    let (_, c) = f 4
    putStrLn (show c)

    let (d, _) = g 4
    putStrLn (show d)

    let y = myDouble 1
    putStrLn (show y)
    let y' = myDouble 146
    putStrLn (show y')
    let z = myDouble' 1
    putStrLn (show z)
    let z = myDouble' 146
    putStrLn (show z')

    putStrLn (greet "world")
    putStrLn (greetings "world")
    putStrLn (hello "Olafur")
    putStrLn (hello "Rocamadour")
    putStrLn (hello "Jane")

    let t = notLambda 1 2
    putStrLn (show t)

    let k = factorial 5
    putStrLn (show k)

    -- when lambdas are convenient
    map (\x -> x*x - 1) [1..5]
