main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "crypto-hashing"
    strLines x ===
        [ "sha256(abc)   = ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad"
        , "sha256(hello) = 2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824" ]
