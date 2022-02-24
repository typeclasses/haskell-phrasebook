import qualified Data.Map.Strict as Map

main = propertyMain $ withTests 1 $ property do
    let levels = ["INFO", "ERROR"]
    (output, fileOutputs) <- liftIO $ flip runContT pure do
        files <- Map.fromList <$> for levels \l -> do
            f <- ContT \c -> withSystemTempFile (l <> ".txt") \fp h -> hClose h *> c fp
            pure (l, f)
        output <- exeStdout (phrasebook "logging"){ exeEnv = files }
        fileOutputs <- for files readFileText
        pure (output, fileOutputs)

    strLines output === [ "(Boot info) Starting", "(App info) Application started" ]
    fmap lines fileOutputs === [("INFO", [ "Application started" ]), ("ERROR", [])]
