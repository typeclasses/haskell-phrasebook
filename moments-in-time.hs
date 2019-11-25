{-# LANGUAGE ScopedTypeVariables #-}

import qualified Data.Time as T
import qualified Data.Time.Clock.POSIX as T

timeToString format time =
    T.formatTime T.defaultTimeLocale format time

stringToTime format string =
    T.parseTimeM acceptExtraWhitespace
      T.defaultTimeLocale format string
  where
    acceptExtraWhitespace = False

main =
  do
    (now_utc :: T.UTCTime) <- T.getCurrentTime
    putStrLn ("Now (UTC): " ++ show now_utc)

    (now_posix :: T.POSIXTime) <- T.getPOSIXTime
    putStrLn ("Now (POSIX): " ++ show now_posix)

    let t1_string = "2038-01-19 03:14:07"
    (t1_utc :: T.UTCTime) <-
        stringToTime "%Y-%m-%d %H:%M:%S" t1_string
    putStrLn (show t1_utc)

    putStrLn (timeToString "%Y-%m-%d" t1_utc)
    putStrLn (timeToString "%I:%M %p" t1_utc)

    let (t2_utc :: T.UTCTime) = T.addUTCTime 15 t1_utc
    putStrLn (show t2_utc)
    putStrLn (show (t1_utc < t2_utc))

    let (diff :: T.NominalDiffTime) = T.diffUTCTime t2_utc t1_utc
    putStrLn (show diff)

    let (t1_posix :: T.POSIXTime) = T.utcTimeToPOSIXSeconds t1_utc
    putStrLn (show t1_posix)
    putStrLn (show (T.posixSecondsToUTCTime t1_posix))
