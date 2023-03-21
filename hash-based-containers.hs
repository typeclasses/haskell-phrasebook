{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE RecordWildCards #-}

import Data.Hashable (Hashable)
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as HashMap
import Data.Maybe
import GHC.Generics (Generic)

data Movie
  = Movie
  { title :: String
  , director :: String
  , imdbRating :: Int
  }
  deriving stock (Show, Eq, Generic)
  deriving anyclass (Hashable)

scores :: HashMap Movie Int
scores = HashMap.fromList $ mapMaybe rankingForMovie movies
  where
    rankingForMovie m@Movie{..} = case HashMap.lookup title numRaters of
      Just raters -> Just $ (m, raters * imdbRating)
      Nothing -> Nothing

numRaters :: HashMap String Int
numRaters = HashMap.fromList
  [ ("Pulp Fiction", 16000000), ("Fight Club", 17000000)]

movies :: [Movie]
movies =
  [ Movie "Pulp Fiction" "Quentin Tarantino" 9
  , Movie "Fight Club" "David Fincher" 9
  , Movie "Okja" "Joon-ho Bong" 8
  ]

main =
  mapM_ (\m@Movie{..} -> do
    case HashMap.lookup m scores of
      Nothing -> putStrLn $ "Score for " ++ title ++ " unavailable"
      Just score -> putStrLn $ "Score for " ++ title ++ ": " ++ show score) movies