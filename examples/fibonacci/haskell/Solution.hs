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
  -- pattern match en vez de 'head': head es parcial y GHC avisa (-Wx-partial).
  -- Como interact espera un String, el caso vacio devuelve un mensaje normal.
  case lines raw of
    [] -> "error: input vacio\n"
    (l:_) ->
      let n = read l :: Int
      in unlines [ "Part 1: " ++ show (fib n)
                 , "Part 2: " ++ show (fibSum n)
                 ]
