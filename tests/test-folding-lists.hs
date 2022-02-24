main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "folding-lists"
    strLines x ===
        [ "[1,2,3,4,5]", "15", "One, Two, Three, Four, Five"
        , "  - One", "  - Two", "  - Three", "  - Four", "  - Five"
        , "OneTwoThreeFourFive" ]
