{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DerivingVia #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use newtype instead of data" #-}
module PLCgen (
  solve,
  Type,
  PLC,
  addBuiltInFuncs,
  freshNodeId,
  addNode ,
  enterFunc ,
  exitFunc ,
  enterLam ,
  exitLam ,
  enterLet,
  exitLet ,
  genVar,
  unifyNodeNode,
  unifyNodeType,
  enterApp,
  genFix
) where

import System.Exit (die)
import System.IO
import System.Process
import Control.Monad.State.Lazy (
  gets,
  modify, State, execState, MonadIO (liftIO),
 )
import qualified Data.Map as M
import Data.List (intercalate)
import qualified Data.Set as S
import Data.Char (isUpper)
import PrologParser (parseProlog, Type)
import qualified Data.Text.Lazy.IO as L


{- | Library for Hindley-Milner Prolog Constraint Generation

Given information about a source program, generate prolog typing constraints and return solution (or error).
ghc -main-is PLCgen PLCgen.hs
swipl -q -s tester-typing-constraints.pl
-}

type IsTypeScheme = Bool
type TVar = String
type NodeID = Integer

data TypingEnv = TypingEnv
  { -- | 'nodeType' maps node id to its type variable
    nodeType :: M.Map NodeID TVar
  , -- | 'funcInfo' maps a built-in function name to its flat type
    funcInfo :: M.Map String [String] -- user would pass in ("Add", ["int", "int", "int"])
  , -- | 'varInfo' maps an identifier to its node id and type status; scope sensitive
    -- | Let = isTypeScheme true, Lambda = isTypeScheme False
    {- let x = 4 in x + (let x = 3 in x + 2)
    -}
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
  , instCons :: [String]
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
                        , currRoot = 9999
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
addNode iD = do
  -- error "inside add node!"
  m <- gets nodeType
  tvar <- freshTVar
  let m' = case M.lookup iD m of
        Nothing -> M.insert iD tvar m
        Just _ -> error $ "Duplicate node ids are prohibited! " ++ "bad id:"++show iD ++ show m
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
  addNodesToFunc [self, binderID, body]
  addLocal binderName binderID False
  x1 <- getType binderID
  x2 <- getType body
  x3 <- getType self
  let cons1 = arrow ++ parens x3
  let cons2 = input ++ parens (x3 ++ "," ++ x1)
  let cons3 = output ++ parens (x3 ++ "," ++ x2)
  rg <- gets regCons
  modify $ \st -> st {regCons = rg ++ [cons1, cons2, cons3]}
  pure ()

genFix :: NodeID -> NodeID -> NodeID -> PLC ()
genFix self lam lamBinder = do
  checkInsideFunc
  addNodesToFunc [self, lam, lamBinder]
  x4 <- getType self
  x3 <- getType lam
  x1 <- getType lamBinder
  let fix = output ++ parens (x3 ++ "," ++ x4)
  let fixLam = arrow ++ parens x1
  rg <- gets regCons
  modify $ \st -> st {regCons = rg ++ [fix, fixLam]}
  return ()

enterApp :: NodeID -> NodeID -> NodeID -> PLC ()
enterApp self binderID body = do
  checkInsideFunc
  addNodesToFunc [self, binderID, body]
  x1 <- getType binderID
  x2 <- getType body
  x3 <- getType self
  let cons1 = arrow ++ parens x1
  let cons2 = input ++ parens (x1 ++ "," ++ x2)
  let cons3 = output ++ parens (x1 ++ "," ++ x3)
  rg <- gets regCons
  modify $ \st -> st {regCons = rg ++ [cons1, cons2, cons3]}
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

unifiesWith :: String -> String -> String
unifiesWith a b = a ++ "=" ++ b
arrow :: String
arrow = "arrow"
input :: String
input = "fst"
output :: String
output = "snd"
parens :: String -> String
parens a = "("++ a ++")"

enterLet :: NodeID -> String -> NodeID -> NodeID -> NodeID -> PLC ()
enterLet self binderName binderID binderRHS body = do
  checkInsideFunc
  addNodesToFunc [self, binderID, binderRHS, body]
  addLocal binderName binderID True
  x1 <- getType  binderID
  x2 <- getType binderRHS
  x3 <- getType body
  x4 <- getType  self
  rg <- gets regCons
  modify $ \st -> st {regCons = rg ++ [x1 `unifiesWith` x2, x4 `unifiesWith` x3]}

exitLet :: String -> PLC ()
exitLet binderName = do
  checkInsideFunc
  popBinder binderName
  pure ()

genVar :: String -> NodeID -> PLC ()
genVar nm myNid = do
  checkInsideFunc
  myTVar <- getType myNid
  inst <- gets instCons
  rg <- gets regCons
  info <- lookupByName nm
  case info of
    (Left (nid, status)) -> if status
                            then do -- let binder
                              addNodesToFunc [nid, myNid]
                              tvar <- getType  nid
                              let constraint = "copy_term" ++ parens (tvar ++","++myTVar)
                              modify $ \st -> st {instCons = inst ++ [constraint]}
                            else do -- lambda binder
                              addNodesToFunc [nid, myNid]
                              tvar <- getType  nid
                              let constraint = myTVar ++ "=" ++ tvar
                              modify $ \st -> st {regCons = rg ++ [constraint]}
    _ -> do -- built in func or top level func
      addNodesToFunc [myNid]
      let constraint = "instantiates" ++ parens (myTVar++","++ nm)
      modify $ \st -> st {instCons = inst ++ [constraint]}



unifyNodeType :: NodeID -> String -> PLC ()
unifyNodeType n t = do
  checkInsideFunc
  addNodesToFunc [n]
  rg <- gets regCons
  n' <- getType n
  let unified = n' ++ "="  ++ t
  let rg' = rg ++ [unified]
  modify $ \st -> st {regCons = rg'}
  

unifyNodeNode :: NodeID -> NodeID -> PLC ()
unifyNodeNode n1 n2 = do
  checkInsideFunc
  addNodesToFunc [n1,n2]
  rg <- gets regCons
  n1' <- getType n1
  n2' <- getType n2
  let unified = n1' ++ "="  ++ n2'
  let rg' = rg ++ [unified]
  modify $ \st -> st {regCons = rg'}
 

-- genUnifyTypeWithTypeScheme :: NodeID -> NodeID -> PLC ()
-- genUnifyTypeWithTypeScheme _ _ = pure () -- TODO

solve :: a -> (a -> PLC a) -> IO (M.Map Integer Type)
solve prog userPass = do
  let x = typecheck prog userPass
      l = langCons x
      p = progCons x
      constraints = l ++ p
      constraintFile = "typing-constraints.pl"
      resultFile = "contraint-results.pl"

  prologue <- readFile "templateFiles/prologue.pl" -- read in prologue
  epilogue <- readFile "templateFiles/epilogue.pl" -- read in epilogue      
  handle <- openFile constraintFile WriteMode
  hPutStrLn handle prologue
  hPutStrLn handle constraints
  hPutStrLn handle epilogue
  hClose handle

  (Just _, Just readEnd, Just _, _) <- createProcess (proc "swipl" ["-q", "-s", constraintFile]){
    std_out = CreatePipe,
    std_in = CreatePipe,
    std_err = CreatePipe}
  resHandle <- openFile resultFile WriteMode  -- open results file
  swiplOutput <- hGetContents readEnd             -- read from swipl
  hPutStr resHandle swiplOutput                   -- write out results
  hClose resHandle                            -- close the results file 
  -- enter Eric's great parser!
  content_results <- liftIO $ L.readFile resultFile
  case parseProlog content_results of
    (Left err) -> die $ show err
    (Right table) -> do
     let  original = nodeType x
     if length (M.toList original) == length (M.toList table)
      then pure table
        --error $ "\nWORKED YO\nbefore checking: "++ show (M.toList original) ++ "\n" ++ "after checking" ++ show (M.toList table)
      else error $ "\nFAILED YO\nbefore checking: "++ show (M.toList original) ++ "\n" ++ "after checking" ++ show (M.toList table)
     -- do cmp here; if different. print table

--                                                                                              |
-- ------------------------------------------------------------------------------------------ --|

-- | Given a node id, return its type variable
getType :: NodeID -> PLC TVar
getType iD = do
  m <- gets nodeType
  case M.lookup iD m of
    (Just tvar) -> pure tvar
    _ -> error $ "Could not find a type var associated with node id " ++ show iD

{-
% generate a type scheme for a top level definition if possible
hasTypeScheme(F, FORALL, T) :- generalize(F, FORALL, T).

% convert the type of a top level definition into a type scheme
generalize(FUNC_I, FORALL, T):- hasType(FUNC_I, T), include(var, T, FORALL).
generalize(FUNC_I, [], T):- hasType(FUNC_I, T), T\=[], T\=[H|T].

instantiates(Y,F) :- hasTypeScheme(F, FORALL, T), Y=T.

hasTypeScheme(and,[],[bool,[bool,bool]]).
hasTypeScheme(isBool,[X],[X,bool]).

("add", ["int","int","int"]),   --> hasTypeScheme(add, [], [int, [int, int]]).
    ("id", ["X","X"])           --> hasTypeScheme(id, [X], [X,X]).

  is the type var asscoaited with (Add (expr :: X3) (expr::X4) :: X5
  .

-}
genBuiltInConstraints :: PLC ()
genBuiltInConstraints = do
  funcs <- M.toList <$> gets funcInfo
  langConz <- gets langCons
  let langCons' = langConz ++ concat (genBuiltInFunc <$> funcs)
  -- error $ show langCons'
  modify $ \st -> st{langCons = langCons'}
  return ()
  where
    period = ".\n"
    hasTypeScheme = "hasTypeScheme"
    brackets a = "["++a++"]"
    isTypeVar :: String -> Bool
    isTypeVar [] = error "type should never be the empty string"
    isTypeVar (h:_) = h == '_' || isUpper h
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
  -- addNodesToFunc (fst <$> allNodes) -- change later
  fNodes <- S.toList <$> gets currNodes
  fNodeTVars <- mapM getType fNodes
  let nodes = zip fNodes fNodeTVars
  fName <- gets currFunc
  rootId <- gets currRoot
  rg <- gets regCons
  inst <- gets instCons

  case M.lookup rootId m of
    Nothing -> error $ "u got jamba'd" ++ fName ++ show rootId ++ "ALL NODES" ++ show allNodes ++ "map is " ++ show m
    (Just rootTVar) -> do
      let rhs = intercalate "," (rg ++ inst)
          lhs = fName ++ "_typechecks" ++ parens (intercalate "," $ snd <$>nodes)
          f = lhs ++ providedThat ++ parens rhs ++ period
          nodeCons = concat $ nodeConstraint lhs <$> nodes
          f2 = hasType ++ parens (fName ++ comma ++ rootTVar) ++ providedThat ++ lhs ++ period
          f3 = "isTopLevelDef" ++ parens fName ++ period
      -- l <- gets langCons
      p <- gets progCons
      modify $ \st -> st{progCons = p++f++f2++f3 ++nodeCons}
      pure ()
      where
        providedThat = ":-"
        period = ".\n"
        comma = " , "
        hasType = "hasType"
        nodeConstraint :: String -> (NodeID, TVar) -> String
        nodeConstraint rhs (iD, tvar) =
          hasType ++ parens ("node_"++show iD ++ comma ++ tvar) ++ providedThat ++ rhs ++period



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
addLocal nm iD status = do
  tables <- gets varInfo
  case tables of
    [] -> do           -- Case I: empty list of tables
      let tbl = M.fromList [(nm,(iD, status))]
      let tables' = tbl : tables
      modify $ \st -> st{varInfo= tables'}
    (h:tl) -> do       -- Case II: at least one table!
      case M.lookup nm h of
        (Just _) -> do -- case II.1: name present in current layer, 
                       --            so need to add another layer.
          let tbl = M.fromList [(nm,(iD, status))]
          let tables' = tbl : h : tl
          modify $ \st -> st{varInfo= tables'}
        _ -> do        -- case II.2: nm not present in current layer
          let h' = M.insert nm (iD, status) h
          modify $ \st -> st{varInfo = h':tl}


-- {- | Return binder info from shallowest scope.

--  binder is either a local var/func, a built-in func, or a top-level func -}
-- lookupByName2 :: String -> PLC (Either (NodeID, IsTypeScheme) String)
-- lookupByName2 nm = do
--   -- 1) first, look in local var tables
--   tables <- gets varInfo
--   let searchRes = M.lookup nm (head tables)
--   case searchRes of
--     (Just info) -> pure $ Left info
--   -- 2) next, look in built-in funcs tables
--   -- 3) otherwise, assume the nm refers to a top level function?
--   -- in both 2) and 3), would end up just returning name,
--   -- so let's do that instead of checking the built-in func table.
--     _ -> pure $ Right nm
 

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
  where lookupLocal :: String -> [M.Map String (NodeID, IsTypeScheme)]-> PLC (Maybe (NodeID, IsTypeScheme))
        lookupLocal nme tables = do
          case tables of
            [] -> pure Nothing -- base case
            (h:tl) -> do
              case M.lookup nme h of
                (Just info) -> pure $ Just info -- found in layer h!
                _ -> lookupLocal nme tl          -- recurse on deeper layers tl

-- | Return a fresh type variable (used by addNode)
freshTVar :: PLC TVar
freshTVar = do
  suf <- gets suff
  modify $ \st -> st {suff = suf + 1}
  return ("X" ++ show suf)

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
                     , currRoot = 7777777
                     , currNodes = S.empty
                     , regCons = []
                     , instCons = []}




-- data DummyAST = Node DummyAST DummyAST
--  | Leaf


-- data DummyProgram = Dummy [(String,DummyAST)]

-- userAstPass2 :: DummyProgram -> PLC DummyProgram -- NOT WORKING; NEED TO FIX, OR CHANGE ONE BELOW
-- userAstPass2 (Dummy []) = pure $ Dummy []        -- TO TEST ADDBUILTINFUNCS
-- userAstPass2 (Dummy topDefs) = do
--   --addBuiltInFuncs [("howdy",["int","X","bool"])]
--   let x = mapM_ process topDefs
--   pure $ Dummy topDefs
--   where
--     process h = do
--                     enterFunc "aFunction" 0
--                     _ <- userTopDef (snd h)
--                     exitFunc

-- userAstPass :: DummyProgram -> PLC DummyProgram
-- userAstPass (Dummy []) = pure $ Dummy []
-- userAstPass (Dummy (h:t)) = do
--                     enterFunc "aFunction" 0
--                     _ <- userTopDef (snd h)
--                     exitFunc
--                     userAstPass $ Dummy t

-- userTopDef :: DummyAST -> PLC DummyAST
-- userTopDef (Node left right) = do
--   -- do something to modify state!
--   id <- freshNodeId
--   addNode id
--   left' <- userTopDef left
--   right' <- userTopDef right
--   return (Node left' right')
-- userTopDef Leaf = do id <- freshNodeId
--                      addNode id
--                      return Leaf


-- main :: IO ()
-- main = do
--   args <- getArgs
--   case args of
--     [] -> die "Error:  must input a file name.\n"
--     [filename] -> do
--       -- testing constraint generation
--       let ast = Dummy [("jambaJuice", Node (Node Leaf Leaf) (Node Leaf Leaf))]
--       let x = typecheck ast userAstPass
--       print $ show x
--       -- let testingTypeArrow = ["int","int","bool"]
--       -- -- let res = toArrow testingTypeArrow
--       -- print res
--       -- testing constraint generation

--       -- create the file names
--       let constraintFile = filename ++ "-typing-constraints.pl"
--       let resultFile = filename ++ "-contraint-results.pl"

--       -- read in template file contents
--       prologue <- readFile "./templateFiles/prologue.pl" -- read in prologue
--       epilogue <- readFile "./templateFiles/epilogue.pl" -- read in epilogue      
--       dummy <- readFile "./templateFiles/dummy.pl"       -- read in dummy constraints

--       let dummy = progCons x
--       -- write constraints
--       handle <- openFile constraintFile WriteMode -- open constraints file
--       hPutStrLn handle prologue                   -- write prologue
--       hPutStrLn handle dummy                      -- write dummy constraints
--       hPutStrLn handle epilogue                   -- write epilogue 
--       hClose handle                               -- close the constraints file

--       -- perform type checking + type inference      
--       -- run the prolog program through swipl
--       (Just writeEnd, Just readEnd, Just readErrEnd, ph) <- createProcess (proc "swipl" ["-q", "-s", constraintFile]){
--         std_out = CreatePipe,
--         std_in = CreatePipe,
--         std_err = CreatePipe}
--       resHandle <- openFile resultFile WriteMode  -- open results file
--       results <- hGetContents readEnd             -- read from swipl
--       hPutStr resHandle results                   -- write out results
--       hClose resHandle                            -- close the results file  
--       pure () -- exit

--     _ -> die "Error: must input a file name.\n"

-- readUntilDone :: Handle -> String -> Maybe Handle-> IO ()
-- readUntilDone hdl done out = do
--   aLine <- hGetLine hdl
--   print aLine
--   unless (aLine == done) (readUntilDone hdl done out)
--   where print = maybe putStrLn hPutStrLn out

