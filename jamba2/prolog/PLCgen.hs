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
import qualified Data.Set as S
import Distribution.Compat.Graph (Node)
import Control.Monad.Trans.Accum (add)


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

type NodeID = Integer

data Type = String
 | Arrow Type Type
 deriving (Show)

data TypingEnv = TypingEnv
  { -- | 'nodeType' maps node id to its type variable
    nodeType :: M.Map NodeID TVar
  , -- | 'funcInfo' maps a built-in function name to its type
    funcInfo :: M.Map String Type
  , -- | 'varInfo' maps an identifier to its node id and type status; scope sensitive
    varInfo :: [M.Map String (NodeID, IsTypeScheme)]
  , -- | 'suff' fresh suffix to append to new type var to make it unique
    suff :: NodeID
  , -- | 'id_user' fresh id number to assign to node; helper for user
    id_user :: NodeID
    -- | 'langcons' lanuage specific contraints to emit
  , langCons :: String
    -- | 'progCons' program specific constraints to emit
  , progCons :: String
    -- | 'currFunc' the name of the current function we are typechecking
  , currFunc :: String
  -- | 'currNodes' all the nodes in the subtree of function currFunc
  , currNodes :: S.Set NodeID
  -- | 'currRoot' the node id of the root of currFunc's subtree
  , currRoot :: NodeID
    -- | 'regCons' regular constraints associated with currFunc
  , regCons :: [String]
    -- | 'instCons' instantiation constraints associated with currFunc
  , instCons :: String
    -- | 'results' maps node id to their resolved type
  , results :: M.Map NodeID Type
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
                        , currFunc = ""
                        , currNodes = S.empty
                        , currRoot = 0
                        , regCons = []
                        , instCons = []
                        , results = M.empty }

type PLC = State TypingEnv

getType :: NodeID -> PLC TVar
getType id = do
  m <- gets nodeType
  case M.lookup id m of
    (Just tvar) -> pure tvar
    _ -> error $ "Could not find a type var associated with node id " ++ show id

genFuncConstraints :: PLC () -- MESSY; TODO: CLEAN UP!
genFuncConstraints = do
  m <- gets nodeType
  allNodes <- M.toList <$> gets nodeType
  addNodesToFunc (fst <$> allNodes) -- change later
  fNodes <- S.toList <$> gets currNodes
  fNodeTVars <- mapM getType fNodes
  let nodes = zip fNodes fNodeTVars
  fName <- gets currFunc
  rootId <- gets currRoot
  let (Just rootTVar) =  M.lookup rootId m
  -- z <- M.lookup <$> (gets currRoot:: PLC NodeID) <*> gets nodeType
  -- case z of Just rootTVar -> 
  -- <*> gets nodeType
  -- let w = ((gets nodeType) :: (PLC (M.Map NodeID TVar)))
  let rhs = intercalate "," (dummyRegCons ++ dummyInstCons)
      lhs = fName ++ "_typechecks" ++ parens (intercalate "," $ snd <$>nodes)
      f = lhs ++ providedThat ++ parens rhs ++ period
      nodeCons = concat $ nodeConstraint lhs <$> nodes
      f2 = hasType ++ parens (fName ++ comma ++ rootTVar) ++ providedThat ++ lhs ++ period
      f3 = "isTopLevelDef" ++ parens fName ++ period
  p <- gets progCons
  modify $ \st -> st{progCons = p++f++f2++f3 ++nodeCons}
  pure ()
  where
    dummyRegCons = ["X0 = int", "X1 = X1"]
    dummyInstCons = []::[String]
    providedThat = ":-"
    period = ".\n"
    comma = " , "
    parens a = "("++ a ++")"
    hasType = "hasType"
    nodeConstraint :: String -> (NodeID, TVar) -> String
    nodeConstraint rhs (id, tvar) =
      hasType ++ parens ("node_"++show id ++ comma ++ tvar) ++ providedThat ++ rhs ++period

