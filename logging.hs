{-# LANGUAGE NamedFieldPuns #-}

import Control.Applicative ((<|>))
import Control.Exception.Safe (displayException, catchAny)
import Control.Monad (guard)
import Data.Foldable (fold)
import System.Directory (doesFileExist)
import System.IO (hPutStrLn, stderr)

data Log =
  Log {
    logInfo :: String -> IO (),
    logError :: String -> IO ()
  }

consoleLog =
  Log putStrLn (hPutStrLn stderr)

fileLog infoPath errPath =
  Log {
    logInfo = \str -> appendFile infoPath (str <> "\n"),
    logError = \str -> appendFile errPath (str <> "\n")
  }

instance Semigroup Log where
  log1 <> log2 = Log {
    logInfo = \str -> (logInfo log1 str *> logInfo log2 str),
    logError = \str -> (logError log1 str *> logError log2 str)
  }

instance Monoid Log where
  mempty = let noop _ = return () in Log noop noop

logFunc (Log {logInfo}) msg func input = do
  logInfo (msg <> ":\tinput:\t" <> show input)
  let output = func input
  logInfo (msg <> ":\toutput:\t" <> show output)
  return output

logAction (Log {logInfo, logError}) msg action = do
  logInfo (msg <> ":\tStarting")
  result <- catchAny (fmap Just action) $ \err -> do
    logError (msg <> ":\t" <> displayException err)
    return Nothing
  logInfo (msg <> ":\tDone")
  return result

main = do
  let guardedGetPath = do
        path <- getLine
        exists <- doesFileExist path
        guard exists <|> error "No such path"
        return path

  logInfo consoleLog "\nPath for log file?"
  infoPath <- logAction consoleLog "Log path" guardedGetPath

  logInfo consoleLog "\nPath for error file?"
  errPath <- logAction consoleLog "Error path" guardedGetPath

  logInfo consoleLog $
    "\nLog files: "
    <> show infoPath
    <>  ", "
    <> show errPath
    <> "\n"

  logInfo consoleLog "Continue (press [ENTER])?"
  _ <- getLine

  let appLog = consoleLog <> fold (fileLog <$> infoPath <*> errPath)

  n <- logFunc appLog "Plus 2" (+ 2) (5 :: Int)

  putStrLn ("\nThe answer was " <> show n)
