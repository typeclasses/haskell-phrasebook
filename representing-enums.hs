{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE LambdaCase #-}

import GHC.Generics (Generic)
import Generics.Deriving.Enum (GEnum (genum))
import qualified Data.Map.Strict as Map

data Product = Basic | Standard | Super
  deriving stock (Generic, Show)
  deriving anyclass GEnum

data Frequency = Monthly | Annual
  deriving stock (Generic, Show)
  deriving anyclass GEnum

data Bill = Bill Product Frequency
  deriving stock (Generic, Show)
  deriving anyclass GEnum

data Rep a b =
  Rep
    { encode :: a -> b
    , decode :: b -> Maybe a
    }

genumRep :: (GEnum a, Ord b) => (a -> b) -> Rep a b
genumRep encode =
  let
    reverseMap = foldMap (\a -> Map.singleton (encode a) a) genum
  in
    Rep
      { encode = encode
      , decode = \b -> Map.lookup b reverseMap
      }

main =
  do
    let
        productId = genumRep $ \case
            Basic    -> "basic"
            Standard -> "normal"
            Super    -> "super"

    putStrLn (encode productId Basic)
    putStrLn (encode productId Standard)

    putStrLn (show (decode productId "basic"))
    putStrLn (show (decode productId "extra"))

    let
        billingCode = genumRep $ \case
            Bill Basic    Monthly -> 10
            Bill Basic    Annual  -> 11
            Bill Standard Monthly -> 20
            Bill Standard Annual  -> 21
            Bill Super    Monthly -> 30
            Bill Super    Annual  -> 31

    putStrLn (show (encode billingCode (Bill Basic Annual)))
    putStrLn (show (encode billingCode (Bill Super Monthly)))

    putStrLn (show (decode billingCode 31))
    putStrLn (show (decode billingCode 50))
