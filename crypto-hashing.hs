import Crypto.Hash
import Data.ByteString (ByteString)
import qualified Data.ByteString.UTF8 as UTF8
import Data.ByteArray.Encoding

sha256 :: String -> String
sha256 input = result
  where
    bytes = UTF8.fromString input      :: ByteString
    digest = hashWith SHA256 bytes     :: Digest SHA256
    hex = convertToBase Base16 digest  :: ByteString
    result = UTF8.toString hex         :: String

main =
  do
    putStrLn ("sha256(abc)   = " ++ sha256 "abc")
    putStrLn ("sha256(hello) = " ++ sha256 "hello")
