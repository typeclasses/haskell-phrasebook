main = propertyMain $ withTests 1 $ property do
    x <- exeStdout $ phrasebook "bounded-queues"
    strLineSet x ===
        [ "start: 1", "start: 2", "start: 3", "start: 4", "start: 5"
        , "start: 6", "start: 7", "start: 8", "start: 9", "start: 10"
        , "finish: 1, result: 1", "finish: 2, result: 4"
        , "finish: 3, result: 9", "finish: 4, result: 16"
        , "finish: 5, result: 25", "finish: 6, result: 36"
        , "finish: 7, result: 49", "finish: 8, result: 64"
        , "finish: 9, result: 81", "finish: 10, result: 100" ]
