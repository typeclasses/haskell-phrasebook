main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "if-else"
    strLines x ===
        [ "7 is odd"
        , "8 is divisible by 4"
        , "9 has 1 digit"
        , "19 has multiple digits"
        ]
