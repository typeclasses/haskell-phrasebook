main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "variables"
    strLines x === [ "4", "one", "two", "True", "[1,2,3]" ]
