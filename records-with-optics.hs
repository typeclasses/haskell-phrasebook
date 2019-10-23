{-# LANGUAGE TemplateHaskell #-}

import Optics

data Address =
  Address
    { _city    :: String
    , _country :: String
    }
  deriving (Show)

makeLenses ''Address

data Person =
  Person
    { _name    :: String
    , _age     :: Int
    , _address :: Address
    }
  deriving (Show)

makeLenses ''Person

main =
  do
    let alice =
          Person
            { _name = "Alice"
            , _age = 30
            , _address = Address "Faketown" "Fakeland"
            }

    print alice
    print (set age 40 alice)
    print (over age (+ 1) alice)
    print (view age alice)
    print (view (address % city) alice)
    print (set (address % city) "Fakeville" alice)
