main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "hashing"
    strLines x === [ "-2971258545394699232", "-2788793491217597546" ]
