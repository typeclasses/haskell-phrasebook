import qualified Text.Megaparsec as P
import qualified Text.Megaparsec.Char as P

main = propertyMain $ withTests 1 $ property do
    let
        redact = replace $ fold @[]
            [ P.string "It's "
            , P.skipMany (P.satisfy (/= ' ')) $> "..."
            , P.string " noon"
            ]
    x <- exeStdout $ phrasebook "branching"
    fmap redact (strLines x) ===
        [ "It's ... noon", "Customer owes 0 dollars.", "Write 2 as two" ]
