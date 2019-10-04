-- let's recursively define a tree type with
-- values of some type attached to each node

data Tree a = Empty | Node a [Tree a] deriving (Show)


-- this tree structure admits an arbitrary number of
-- trees hanging from each node


-- let's give an example

tree :: Tree Integer
tree = Node 1 [
           Node 2 [
               Node 3 [],
               Node 4 []
           ],
           Node 5 [
               Node 6 [],
               Node 7 []
           ]
       ]


-- this is equivalent to the following
-- tree structure:
--       1
--      / \
--     2   5
--    / \ / \
--   3  4 6  7


-- depth-first search traversal of Tree a
-- in this example we use concatMap

depthFirst :: Tree a -> [a]
depthFirst Empty = []
depthFirst (Node x ts) = x : concatMap depthFirst ts


-- breadth-first search traversal of Tree a
-- in this example we use concatMap, foldl and Monoid typeclass

breadthFirst :: Tree a -> [a]
breadthFirst Empty = []
breadthFirst (Node x ts) = x : (a ++ concatMap breadthFirst b)
    where (a, b) = foldl mappend mempty (map pruneRoot ts)
          pruneRoot Empty = mempty
          pruneRoot (Node x ts) = ([x], ts)

-- the idea is to use an accumulator of type ([a], [Tree a])
-- we take advantage of the fact that this is in fact a Monoid
-- on the left keep roots pruned so far
-- on the right keep trees hanging from the roots we just pruned


main = do

  putStrLn("tree: " ++ show tree)

  putStrLn("depth-first traversal: " ++ show (depthFirst tree))

  putStrLn("breadth-first traversal: " ++ show (breadthFirst tree))
