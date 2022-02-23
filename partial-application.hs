main = undefined

    -- map next [1..5]
    -- map (\x -> x + 1) [1..5]

-- CURRYING:
-- f :: X ->  Y ->  Z -> A
-- is the same as
-- f :: X -> (Y -> (Z -> A))
-- one may consider f as a function of type X that returns a function of type Y->Z->A
-- and so on
-- thus one can rewrite any function of multiple arguments into a sequence of functions with single argument

-- currying explained with lambdas:

    -- \x y z -> x + y + z

-- the same as

    -- \x -> (\y z -> x + y + z)

-- the same as

    -- \x -> (\y -> (\z -> x + y + z))

-- because all functions can be seen as functions with single argument, partial application is possible

    -- add x y = x+y
    -- add x y = (add x) y
    -- add3    = add 3     -- = \y -> 3 + y
    -- add3 4              -- = (add 3) 4 = add 3 4 = 7

-- this is also the reason why it is possible to write things like this:
    -- map (+1) [1..5]
