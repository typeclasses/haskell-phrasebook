import qualified Data.Char as Char
import qualified Text.Megaparsec as P
import qualified Text.Megaparsec.Char as P

main = propertyMain $ withTests 1 $ property do
    let
        redact = replace $ fold @[]
            [ P.string "["
            , P.skipMany (P.satisfy (\x -> Char.isDigit x || x == ',')) $> "..."
            , P.string "]"
            ]
    x <- exeStdout $ phrasebook "transactions"
    fmap redact (strLines x) ===
        [ "[...]", "Total: 1000"
        , "[...]", "Total: 1000"
        , "[...]", "Total: 1000"
        , "[...]", "Total: 1000" ]
