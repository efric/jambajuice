{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DerivingVia #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
module PLCgen (main) where

import qualified Data.ByteString.Lazy.Char8 as BS

-- import Lexer (scanMany2)
-- import Parser (parseJambaProgram)
import System.Environment (getArgs)
import System.Exit (die)
import System.IO
import System.Process
import Control.Monad (when, unless)
import Control.Monad.State.Lazy (
  MonadState (put, get),
  StateT (..),
  evalStateT,
  gets,
  modify, State, execState,
 )
import qualified Data.Map as M
import Control.Arrow (ArrowChoice(left))
import Data.List (intercalate)

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

{-
NOTES:
readFile :: FilePath -> IO StringSource#

The readFile function reads a file and returns the contents of the file as a string. The file is read lazily, on demand, as with getContents.

writeFile :: FilePath -> String -> IO ()Source#

The computation writeFile file str function writes the string str, to the file file.

appendFile :: FilePath -> String -> IO ()

-}

{-
more notes!
{- | Entry-point to Simplifer.

Maps over top level definitions to create a new simplified Program
-}
simplifyProgram :: I.Program I.Type -> Compiler.Pass (I.Program I.Type)
simplifyProgram p = runSimplFn $ do
  _ <- runOccAnal p -- run the occurrence analyzer
  -- fail and print out the results of the occurence analyzer
  -- info <- runOccAnal p
  -- _ <- Compiler.unexpected $ show info
  simplifiedProgramDefs <- mapM simplTop (I.programDefs p)
  return $ p{I.programDefs = simplifiedProgramDefs} -- this whole do expression returns a Compiler.Pass

{- | Add substitution to the substitution set

Suppose we want to replace x with y.
Then we call insertSubst x (SuspEx y {})
-}
insertSubst :: I.VarId -> SubstRng -> SimplFn ()
insertSubst binder rng = do
  m <- gets subst
  let m' = M.insert binder rng m
  modify $ \st -> st{subst = m'}

-- | Run a SimplFn computation.
runSimplFn :: SimplFn a -> Compiler.Pass a
runSimplFn (SimplFn m) =
  evalStateT
    m
    SimplEnv
      { occInfo = M.empty
      , runs = 0
      , countLambda = 0
      , countMatch = 0
      , subst = M.empty
      }


-- | Add a binder to occInfo with category Dead by default
addOccVar :: I.VarId -> SimplFn ()
addOccVar binder = do
  m <- gets occInfo
  let m' = case M.lookup binder m of
        Nothing -> M.insert binder Dead m
        Just _ -> M.insert binder ConstructorFuncArg m
  modify $ \st -> st{occInfo = m'}

-- | Simplifier Environment
data SimplEnv = SimplEnv
  { -- | 'occInfo' maps an identifier to its occurence category
    occInfo :: M.Map I.VarId OccInfo
  , -- | 'subst' maps an identifier to its substitution
    subst :: M.Map InVar SubstRng
  , -- | 'runs' stores how many times the simplifier has run so far
    runs :: Int
  , -- | 'countLambda' how many lambdas the occurence analyzer is inside
    countLambda :: Int
  , -- | 'countLambda' how many matches the occurence analyzer is inside
    countMatch :: Int
  }
  deriving (Show)
  deriving (Typeable)


-- | Simplifier Monad
newtype SimplFn a = SimplFn (StateT SimplEnv Compiler.Pass a)
  deriving (Functor) via (StateT SimplEnv Compiler.Pass)
  deriving (Applicative) via (StateT SimplEnv Compiler.Pass)
  deriving (Monad) via (StateT SimplEnv Compiler.Pass)
  deriving (MonadFail) via (StateT SimplEnv Compiler.Pass)
  deriving (MonadError Compiler.Error) via (StateT SimplEnv Compiler.Pass)
  deriving (MonadState SimplEnv) via (StateT SimplEnv Compiler.Pass)
  deriving (Typeable)

-}

type IsTypeScheme = Bool

type TVar = String

data Type = String 
 | Arrow Type Type
 deriving (Show)

data TypingEnv = TypingEnv
  { -- | 'nodeType' maps node id to its type variable
    nodeType :: M.Map Integer TVar
  , -- | 'funcInfo' maps a built-in function name to its type
    funcInfo :: M.Map String Type
  , -- | 'varInfo' maps an identifier to its node id and type status; scope sensitive
    varInfo :: [M.Map String (Integer, IsTypeScheme)]
  , -- | 'suff' fresh suffix to append to new type var to make it unique
    suff :: Integer
  , -- | 'id_user' fresh id number to assign to node; helper for user
    id_user :: Integer
    -- | 'langcons' lanuage specific contraints to emit
  , langCons :: String
    -- | 'progCons' program specific constraints to emit
  , progCons :: String
    -- | 'currFunc' the name of the current function we are typechecking
  , currFunc :: String
  -- | 'currNodes' all the nodes in the subtree of function currFunc
  , currNodes :: [Integer]
    -- | 'regCons' regular constraints associated with currFunc
  , regCons :: [String]
    -- | 'instCons' instantiation constraints associated with currFunc
  , instCons :: String
    -- | 'results' maps node id to their resolved type
  , results :: M.Map Integer Type
  }
  deriving (Show)

-- | Entry point for user!
typecheck :: p -> (p -> PLC p) -> TypingEnv
typecheck root pass = runComp (pass root)

runComp :: PLC a -> TypingEnv
runComp a = 
  execState a TypingEnv { nodeType = M.empty
                        , funcInfo = M.empty
                        , varInfo = []
                        , suff = 0
                        , id_user = 0
                        , langCons = ""
                        , progCons = ""
                        , currFunc = "jambaJuice"
                        , currNodes = []
                        , regCons = []
                        , instCons = []
                        , results = M.empty }

type PLC = State TypingEnv

genFuncConstraints :: PLC ()
genFuncConstraints = do 
  nodes <- M.toList <$> gets nodeType
  fName <- gets currFunc  
  let constraints = intercalate "," (dummyRegCons ++ dummyInstCons)
  let lhs = fName ++ "_typechecks" ++ parens (intercalate "," $ snd <$>nodes)
  let f = lhs ++ providedThat ++ parens constraints ++ period
  let nodeCons = concat $ nodeConstraint lhs <$> nodes
  p <- gets progCons
  modify $ \st -> st{progCons = p++f++nodeCons}
  pure ()
  where
    dummyRegCons = ["X0 = int", "X1 = X1"]
    dummyInstCons = []::[String]
    providedThat = ":-"
    period = ".\n"
    parens a = "("++ a ++")"
    nodeConstraint :: String -> (Integer, TVar) -> String
    nodeConstraint rhs (id, tvar) =
      "hasType" ++ parens ("node_"++show id ++", " ++ tvar) ++ providedThat ++ rhs ++period


addNode :: Integer -> PLC ()
addNode id = do
  -- error "inside add node!"
  m <- gets nodeType
  tvar <- freshTVar
  let m' = case M.lookup id m of
        Nothing -> M.insert id tvar m
        Just n -> error "Duplicate node ids are prohibited"
  modify $ \st -> st{nodeType = m'}

freshTVar :: PLC TVar
freshTVar = do 
  suff <- gets suff
  modify $ \st -> st {suff = suff + 1}
  return ("X" ++ show suff)

freshNodeId :: PLC Integer
freshNodeId = do
  u <- gets id_user
  modify $ \st -> st {id_user = u + 1}
  return u


data DummyAST = Node DummyAST DummyAST
 | Leaf

data DummyProgram = Dummy [(String,DummyAST)]

userAstPass :: DummyProgram -> PLC DummyProgram
userAstPass (Dummy []) = pure $ Dummy []
userAstPass (Dummy (h:t)) = do
                    _ <- userTopDef (snd h)
                    genFuncConstraints
                    userAstPass $ Dummy t

userTopDef :: DummyAST -> PLC DummyAST
userTopDef (Node left right) = do
  -- do something to modify state!
  id <- freshNodeId
  addNode id
  left' <- userTopDef left
  right' <- userTopDef right 
  return (Node left' right')
userTopDef Leaf = do id <- freshNodeId
                     addNode id
                     return Leaf
    

main :: IO ()
main = do
  args <- getArgs
  case args of
    [] -> die "Error:  must input a file name.\n"
    [filename] -> do
      -- testing constraint generation
      let ast = Dummy [("jambaJuice", Node (Node Leaf Leaf) (Node Leaf Leaf))]
      let x = typecheck ast userAstPass
      print $ show x
      -- testing constraint generation

      -- create the file names
      let constraintFile = filename ++ "-typing-constraints.pl"
      let resultFile = filename ++ "-contraint-results.pl"   

      -- read in template file contents
      prologue <- readFile "./templateFiles/prologue.pl" -- read in prologue
      epilogue <- readFile "./templateFiles/epilogue.pl" -- read in epilogue      
      dummy <- readFile "./templateFiles/dummy.pl"       -- read in dummy constraints

      let dummy = progCons x
      -- write constraints
      handle <- openFile constraintFile WriteMode -- open constraints file
      hPutStrLn handle prologue                   -- write prologue
      hPutStrLn handle dummy                      -- write dummy constraints
      hPutStrLn handle epilogue                   -- write epilogue 
      hClose handle                               -- close the constraints file

      -- perform type checking + type inference      
      -- run the prolog program through swipl
      (Just writeEnd, Just readEnd, Just readErrEnd, ph) <- createProcess (proc "swipl" ["-q", "-s", constraintFile]){
        std_out = CreatePipe,
        std_in = CreatePipe,
        std_err = CreatePipe}
      resHandle <- openFile resultFile WriteMode  -- open results file
      results <- hGetContents readEnd             -- read from swipl
      hPutStr resHandle results                   -- write out results
      hClose resHandle                            -- close the results file  
      pure () -- exit

    _ -> die "Error: must input a file name.\n"

-- readUntilDone :: Handle -> String -> Maybe Handle-> IO ()
-- readUntilDone hdl done out = do
--   aLine <- hGetLine hdl
--   print aLine
--   unless (aLine == done) (readUntilDone hdl done out)
--   where print = maybe putStrLn hPutStrLn out

