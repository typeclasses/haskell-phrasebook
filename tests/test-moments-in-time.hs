import qualified Text.Megaparsec as P
import qualified Text.Megaparsec.Char as P

main = propertyMain $ withTests 1 $ property do
    let
        redact = replace $ fold @[]
            [ match $ P.string "Now " *> P.skipManyTill P.anySingle (P.string ": ")
            , P.takeRest $> "..."
            ]
    output <- exeStdout $ phrasebook "moments-in-time"
    fmap redact (strLines output) ===
        [ "Now (UTC): ...", "Now (POSIX): ..."
        , "2038-01-19 03:14:07 UTC", "2038-01-19", "03:14 AM", "2038-01-19 03:14:22 UTC"
        , "True", "15s", "2147483647s", "2038-01-19 03:14:07 UTC" ]
