module PhrasebookTesting
    (
      propertyMain

    -- * Running example programs
    , phrasebook, Exe (..), exeStdout, build, runCreateProcess

    -- * Working with lines of text
    , strLines, strLineSet, P, replace, match

    -- * Reexports
    , module Prelude
    , module Hedgehog
    , module Control.Monad.Cont
    , module System.Process
    , ExitCode (..), for, hClose, withSystemTempFile, hGetLine, hGetContents
    ) where

import System.Process
import System.Process ()
import Hedgehog
import qualified Data.Set as Set
import Control.Monad.Cont
import System.IO
import System.Exit (ExitCode (..))
import System.Environment
import Data.Traversable
import System.IO.Temp
import qualified Data.Map.Strict as Map
import qualified Data.List as List
import qualified Text.Megaparsec as P

propertyMain :: Property -> IO ()
propertyMain prop = do
    ok <- check prop
    when (not ok) exitFailure

data Exe = Exe{ exeName :: String, exeEnv :: Map String String, exeArgs :: [String] }

phrasebook :: String -> Exe
phrasebook x = Exe{ exeName = x, exeEnv = mempty, exeArgs = mempty }

setCreateProcessEnv :: MonadIO m => Map String String -> CreateProcess -> m CreateProcess
setCreateProcessEnv extra cp = do
    current <- Map.fromList <$> liftIO getEnvironment
    pure cp{ env = Just $ Map.toList $ extra <> current }

runCreateProcess :: MonadIO m => CreateProcess -> m ()
runCreateProcess p = liftIO $ withCreateProcess p mempty

build :: MonadIO m => String -> m FilePath
build x = liftIO do
    callProcess "cabal"
        [ "build", "--ghc-options", "-Werror", x ]
    fmap (toString . List.head . lines . toText) $
        readProcess "cabal" ["list-bin", x] ""

-- | Run a phrasebook example and return what it prints to stdout.
exeStdout :: MonadIO m => Exe -> m String
exeStdout exe = do
    e <- build $ exeName exe
    cp <- setCreateProcessEnv (exeEnv exe) $ proc e (exeArgs exe)
    liftIO $ readCreateProcess cp ""

strLines :: String -> [Text]
strLines = lines . toText

strLineSet :: String -> Set Text
strLineSet = Set.fromList . strLines

type P a = P.Parsec Void Text a

match :: P a -> P Text
match = fmap fst . P.match

replace :: P Text -> Text -> Text
replace p t = x
    where
      Right x = P.runParser p' "" t
      p' = P.try (p <* P.eof) <|> P.takeRest
