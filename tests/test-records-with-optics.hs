main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "records-with-optics"
    strLines x ===
        [ "Person {_name = \"Alice\", _age = 30, _address = Address {_city = \"Faketown\", _country = \"Fakeland\"}}"
        , "Person {_name = \"Alice\", _age = 40, _address = Address {_city = \"Faketown\", _country = \"Fakeland\"}}"
        , "Person {_name = \"Alice\", _age = 31, _address = Address {_city = \"Faketown\", _country = \"Fakeland\"}}"
        , "30"
        , "\"Faketown\""
        , "Person {_name = \"Alice\", _age = 30, _address = Address {_city = \"Fakeville\", _country = \"Fakeland\"}}" ]
