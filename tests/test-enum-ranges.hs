main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "enum-ranges"
    strLines x ===
        [ "[3,4,5,6,7,8]", "\"abcdefghijklmnopqrstuvwxyz\""
        , "[Rank2,Rank3,Rank4,Rank5,Rank6,Rank7,Rank8,Rank9,Rank10]"
        , "[Jack,Queen,King,Ace]", "Rank2", "Ace", "-128", "127"
        , "[Rank2,Rank3,Rank4,Rank5,Rank6,Rank7,Rank8,Rank9,Rank10,Jack,Queen,King,Ace]" ]
