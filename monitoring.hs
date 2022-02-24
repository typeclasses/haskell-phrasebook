{-# LANGUAGE NumericUnderscores, TypeApplications #-}

import qualified Network.Socket as S
import Network.Socket.ByteString (recv, sendAll)

import Control.Exception.Safe

import qualified Data.ByteString as BS
import qualified Data.ByteString.Char8

import System.Environment
import System.Exit
import System.IO
import System.Signal

import Control.Concurrent
import Control.Concurrent.Async
import Control.Concurrent.STM

import qualified Data.Sequence as Seq
import Data.Ratio ((%))

import Control.Monad (forever, when)
import Data.Foldable (asum, for_, find)
import Data.Maybe (mapMaybe)

-- An event report represents the result of a single action.
data EventReport = Success | Failure
    deriving Eq

-- The system status is an overview of whether, in general, actions tend to be succeeding or failing.
data SystemStatus = Okay | Alarm
    deriving Eq

main =
  do
    hSetBuffering stdout LineBuffering

    args <- getArgs

    case args of
        ["aggregate-reports"]  -> aggregateReportsMain
        ["send-demo-reports"]  -> sendDemoReportsMain
        _                      -> die "Invalid args"

aggregateReportsMain =
    withServerSocket $ \serverSocket ->
      do
        putStrLn "The monitoring server has started."

        reportQueue <- atomically newTQueue
        alarmQueue <- atomically newTQueue

        foldr1 race_
          [ receiveReports serverSocket reportQueue
          , analyzeReports reportQueue alarmQueue
          , sendAlarms alarmQueue
          , waitForTerminationSignal
          ]

        putStrLn "The monitoring server is stopping."

waitForTerminationSignal =
  do
    terminate <- atomically (newTVar False)
    installHandler sigTERM $ \_signal ->
        atomically (writeTVar terminate True)
    atomically (readTVar terminate >>= check)


---  Message format  ---

encodeReport r =
    case r of
        Failure -> '0'
        Success -> '1'

decodeReport c =
    find (\r -> encodeReport r == c) [Failure, Success]


---  Receiving event reports  ---

serverAddress = S.SockAddrUnix "\0haskell-phrasebook/monitoring"

openSocket = S.socket S.AF_UNIX S.Stream S.defaultProtocol

withServerSocket action =
    bracket openSocket S.close $ \serverSocket ->
      do
        S.bind serverSocket serverAddress
        S.listen serverSocket S.maxListenQueue
        action serverSocket

receiveReports serverSocket reportQueue =
    forever $
      mask $ \unmask ->
        do
          (clientSocket, _clientAddr) <- S.accept serverSocket

          forkFinally
              (unmask (receiveReports' clientSocket reportQueue))
              (\_ -> S.close clientSocket)

receiveReports' clientSocket reportQueue = continue
  where
    continue =
      do
        receivedBytes <- recv clientSocket 1024

        case BS.length receivedBytes of
            0 -> return ()
            _ ->
              do
                receiveReports'' receivedBytes reportQueue
                continue

receiveReports'' receivedBytes reportQueue =
    for_ @[] (Data.ByteString.Char8.unpack receivedBytes) $ \c ->
        for_ @Maybe (decodeReport c) $ \r -> do
            putStrLn (case r of Success -> "1 (success)"
                                Failure -> "0 (failure)")
            atomically (writeTQueue reportQueue r)


---  Analysis of system status changes using event reports  ---

reportWindowSize = 10
okayThreshold = 80 % 100
alarmThreshold = 50 % 100

analysis reports
    | Seq.length reports < reportWindowSize = Nothing
    | successRate <= alarmThreshold         = Just Alarm
    | successRate >= okayThreshold          = Just Okay
    | otherwise                             = Nothing
  where
    successes = Seq.filter (== Success) reports
    successRate = Seq.length successes % Seq.length reports

analyzeReports reportQueue alarmQueue = continue Nothing Seq.empty
  where
    continue status reports =
      do
        newReport <- atomically (readTQueue reportQueue)

        let reports' = Seq.take reportWindowSize
                        (newReport Seq.<| reports)

        let status' = asum [analysis reports', status]

        for_ @Maybe status' $ \s ->
            when (status /= status') $
                atomically (writeTQueue alarmQueue s)

        continue status' reports'


---  Sending alerts about system status changes  ---

sendAlarms alarmQueue =
  forever $
    do
      a <- atomically (readTQueue alarmQueue)
      case a of
          Alarm -> putStrLn "Alarm! System is in a degraded state."
          Okay -> putStrLn "System status is normal."


---  Client that sends event reports to an aggregation service  ---

sendDemoReportsMain =
  do
    reportQueue <- atomically newTQueue

    foldr1 race_
      [ generateReports reportQueue
      , sendReports reportQueue
      ]


---  A fixed schedule of event reports for demonstration purposes  ---

demoReports = mapMaybe decodeReport
    "1111111111111010011000001000000100011101111110111111"
    -- successes --     -- failures --    -- successes --

generateReports reportQueue =
    for_ demoReports $ \r ->
      do
        atomically (writeTQueue reportQueue r)
        threadDelay 100_000


---  Sending reports to the server  ---

withClientSocket action =
    bracket openSocket S.close $ \clientSocket ->
      do
        S.connect clientSocket serverAddress
        action clientSocket

sendReports reportQueue =
    withClientSocket $ \clientSocket ->
        forever $
          do
            r <- atomically (readTQueue reportQueue)
            sendAll clientSocket
                (Data.ByteString.Char8.pack [encodeReport r])
