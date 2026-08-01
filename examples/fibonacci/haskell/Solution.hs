module Main where

-- Fibonacci iterativo. Integer es bigint en Haskell.
fib :: Int -> Integer
fib n = go n 0 1
  where
    go 0 a _ = a
    go k a b = go (k - 1) b (a + b)

fibSum :: Int -> Integer
fibSum n = sum (map fib [0 .. n])

main :: IO ()
main = interact $ \raw ->
  let n = read . head . lines $ raw :: Int
  in unlines [ "Part 1: " ++ show (fib n)
             , "Part 2: " ++ show (fibSum n)
             ]
