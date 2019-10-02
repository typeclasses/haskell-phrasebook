import Data.Foldable (foldMap, fold, foldl')

-- Combining integers to a sum with a left fold
sumList xs = foldl' sum 0 xs
  where
    sum acc x = x + acc

-- Combines the list by using a function applied to every argument 
-- and accumulating the results, left associatively.
foldLeftStrings xs = foldl' commaSep "" xs
  where
    commaSep "" x = "" ++ x
    commaSep acc x = acc ++ ", " ++ x

-- Applies a simple function to a list, and combines the results. Less expressive.
foldMapStrings xs = foldMap commaSep xs
  where
    commaSep s = s ++ ", "

main = do
  let xs = [1 .. 5]
  putStrLn $ "Numbers: " ++ show xs
  putStrLn $ "Sum: " ++ show (sumList xs)  ++ "\n"

  let words = ["One", "Two", "Three", "Four", "Five"]
  putStrLn $ "Printing list using show:\n" 
           ++ show words ++ "\n"

  putStrLn $ "The default fold appends elements if possible:\n" 
           ++ fold words ++ "\n"

  putStrLn $ "Combining with our foldl' funtion:\n" 
           ++ foldLeftStrings words ++ "\n"

  putStrLn $ "Combining with the foldMap function:\n" 
           ++ foldMapStrings words
