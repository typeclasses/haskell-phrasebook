main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "mutable-references"
    strLines x ===
        [ "a = 3, b = 5 (initial values)"
        , "a = 7, b = 5 (changed a to 7)"
        , "a = 7, b = 10 (doubled b)"
        , "a = 8, b = 15 (incremented)"
        , "a = 15, b = 8 (swapped)" ]
