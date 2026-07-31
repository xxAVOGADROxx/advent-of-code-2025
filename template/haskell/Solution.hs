module Main where

import           Data.List

parse :: String -> [String]
parse = lines

part1 :: [String] -> Int
part1 _ = 0  -- TODO

part2 :: [String] -> Int
part2 _ = 0  -- TODO

main :: IO ()
main = interact $ \raw ->
  let d = parse raw
  in unlines [ "Part 1: " ++ show (part1 d)
             , "Part 2: " ++ show (part2 d)
             ]
