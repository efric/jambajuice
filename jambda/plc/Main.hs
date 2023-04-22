module Main (main) where

import qualified Data.ByteString.Lazy.Char8 as BS
import Lexer (scanMany)
import Parser (parseMiniMLProgram)
import System.Environment (getArgs)
import System.Exit (die)
import System.IO

{-
Could not load module ‘Parser’
It is a member of the hidden package ‘ghc-8.10.7’.
You can run ‘:set -package ghc’ to expose it.
(Note: this unloads all the modules in the current scope.)
-}

{-
References:
https://serokell.io/blog/lexing-with-alex
https://serokell.io/blog/parsing-with-happy
-}

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> die "Error:  must input a file name.\n Example usage:\n stack exec plc -- ../tests/examples/p1.jj"
    [filename] -> do
      -- read in the file
      handle <- openFile filename ReadMode
      contents <- hGetContents handle
      let input = BS.pack contents -- convert input to a bytestring

      -- try to scan
      case scanMany input of
        (Left err) -> die $ show err
        _ ->
          -- try to parse
          case parseMiniMLProgram input of
            (Left err) -> die $ show err
            (Right ast) -> do
              print ast
              return ()

    -- TODO: try to generate constraints
    -- TODO: try to solve constraints
    -- TODO: try to interpret?

    _ -> die "Error: incorrect usage.\n Example usage:\n stack exec plc -- ../tests/examples/p1.jj"
