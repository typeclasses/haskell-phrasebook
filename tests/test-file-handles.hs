main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "file-handles"
    strLines x === [ "hello", "False", "world", "True" ]
