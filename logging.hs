import Control.Exception.Safe (displayException, tryAny)
import Data.Foldable (fold)
import System.Directory (getPermissions, writable)
import System.Environment (getEnv)
import System.IO (hPutStr, stdout, stderr)

data Level = Info | Error

data Event = Event Level String

data Log = Log { record :: Event -> IO () }

consoleLog = Log $ \(Event level message) ->
    hPutStr (standardStream level) (message <> "\n")

standardStream Info = stdout
standardStream Error = stderr

fileLog path = Log $ \(Event level message) ->
    appendFile (path level) (message <> "\n")

formattedLog topic log = Log $ \event ->
    record log (formatEvent topic event)

formatEvent topic (Event level msg) = Event level msg'
  where
    msg' = paren (topic ! levelString level) ! msg

paren x = "(" <> x <> ")"

x ! y = x <> " " <> y

levelString Info = "info"
levelString Error = "error"

nullLog = Log (\_ -> return ())

multiLog log1 log2 = Log $ \event ->
  do
    record log1 event
    record log2 event

instance Semigroup Log where (<>) = multiLog
instance Monoid Log where mempty = nullLog

recoverFromException log action =
  do
    result <- tryAny action

    case result of
        Left e ->
          do
            record log (Event Error (displayException e))
            return Nothing
        Right x ->
            return (Just x)

main =
  do
    let bootLog = formattedLog "Boot" consoleLog
    record bootLog (Event Info "Starting")
    fileLog <- recoverFromException bootLog initFileLog

    let appLog = formattedLog "App" consoleLog <> fold fileLog
    record appLog (Event Info "Application started")

    -- ...

initFileLog =
  do
    infoPath <- envLogPath "INFO"
    errorPath <- envLogPath "ERROR"

    let
        path Info = infoPath
        path Error = errorPath

    return (fileLog path)

envLogPath varName =
  do
    path <- getEnv varName
    assertWritable path
    return path

assertWritable path =
  do
    permissions <- getPermissions path
    case writable permissions of
        True -> return ()
        False -> fail ("Log path" ! path ! "is not writable")
