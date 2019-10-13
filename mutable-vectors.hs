import           Control.Monad.ST
import qualified Data.Vector         as V
import qualified Data.Vector.Mutable as MV

makeVec :: V.Vector Double
makeVec =
  runST $ do
    v <- MV.replicate 3 0
    MV.write v 1 100
    V.freeze v

makeVec' :: IO (V.Vector Double)
makeVec' = do
  v <- MV.replicate 3 0
  MV.write v 1 100
  V.freeze v

main = do
  mutableVector <- MV.replicate 5 "Default value"
  item <- MV.read mutableVector 0
  print ("Item at index 0 of mutableVector: " ++ item)
  -- ^ Create and fill a mutable vector

  let immutableVector = V.replicate 5 "Default value"
  mutableVector2 <- V.thaw immutableVector
  item <- MV.read mutableVector2 0
  print ("Item at index 0 of mutableVector2: " ++ item)
  -- ^ Create and fill a non-mutable vector, then create mutable
  -- version from it

  MV.write mutableVector2 0 "New value"
  item <- MV.read mutableVector2 0
  print ("New item at index 0 mutableVector2: " ++ item)
  -- ^ Set value at index (mutate in place)

  frozen <- V.freeze mutableVector2
  let frozen' = V.map (const "Another value") frozen
  print ("Contents of frozen': " ++ show frozen')
  -- ^ Freeze a mutable vector

  V.copy mutableVector2 frozen'
  item <- MV.read mutableVector2 0
  print ("New item at index 0 of mutableVector2: " ++ item)
  -- ^ Copy an immutable vector into a mutable one

  print (V.modify (\v -> MV.write v 0 100) (V.replicate 5 0))
  -- ^ Perform a destructive update on an **immutable vector**
  
  print makeVec
  vec <- makeVec'
  print vec
  -- ^ Showcase that Mutable Vector can work with both IO but also
  -- ST and that ST has the cool advantage that it doesn't "infect'
  -- other functions like IO does.
