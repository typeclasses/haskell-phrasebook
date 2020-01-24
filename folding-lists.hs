import Data.Foldable (foldr, foldMap, fold)
import Prelude hiding (sum)

sum :: [Integer] -> Integer
sum xs = foldr (+) 0 xs

commaList :: [String] -> String
commaList xs = foldr commaSep "" xs
  where
    commaSep x "" = x
    commaSep x phrase = x ++ ", " ++ phrase

bulletList :: [String] -> String
bulletList xs = foldMap bulletItem xs
  where
    bulletItem x = "  - " ++ x ++ "\n"

smashTogether :: [String] -> String
smashTogether xs = fold xs

main =
  do
    let numbers = enumFromTo 1 5
    putStrLn (show numbers)
    putStrLn (show (sum numbers))

    let words = ["One", "Two", "Three", "Four", "Five"]
    putStrLn (commaList words)
    putStr (bulletList words)
    putStrLn (smashTogether words)
