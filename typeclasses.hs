class Playable a where
  healingPower :: a -> Double

data Warrior =
  Warrior
    { warriorName :: String
    }

instance Playable Warrior where
  healingPower _warrior = 1

data Mage =
  Mage
   { mageName :: String
   , wizardingPower :: Double
   }

instance Playable Mage where
  healingPower mage = wizardingPower mage * 0.5

chris = Warrior { warriorName = "Chris" }
julie = Mage { mageName = "Julie", wizardingPower = 9000 }

main = do
  putStr "Julie's Healing Power: "
  print $ healingPower julie

  putStr "Chris' Healing Power: "
  print $ healingPower chris
