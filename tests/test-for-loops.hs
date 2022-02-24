main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "for-loops"
    strLines x ===
        [ "Numbers: 1 2 3 4 5", "Odds: 1 3 5", "Odds: 1 3 5", "1 2 3 (sum: 60)" ]
