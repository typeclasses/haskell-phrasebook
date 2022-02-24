main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "invert"
    strLines x ===
        [ "p1", "p2", "Just Basic", "Nothing", "11", "30"
        , "Just (Bill Pro Annual)", "Nothing" ]