-- User API func
addNode :: NodeID -> PLC ()
addNode id = do
  -- error "inside add node!"
  m <- gets nodeType
  tvar <- freshTVar
  let m' = case M.lookup id m of
        Nothing -> M.insert id tvar m
        Just n -> error "Duplicate node ids are prohibited"
  modify $ \st -> st{nodeType = m'}

{- | Remove binder from current scope

if scope layer is empty after removing name, pop scope layer as well -}
popBinder :: String -> PLC ()
popBinder nm = do
  tables <- gets varInfo
  case tables of 
    [] -> error "Trying to remove binder from an empty scope"
    (h:tl) -> do
      let h' = M.delete nm h
      let tables' = if null h' then tl else h' : tl
      modify $ \st -> st{varInfo = tables'}


{- | Add binder to current scope

if binder is already present in current scope, add a new scope layer and add it there. -}
addLocal :: String -> NodeID -> IsTypeScheme -> PLC ()
addLocal nm id status = do
  tables <- gets varInfo
  case tables of
    [] -> do           -- Case I: empty list of tables
      let tbl = M.fromList [(nm,(id, status))]
      let tables' = tbl : tables
      modify $ \st -> st{varInfo= tables'}
    (h:tl) -> do       -- Case II: at least one table!
      case M.lookup nm h of
        (Just v) -> do -- case II.1: name present in current layer, 
                       --            so need to add another layer.
          let tbl = M.fromList [(nm,(id, status))]
          let tables' = tbl : h : tl
          modify $ \st -> st{varInfo= tables'}
        _ -> do        -- case II.2: nm not present in current layer
          let h' = M.insert nm (id, status) h 
          modify $ \st -> st{varInfo = h':tl}


{- | Return binder info from shallowest scope.

 binder is either a local var/func, a built-in func, or a top-level func -}
lookupByName :: String -> PLC (Either (NodeID, IsTypeScheme) String)
lookupByName nm = do
  -- 1) first, look in local var tables
  tables <- gets varInfo
  searchRes <- lookupLocal nm tables
  case searchRes of
    (Just info) -> pure $ Left info
  -- 2) next, look in built-in funcs tables
  -- 3) otherwise, assume the nm refers to a top level function?
  -- in both 2) and 3), would end up just returning name,
  -- so let's do that instead of checking the built-in func table.
    _ -> pure $ Right nm
  pure $ Right nm
  where lookupLocal :: String -> [M.Map String (NodeID, IsTypeScheme)]-> PLC (Maybe (NodeID, IsTypeScheme))
        lookupLocal nm tables = do
          case tables of
            [] -> pure Nothing -- base case
            (h:tl) -> do 
              case M.lookup nm h of
                (Just info) -> pure $ Just info -- found in layer h!
                _ -> lookupLocal nm tl          -- recurse on deeper layers tl
          

freshTVar :: PLC TVar
freshTVar = do
  suff <- gets suff
  modify $ \st -> st {suff = suff + 1}
  return ("X" ++ show suff)


-- must be inside some function to generate typing constraints. right??
checkInsideFunc :: PLC ()
checkInsideFunc = do
  cf <- gets currFunc
  if cf == "" then error "need to be inside a function to generate type constraints!"
  else pure ()

--insert :: Ord a => a -> Set a -> Set a
addNodesToFunc :: [NodeID] -> PLC ()
addNodesToFunc [] = pure ()
addNodesToFunc nodes = do
  s <- gets currNodes
  let x = foldl (flip S.insert) s nodes
  modify $ \st -> st {currNodes = x}
  
 
       


-- | User API func; get a fresh node id to assign to an AST node
freshNodeId :: PLC NodeID
freshNodeId = do
  u <- gets id_user
  modify $ \st -> st {id_user = u + 1}
  return u

-- | User API func; announce we are entering a function we want to typecheck
enterFunc :: String -> NodeID -> PLC ()
enterFunc entering root = do
  modify $ \st -> st {currFunc = entering, currRoot = root}

-- | User API func; announce we are exiting the function we want to typecheck
exitFunc :: PLC ()
exitFunc = do
  genFuncConstraints
  clearFunctionFields

-- | User API func; generate typing constraints for a lambda abstraction
enterLam :: NodeID -> String -> NodeID -> NodeID -> PLC ()
enterLam root binderName binder body = do
  addLocal binderName binder False
  checkInsideFunc
  pure ()

exitLam :: NodeID -> String -> NodeID -> NodeID -> PLC ()
exitLam root binderName binder body = do
  checkInsideFunc
  popBinder binderName
  pure ()

-- | clear out all function fields so we are ready to typecheck a new function
clearFunctionFields :: PLC ()
clearFunctionFields = do
  modify $ \st -> st { varInfo = []
                     , currFunc = ""
                     , currRoot = 0
                     , regCons = []
                     , instCons = []}




data DummyAST = Node DummyAST DummyAST
 | Leaf


data DummyProgram = Dummy [(String,DummyAST)]

userAstPass :: DummyProgram -> PLC DummyProgram
userAstPass (Dummy []) = pure $ Dummy []
userAstPass (Dummy (h:t)) = do
                    enterFunc "aFunction" 0
                    _ <- userTopDef (snd h)
                    exitFunc
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

