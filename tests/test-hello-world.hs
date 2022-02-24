main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "hello-world"
    strLines x === [ "hello world" ]
