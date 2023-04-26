module Main (main) where

import qualified Data.ByteString.Lazy.Char8 as BS
import Lexer (scanMany2)
import Parser (parseJambaProgram)
import System.Environment (getArgs)
import System.Exit (die)
import System.IO
-- main :: IO ()
-- main = do
--   putStrLn "hello world"

{-
References:
https://serokell.io/blog/lexing-with-alex
https://serokell.io/blog/parsing-with-happy
-}


usage = "./src/Main tests/examples/p1.jj"

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> die $ "Error:  must input a file name.\n Example usage:\n" ++ usage
    [filename] -> do
      -- read in the file
      handle <- openFile filename ReadMode
      contents <- hGetContents handle
      let input = BS.pack contents -- convert input to a bytestring

      -- try to scan
      case scanMany2 input of
        (Left err) -> die $ show err
        _ ->
          -- try to parse
          case parseJambaProgram input of
            (Left err) -> die $ show err
            (Right ast) -> do
              print ast
              return ()

    -- TODO: try to generate constraints
    -- TODO: try to solve constraints
    -- TODO: try to interpret?

    _ -> die $ "Error: incorrect usage.\n Example usage:\n"  ++ usage
