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
import Distribution.Simple.Command (OptDescr(BoolOpt))
import Text.Read (Lexeme(String))
import Data.Char (isUpper)
import Foreign (free)


{- | Library for Hindley-Milner Prolog Constraint Generation

Given information about a source program, generate prolog typing constraints and return solution (or error).
ghc -main-is PLCgen PLCgen.hs
swipl -q -s tester-typing-constraints.pl
-}

type IsTypeScheme = Bool
type TVar = String
type NodeID = Integer

data Type =
   Ty String
 | Arrow Type Type
 deriving (Show)



data TypingEnv = TypingEnv
  { -- | 'nodeType' maps node id to its type variable
    nodeType :: M.Map NodeID TVar
  , -- | 'funcInfo' maps a built-in function name to its flat type
    funcInfo :: M.Map String [String]
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

type PLC = State TypingEnv

-- | Run a computation within the TypingEnv monad context
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

-- --------------------------------------- USER API ----------------------------------------- --|
--                                                                                              |

-- | Entry point for user!
typecheck :: p -> (p -> PLC p) -> TypingEnv
typecheck astRoot pass = runComp (pass astRoot)


{- | User API func; report target language's built in functions

Type Variables are Upper Case, or start with an underscore
Types are lower case
-}
addBuiltInFuncs :: [(String, [String])] -> PLC ()
addBuiltInFuncs funcs = do
  genBuiltInConstraints
  modify $ \st -> st{funcInfo = M.fromList funcs}

-- -- | User API func; convert a list of strings to an arrow type
-- toArrow :: [String] -> Type 
-- toArrow [] = error "must give at list of at least two types"
-- toArrow [h] = error "must give at list of at least two types"
-- toArrow strs = foldr1 Arrow (Ty <$> strs)

-- | User API func; get a fresh node id to assign to an AST node
freshNodeId :: PLC NodeID
freshNodeId = do
  u <- gets id_user
  modify $ \st -> st {id_user = u + 1}
  return u

-- User API func; report existence of node with assigned NodeID id
addNode :: NodeID -> PLC ()
addNode id = do
  -- error "inside add node!"
  m <- gets nodeType
  tvar <- freshTVar
  let m' = case M.lookup id m of
        Nothing -> M.insert id tvar m
        Just n -> error "Duplicate node ids are prohibited"
  modify $ \st -> st{nodeType = m'}

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
enterLam self binderName binderID body = do
  checkInsideFunc
  addLocal binderName binderID False
  -- TODO
  pure ()

{- | User API func; announce we are leaving a lambda  abstraction node

This function should be called AFTER BOTH
 - calling enterLam
 - recursing on children nodes of this lambda node
-}
exitLam :: String -> PLC ()
exitLam binderName = do
  checkInsideFunc
  popBinder binderName
  pure ()

enterLet :: NodeID -> String -> NodeID -> NodeID -> NodeID -> PLC ()
enterLet self binderName binderID binderRHS body = do
  checkInsideFunc
  -- TODO
  pure ()

exitLet :: String -> PLC ()
exitLet binderName = do
  checkInsideFunc
  popBinder binderName
  pure ()

genVar :: NodeID -> PLC ()
genVar _ = pure () -- TODO

genLit :: NodeID -> String -> PLC ()
genLit _ _ = pure () --TODO

--                                                                                              |
-- ------------------------------------------------------------------------------------------ --|

-- | Given a node id, return its type variable
getType :: NodeID -> PLC TVar
getType id = do
  m <- gets nodeType
  case M.lookup id m of
    (Just tvar) -> pure tvar
    _ -> error $ "Could not find a type var associated with node id " ++ show id

genBuiltInConstraints :: PLC ()
genBuiltInConstraints = do
  funcs <- M.toList <$> gets funcInfo
  langConz <- gets langCons
  let langCons' = langConz ++ concat (genBuiltInFunc <$> funcs)
  modify $ \st -> st{langCons = langCons'}
  return ()
  where
    period = ".\n"
    hasTypeScheme = "hasTypeScheme"
    parens a = "("++ a++ ")"
    brackets a = "["++a++"]"
    isTypeVar :: String -> Bool
    isTypeVar [] = error "type should never be the empty string"
    isTypeVar (h:tl) = h == '_' || isUpper h
    nestedArrow :: String -> String -> String
    nestedArrow a b = brackets $ a ++ "," ++ b
    genBuiltInFunc :: (String, [String]) -> String
    genBuiltInFunc (nm, typs) =
      let freeVars = filter isTypeVar typs
          typ = foldr1 nestedArrow typs
          vars = intercalate "," freeVars
      in
        hasTypeScheme ++ parens (nm ++ "," ++ brackets vars ++ "," ++ typ) ++ period




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
  l <- gets langCons
  p <- gets progCons
  modify $ \st -> st{progCons = l++p++f++f2++f3 ++nodeCons}
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

-- | Return a fresh type variable (used by addNode)
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

-- | Add one or more nodes to the context of the current function
addNodesToFunc :: [NodeID] -> PLC ()
addNodesToFunc [] = pure ()
addNodesToFunc nodes = do
  s <- gets currNodes
  let x = foldl (flip S.insert) s nodes
  modify $ \st -> st {currNodes = x}

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

userAstPass2 :: DummyProgram -> PLC DummyProgram -- NOT WORKING; NEED TO FIX, OR CHANGE ONE BELOW
userAstPass2 (Dummy []) = pure $ Dummy []        -- TO TEST ADDBUILTINFUNCS
userAstPass2 (Dummy topDefs) = do
  --addBuiltInFuncs [("howdy",["int","X","bool"])]
  let x = mapM_ process topDefs
  pure $ Dummy topDefs
  where
    process h = do
                    enterFunc "aFunction" 0
                    _ <- userTopDef (snd h)
                    exitFunc

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
      -- let testingTypeArrow = ["int","int","bool"]
      -- -- let res = toArrow testingTypeArrow
      -- print res
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

