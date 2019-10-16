{-# LANGUAGE ScopedTypeVariables #-}

import Data.Time.Clock
import Data.Time.Clock.POSIX
import Data.Time.Format

render format time =
    formatTime defaultTimeLocale format time

parse format str =
    parseTimeM acceptExtraWhitespace defaultTimeLocale format str

acceptExtraWhitespace = False

main =
  do
    now_utc :: UTCTime <- getCurrentTime
    putStrLn ("Now (UTC): " ++ show now_utc)

    now_posix :: POSIXTime <- getPOSIXTime
    putStrLn ("Now (POSIX): " ++ show now_posix)

    let Just (t1_utc :: UTCTime) =
            parse "%Y-%m-%d %H:%M:%S" "2038-01-19 03:14:07"
    putStrLn (show t1_utc)

    putStrLn (render "%Y-%m-%d" t1_utc)
    putStrLn (render "%I:%M %p" t1_utc)

    let t2_utc :: UTCTime = addUTCTime 15 t1_utc
    putStrLn (show t2_utc)
    putStrLn (show (t1_utc < t2_utc))

    let diff :: NominalDiffTime = diffUTCTime t2_utc t1_utc
    putStrLn (show diff)

    let t1_posix :: POSIXTime = utcTimeToPOSIXSeconds t1_utc
    putStrLn (show t1_posix)
    putStrLn (show (posixSecondsToUTCTime t1_posix))
