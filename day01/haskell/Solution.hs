module Main where

import Data.List (lines)

parse :: String -> [String]
parse = lines

part1 :: [String] -> String
part1 _ = "TODO"

part2 :: [String] -> String
part2 _ = "TODO"

main :: IO ()
main = do
  input <- getContents
  let d = parse input
  putStrLn $ "Part 1: " ++ part1 d
  putStrLn $ "Part 2: " ++ part2 d
