import Data.Dynamic
import Data.Foldable

mixedList =
    [ toDyn True
    , toDyn (5 :: Integer)
    , toDyn "hey"
    ]

main =
    for_ mixedList $ \d ->
        putStrLn (message d)

recognizeType d =
  asum
    [ (fromDynamic d :: Maybe Integer) >>= \x ->
        Just (show x ++ " is an integer")
    , (fromDynamic d :: Maybe Bool) >>= \x ->
        Just ("The answer is " ++ (if x then "yes" else "no"))
    ]

message d =
    case (recognizeType d) of
        Just x -> x
        Nothing -> "Unrecognized type: " ++ show (dynTypeRep d)
