{-# LANGUAGE NamedFieldPuns #-}

import Control.Applicative ((<|>))
import Control.Exception.Safe (catchAny, displayException)
import Control.Monad (guard)
import Data.Foldable (fold)
import System.Directory (doesFileExist)
import System.IO (hPutStrLn, stderr)


data Log =
  Log {
    logInfo :: String -> IO (),
    logError :: String -> IO ()
  }


-- A log that writes to the console.
consoleLog =
  Log {
    logInfo = putStrLn,
    logError = hPutStrLn stderr
  }


-- A log that writes to the specified files.
fileLog infoPath errPath =
  Log {
    logInfo = appendFile infoPath . (<> "\n"),
    logError = appendFile errPath . (<> "\n")
  }


-- Add formatting to a log.
formattedLog topic log' =
  let
    Log {logInfo = logInfo', logError = logError'} = log'

    formatLogMessage lvl msg =
      fold ["[", lvl, " (", topic, ")]: ", msg]
  in
    Log {
      logInfo = logInfo' . formatLogMessage "INFO",
      logError = logError' . formatLogMessage "ERROR"
    }


-- Combine two logs.
instance Semigroup Log where
  log1 <> log2 = Log {
    logInfo = \str -> do
      logInfo log1 str
      logInfo log2 str,

    logError = \str -> do
      logError log1 str
      logError log2 str
  }


-- Adds logging to a function.
logFunction tag Log {logInfo} func input = do
  logInfo (tag <> ": input: " <> show input)
  let output = func input
  logInfo (tag <> ": output: " <> show output)
  return output


-- Adds logging to an action.
logAction tag Log {logInfo, logError} action = do
  logInfo (tag <> ": starting")

  action `catchAny` \err -> do
    logError (tag <> ": " <> displayException err)

  logInfo (tag <> ": done")


main = do
  let startupLog = formattedLog "Startup" consoleLog

  let infoLog = "./info.log"
  let errLog = "./error.log"

  logAction "check log files" startupLog $ do
    infoExists <- doesFileExist infoLog
    errorExists <- doesFileExist errLog
    guard (not infoExists && not errorExists) <|> do
      error $
        "Log files already exist! " <>
        "They maybe be modified if you continue!"

  putStrLn "Continue (press [ENTER])?"
  _ <- getLine

  let
    appLog = formattedLog "App" $
      consoleLog <> fileLog "./info.log" "./error.log"

  n <- logFunction "plus 2" appLog (+ 2) (5 :: Int)

  putStrLn ("The answer was " <> show n)
