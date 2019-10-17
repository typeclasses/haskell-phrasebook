-- C# style languages have the a ? b : c construct.
-- This can be replicated in Haskell as if a then b else c
-- However, there's another way and it involves a bunch of functions
-- that don't really look that promising at first.

-- One is guard
-- guard :: Alternative f => Bool -> f ()

import Control.Monad(guard)

-- If we assume "Alternative" means "Maybe", this function returns Just () when bool is true and Nothing when bool is false.  Doesn't look that useful.

-- There's also this weird function that's attached to functor in the Prelude
-- (<$) :: Functor f => a -> f b -> f a

import Prelude((<$), Int, String, Maybe, IO, putStrLn, (<$>), (.), show, rem, (==)) -- You don't need this line
-- which is like <$> only with a constant instead of a function. Again, that doesn't sound -- that useful, but what if you didn't care about the original values because the original -- value was () to begin with? Then we could write something like this:

-- Alternative also has this useful function:
-- (<|>) :: Alternative f => f a -> f a -> f a

import Control.Applicative((<|>))

-- Again, if we just consider "Maybe" this means "if the first thing is Nothing, return the second thing, otherwise return the first".

-- Finally, let's grab a useful function from Data.Maybe
-- fromMaybe :: a -> Maybe a -> a

import Data.Maybe(fromMaybe)

-- This returns the second thing if it's "Just" or the first thing if the second thing is "Nothing".

-- Finally, we need something that runs a function on a list and throws away the result.

import Data.Foldable(for_)

fizz :: Int -> Maybe String
fizz n = "Fizz" <$ guard (n `rem` 3 == 0)

-- Remember that there's lazy semantics going on here. If "Fizz" is expensive to
-- evaluate, it doesn't matter because the guard expression will be evaluated first.
-- In fact, when this is compiled, it will end up as pretty much the same code
-- as a raw if statement.

-- We could write the other components of FizzBuzz easily enough

buzz :: Int -> Maybe String
buzz n = "Buzz" <$ guard (n `rem` 5 == 0)

fizzbuzz :: Int -> Maybe String
fizzbuzz n = "FizzBuzz" <$ guard (n `rem` 15 == 0)

-- You might be wondering if you can get the repetition in this code down.
-- The answer is yes, but that requires the reader monad trick that we won't
-- employ here.

-- <|> can be used to combine Maybes so we can now write fizzbuzz n <|> buzz n <|> fizz n
-- *But* this is still "Maybe String" not "String", which is what FizzBuzz actually wants

-- To get a String back out of Maybe, we use `fromMaybe`. We just need to provide the "otherwise" clause

toString :: Int -> String
toString n = fromMaybe (show n) (fizzbuzz n <|> buzz n <|> fizz n)

-- Again, without lazy evaluation this would be horribly inefficient, but GHC will
-- turn this into pretty efficient code.

-- All we need to do now is print the numbers.

main :: IO ()
main = for_ [1..100] (putStrLn . toString)