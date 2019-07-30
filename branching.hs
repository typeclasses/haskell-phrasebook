import Data.Time

main =
  do
    let i = 2
    putStr ("Write " ++ show i ++ " as ")
    case i of
        1 -> putStrLn "one"
        2 -> putStrLn "two"
        3 -> putStrLn "three"
        otherwise -> putStrLn "This is an Arby's"

    now <- getZonedTime
    case (dayOfWeek (localDay (zonedTimeToLocalTime now))) of
        Saturday -> putStrLn "It's the weekend"
        Sunday   -> putStrLn "It's the weekend"
        _        -> putStrLn "It's a weekday"

    case (todHour (localTimeOfDay (zonedTimeToLocalTime now)) < 12) of
        True  -> putStrLn "It's before noon"
        False -> putStrLn "It's after noon"