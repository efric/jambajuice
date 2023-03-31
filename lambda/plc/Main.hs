module Main (main) where

import Parse

main :: IO ()
main = do
  handle <- openFile "p1.jj" ReadMode
  contents <- hGetContents handle
  print contents
  --print $ parse contents
  -- s <- getContents
  -- print $ parse s