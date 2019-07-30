import Data.Time

data ServicePlan = Free | Monthly | Annual

billAmount plan =
  case plan of
    Free    -> 0
    Monthly -> 5
    Annual  -> billAmount Monthly * 12

main =
  do
    let i = 2
    putStr ("Write " ++ show i ++ " as ")
    case i of
        1 -> putStrLn "one"
        2 -> putStrLn "two"
        3 -> putStrLn "three"
        _ -> putStrLn "unknown number."

    now <- getZonedTime
    case
      (todHour (localTimeOfDay (zonedTimeToLocalTime now)) < 12) of
      True  -> putStrLn "It's before noon"
      False -> putStrLn "It's after noon"




