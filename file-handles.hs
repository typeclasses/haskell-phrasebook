import System.IO
import System.Directory

main =
  do
    h <- openFile "hello.txt" WriteMode

    hPutStrLn h "hello"
    hPutStrLn h "world"

    hClose h

    h <- openFile "hello.txt" ReadMode

    line <- hGetLine h
    putStrLn line

    atEnd <- hIsEOF h
    putStrLn (show atEnd)

    line <- hGetLine h
    putStrLn line

    atEnd <- hIsEOF h
    putStrLn (show atEnd)

    removeFile "hello.txt"
