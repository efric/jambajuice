module Main (main) where

import Parser (parseModule)
import System.Environment (getArgs)
import System.Exit (die)
import System.IO
import qualified Data.Text.Lazy as L
import qualified Data.Text.Lazy.IO as L
import Data.Monoid
import Control.Monad.State.Strict

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
      contents <- liftIO $ L.readFile filename
      -- handle <- openFile filename ReadMode
      -- contents <- hGetContents handle

      case parseModule contents of
        (Left err) -> die $ show err
        (Right ast) -> do
          print ast
          return ()

      -- -- try to scan
      -- case scanMany2 input of
        -- (Left err) -> die $ show err
        -- _ ->
          -- try to parse
          -- case parseModule input of
            -- (Left err) -> die $ show err
            -- (Right ast) -> do
              -- print ast
              -- return ()

    -- TODO: try to generate constraints
    -- TODO: try to solve constraints
    -- TODO: try to interpret?

    _ -> die $ "Error: incorrect usage.\n Example usage:\n"  ++ usage
