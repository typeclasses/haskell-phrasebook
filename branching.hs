import Data.Time

timeNow now =
  case
  (todHour (localTimeOfDay (zonedTimeToLocalTime now)) < 12)
  of
      True  -> putStrLn "It's before noon"
      False -> putStrLn "It's after noon"


data ServicePlan = Free | Monthly | Annual

billAmount plan =
  case plan of
    Free    -> 0
    Monthly -> 5
    Annual  -> billAmount Monthly * 12


writeNumber i =
  case i of
    1 -> "one"
    2 -> "two"
    3 -> "three"
    _ -> "unknown number."


main =
  do
    now <- getZonedTime
    timeNow now

    let plan = Free
    putStrLn
      ("Customer owes " ++ (show (billAmount plan)) ++ " dollars.")

    let i = 2
    putStrLn
      ("Write " ++ show i ++ " as " ++ (writeNumber i))





