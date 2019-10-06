import qualified Data.Map as Map
import qualified Data.Set as Set
import Data.Set ((\\))

data CustomKey = Foo | Bar | Baz
  deriving (Show, Eq, Ord)

main = do
    putStrLn "basic map behaviour: "
    let m = Map.fromList [("k1", 7), ("k2", 13)]
    putStrLn ("map: " ++ show m)
    putStrLn ("v1: " ++ show (Map.lookup "k1" m))
    putStrLn ("size: " ++ show (Map.size m))

    let m' = Map.delete "k2" m
    putStrLn ("map after delete v2: " ++ show m')
    putStrLn ("v2: " ++ show (Map.lookup "k2" m'))

    putStrLn "using a custom data type as a Key in a map:"
    let m1 = Map.fromList [(Foo, "Hello"), (Baz, "Goodbye")]
    putStrLn ("map with custom key type: " ++ show m1)
    putStrLn ("v1: " ++ show (Map.lookup Foo m1))

    let m1' = Map.insert Bar "How do you do?" m1
    putStrLn ("map after insert: " ++ show m1')

    let s = Set.fromList [7, 13]
    putStrLn ("set: " ++ show s)
    putStrLn ("is 7 a member? "++ show (Set.member 7 s) )
    putStrLn ("size: " ++ show (Set.size s))

    let s' = Set.fromList [7, 11, 12, 18, 13, 42]
    putStrLn ("second set: " ++ show s')
    putStrLn ("union: " ++ (show (s `Set.union` s')))
    putStrLn ("difference: "++ (show (Set.difference s' s)))
    putStrLn ("isSubset: " ++ (show (Set.isSubsetOf s s')))

