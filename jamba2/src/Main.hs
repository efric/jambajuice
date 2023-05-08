module Main (main) where

import Parser (parseModule)
import System.Environment (getArgs)
import System.Exit (die)
import qualified Data.Text.Lazy.IO as L
import qualified Data.Map as Map
import Control.Monad.State.Strict ( MonadIO(liftIO) )
import Eval ( TermEnv, emptyTmenv, runEval )
import AST ( Expr )
import Data.List (foldl')

usage :: String
usage = "./src/Main tests/examples/p1.jj"

mainfn :: String
mainfn = "jambajuice"

-- -- map with keys: functions names, values: number of arguments
-- type Func2Arg = Map.Map String Integer

evalDef :: TermEnv -> (String, Expr) -> TermEnv
evalDef env (nm, ex) = tmctx'
  where (_, tmctx') = runEval env nm ex

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> die $ "Error:  must input a file name.\n Example usage:\n" ++ usage
    [filename] -> do
      contents <- liftIO $ L.readFile filename

      case parseModule contents of
        (Left err) -> die $ show err
        (Right ast) -> do
          print ast
          let eval = foldl' evalDef emptyTmenv ast
          case Map.lookup mainfn eval of
            Just v -> print v
            Nothing -> die $ "No main function (" ++ mainfn ++ ") in file\n"
          pure ()

    _ -> die $ "Error: incorrect usage.\n Example usage:\n"  ++ usage
