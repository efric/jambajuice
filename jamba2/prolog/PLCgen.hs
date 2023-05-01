module PLCgen (main) where

import qualified Data.ByteString.Lazy.Char8 as BS

-- import Lexer (scanMany2)
-- import Parser (parseJambaProgram)
import System.Environment (getArgs)
import System.Exit (die)
import System.IO
import System.Process
import Control.Monad (when, unless)

{- | Library for Hindley-Milner Prolog Constraint Generation

Given information about a source program, generate prolog typing constraints and return solution (or error).
ghc -main-is PLCgen PLCgen.hs
swipl -q -s tester-typing-constraints.pl
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
    [] -> die "Error:  must input a file name.\n"
    [filename] -> do
      -- create the files
      let constraintFile = filename ++ "-typing-constraints.pl"
      let resultFile = filename ++ "-contraint-results.pl"
      handle <- openFile constraintFile WriteMode
      -- write out some dummy constraints
      let testOutput = ["likesImprov(jane).",
                        "likesImprov(helen).",
                        "likesImprov(adele) :- X = 5, X = 6.",
                        "likesImprov(Y):- inATroupe(Y).",
                        "inATroupe(grace).",
                        "inATroupe(edward).",
                        ":- initialization writeln('START'),forall(likesImprov(X), (write('hey, '), writeln(X))), writeln('DONE')."]
      mapM_ (hPutStrLn handle) testOutput 
      hClose handle -- close the file
      -- open an output file
      resHandle <- openFile resultFile WriteMode
      -- run the prolog program through swipl
      (Just writeEnd, Just readEnd, Just readErrEnd, ph) <- createProcess (proc "swipl" ["-q", "-s", constraintFile]){
        std_out = CreatePipe,
        std_in = CreatePipe,
        std_err = CreatePipe}
      -- read one from the prolog interpreter
      readUntilDone readEnd "DONE" (Just resHandle)
      hClose resHandle -- close the file
    
      pure () -- exit

    _ -> die "Error: must input a file name.\n"

readUntilDone :: Handle -> String -> Maybe Handle-> IO ()
readUntilDone hdl done out = do
  aLine <- hGetLine hdl
  print aLine
  unless (aLine == done) (readUntilDone hdl done out)
  where print = maybe putStrLn hPutStrLn out

