{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DerivingStrategies #-}

import Data.Hashable (Hashable (hash))
import Data.Word (Word8)
import GHC.Generics (Generic)

data Color =
    Color
        { red   :: Word8
        , green :: Word8
        , blue  :: Word8
        }
    deriving stock (Show, Generic)
    deriving anyclass (Hashable)

main =
  do
    putStrLn (show (hash (Color 255 0 0)))
    putStrLn (show (hash (Color 0 255 0)))
