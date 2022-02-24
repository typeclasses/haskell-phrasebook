main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "timeouts"
    strLines x ===
        [ "Task A: Gave up after one second"
        , "Task B: Completed in half a second" ]
