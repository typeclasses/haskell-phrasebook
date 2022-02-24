main = propertyMain $ withTests 1 $ property do
    exe <- build "monitoring"

    (_, Just serverOut, _, server) <- liftIO $
        createProcess (proc exe ["aggregate-reports"]){ std_out = CreatePipe }

    liftIO (hGetLine serverOut) >>= (=== "The monitoring server has started.")

    sender <- liftIO $ spawnProcess exe ["send-demo-reports"]
    liftIO (waitForProcess sender) >>= (=== ExitSuccess)
    liftIO $ terminateProcess server
    liftIO (waitForProcess server) >>= (=== ExitSuccess)

    x <- liftIO $ hGetContents serverOut
    strLines x ===
        [ "1 (success)", "1 (success)", "1 (success)", "1 (success)"
        , "1 (success)", "1 (success)", "1 (success)", "1 (success)"
        , "1 (success)", "1 (success)"
        , "System status is normal."
        , "1 (success)", "1 (success)", "1 (success)", "0 (failure)"
        , "1 (success)", "0 (failure)", "0 (failure)", "1 (success)"
        , "1 (success)", "0 (failure)", "0 (failure)"
        , "Alarm! System is in a degraded state."
        , "0 (failure)", "0 (failure)", "0 (failure)", "1 (success)"
        , "0 (failure)", "0 (failure)", "0 (failure)", "0 (failure)"
        , "0 (failure)", "0 (failure)", "1 (success)", "0 (failure)"
        , "0 (failure)", "0 (failure)", "1 (success)", "1 (success)"
        , "1 (success)", "0 (failure)", "1 (success)", "1 (success)"
        , "1 (success)", "1 (success)", "1 (success)"
        , "System status is normal."
        , "1 (success)", "0 (failure)", "1 (success)", "1 (success)"
        , "1 (success)", "1 (success)", "1 (success)", "1 (success)"
        , "The monitoring server is stopping." ]
