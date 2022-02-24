main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "functions"
    strLines x ===
        [ "5", "6", "5.0", "hello world", "hello world", "(8,\"hello 8\")"
        , "8", "hello 8", "hello, Olafur!", "hey!", "hello Jane" ]
