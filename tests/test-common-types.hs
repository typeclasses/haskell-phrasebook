main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "common-types"
    strLines x ===
        [ "haskell", "1+1 = 2", "7.0/3.0 = 2.3333333333333335"
        , "False", "True", "False" ]
