import qualified Data.Time as Time
import qualified Data.Time.Clock.POSIX as POSIX

main = do

  now <- Time.getCurrentTime
  print now

  let render = Time.formatTime Time.defaultTimeLocale
  putStrLn (render "%Y-%m-%d %H:%M:%S" now)

  let soon = Time.addUTCTime 15 now
  print soon

  let parse = Time.parseTimeM False Time.defaultTimeLocale
  y2038 <- parse "%Y-%m-%d %H:%M:%S" "2038-01-19 03:14:07"
  print (y2038 :: Time.UTCTime)

  let delta = Time.diffUTCTime y2038 now
  print delta

  posix <- POSIX.getPOSIXTime
  print posix

  print (POSIX.utcTimeToPOSIXSeconds now)
  print (POSIX.posixSecondsToUTCTime posix)
