import qualified Data.Set as Set

main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "threads"
    xs <- pure $ strLines x

    take 3 xs === [ "main: 1", "main: 2", "main: 3" ]
    Set.fromList ((take 6 . drop 3) xs) ===
        [ "forkA: 1", "forkA: 2", "forkA: 3"
        , "forkB: 1", "forkB: 2", "forkB: 3" ]
    drop 9 xs === ["done"]
