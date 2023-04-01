module Main (main) where

import Parse
import System.Environment (
  getArgs,
 )
import System.Exit (die)
import System.IO

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> die "Error:  must input a file name.\n Example usage:\n stack exec plc -- ../tests/examples/p1.jj"
    [filename] -> do
      handle <- openFile filename ReadMode
      contents <- hGetContents handle
      print contents
    _ -> die "Error: incorrect usage.\n Example usage:\n stack exec plc -- ../tests/examples/p1.jj"

--print $ parse contents
-- s <- getContents
-- print $ parse s