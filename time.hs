import qualified Data.Time as Time

main = do

  now <- Time.getZonedTime
  print now

  let then_ = Time.ZonedTime
        (Time.LocalTime
          (Time.fromGregorian 2009 11 17)
          (Time.TimeOfDay 20 34 58.651387237))
        Time.utc
  print then_

  let (year, month, day) = Time.toGregorian
        (Time.localDay (Time.zonedTimeToLocalTime then_))
  print year
  print month
  print day
  print (Time.todHour (Time.localTimeOfDay (Time.zonedTimeToLocalTime then_)))
  print (Time.todMin (Time.localTimeOfDay (Time.zonedTimeToLocalTime then_)))
  print (Time.todSec (Time.localTimeOfDay (Time.zonedTimeToLocalTime then_)))
  print (Time.zonedTimeZone then_)

  print (Time.dayOfWeek (Time.localDay (Time.zonedTimeToLocalTime then_)))

  print (Time.zonedTimeToUTC then_ < Time.zonedTimeToUTC now)
  print (Time.zonedTimeToUTC then_ > Time.zonedTimeToUTC now)
  print (Time.zonedTimeToUTC then_ == Time.zonedTimeToUTC now)

  let diff = Time.diffUTCTime
        (Time.zonedTimeToUTC now) (Time.zonedTimeToUTC then_)
  print diff

  print (Time.nominalDiffTimeToSeconds diff / 60 / 60)
  print (Time.nominalDiffTimeToSeconds diff / 60)
  print (Time.nominalDiffTimeToSeconds diff)

  print (Time.addUTCTime diff (Time.zonedTimeToUTC then_))
  print (Time.addUTCTime (-diff) (Time.zonedTimeToUTC then_))
