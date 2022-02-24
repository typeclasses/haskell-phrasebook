main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "dynamic"
    strLines x ===
        [ "The answer is yes", "5 is an integer", "Unrecognized type: [Char]" ]
