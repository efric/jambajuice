module Main (main) where

import Parser (parseModule)
import System.Environment (getArgs)
import System.Exit (die)
import qualified Data.Text.Lazy.IO as L
import qualified Data.Map as Map
import Eval ( TermEnv, emptyTmenv, runEval )
import AST as A
import Data.List (foldl')
import qualified PLCgen as P
import Control.Monad.State.Lazy
import AnnotatedAST

usage :: String
usage = "./src/Main tests/examples/p1.jj"

mainfn :: String
mainfn = "jambajuice"

-- -- map with keys: functions names, values: number of arguments
-- type Func2Arg = Map.Map String Integer

evalDef :: TermEnv -> (String, Expr) -> TermEnv
evalDef env (nm, ex) = tmctx'
  where (_, tmctx') = runEval env nm ex

{-
function name has to be start with lower case
Type variables are upper case or start with an underscore
-}
-- makeBuiltInFuncs :: [(String, [String])]
-- makeBuiltInFuncs = 
--   [
--     ("add", ["int","int","int"]),
--     ("id", ["X","X"])
--   ]

traverseAST :: [(String, AExpr Integer)] -> P.PLC [(String, AExpr Integer)]
traverseAST topDefs = do 
  -- add builtin functions
  -- addBuiltInFuncs makeBuiltInFuncs
  mapM_ defConstraints topDefs
  return topDefs



defConstraints :: (String, AExpr Integer) -> P.PLC ()
defConstraints (funcName, root) = do P.enterFunc funcName (extractId root)
                                     addASTNode root
                                     -- recursively add constraints for each node
                                     defConstraintsNode root
                                     P.exitFunc 

defConstraintsNode :: AExpr Integer -> P.PLC()
defConstraintsNode self@(AOp a t e1 e2) = 
{-
 Op Binop Expr Expr
 (Op Binop X1   X2) X3
 X1 = X2  // unify
 X2 = X3
 X3 = int // unify

 -- check results map and nodetype map are the same size
 -- type schemes no need cus no built in fns
-}
  case t of 
    Add -> do 
      P.unifyNodeNode (extractId e1) (extractId e2)
      P.unifyNodeNode (extractId e2) (extractId self)
      P.unifyNodeType a "int"
      defConstraintsNode e1
      defConstraintsNode e2
    Sub -> do 
      P.unifyNodeNode (extractId e1) (extractId e2)
      P.unifyNodeNode (extractId e2) (extractId self)
      P.unifyNodeType (extractId self) "int"
      defConstraintsNode e1
      defConstraintsNode e2
    Mul -> do 
      P.unifyNodeNode (extractId e1) (extractId e2)
      P.unifyNodeNode (extractId e2) (extractId self)
      P.unifyNodeType (extractId self) "int"
      defConstraintsNode e1
      defConstraintsNode e2
    _ -> do
      P.unifyNodeNode (extractId e1) (extractId e2)
      P.unifyNodeType (extractId self) "bool"
      defConstraintsNode e1
      defConstraintsNode e2
defConstraintsNode (ALit a l) = do
  -- error $ "bad" ++ show self
  case l of
    (LInt _) -> P.unifyNodeType a "int"
    (LBool _) -> P.unifyNodeType a "bool"
  pure ()
defConstraintsNode (AVar nm nid) = P.genVar nid nm
{-
enterLam :: NodeID -> String -> NodeID -> NodeID -> PLC ()
enterLam self binderName binderID body = do
exitLam :: String -> PLC (
  enterLet self binderName binderID binderRHS body = do
enterLet :: NodeID -> String -> NodeID -> NodeID -> NodeID -> PLC ()
exitLet :: String -> PLC ()
-}
defConstraintsNode (AApp a e1 e2) = do
 P.enterApp a (extractId e1) (extractId e2)
 defConstraintsNode e1 
 defConstraintsNode e2
defConstraintsNode self@(ALam a e1 e2) = do
 P.enterLam a (extractName e1 self) (extractId e1) (extractId e2)
 defConstraintsNode e1 
 defConstraintsNode e2
 P.exitLam $ extractName e1 self
defConstraintsNode self@(ALet a e1 e2 e3) = do
 P.enterLet a (extractName e1 self) (extractId e1) (extractId e2) (extractId e3)
 defConstraintsNode e1 -- x
 defConstraintsNode e2 -- 70
 defConstraintsNode e3 -- body
 P.exitLet (extractName e1 self)
defConstraintsNode (AIf a e1 e2 e3) = do
 P.unifyNodeType (extractId e1) "bool"
 P.unifyNodeNode (extractId e2) (extractId e3)
 P.unifyNodeNode a (extractId e2)
 P.unifyNodeNode a (extractId e3)
 defConstraintsNode e1 
 defConstraintsNode e2
 defConstraintsNode e3
defConstraintsNode (AFix a e3@(ALam _ e1 _)) = do
  P.genFix a (extractId e3) ( extractId e1)
  defConstraintsNode e3
--  x4 <- P.getType a
--  x3 <- P.getType (extractId e3)
--  x1 <- P.getType (extractId e1)
  -- x4 <- (getType a)
  -- pure ()

defConstraintsNode (AFix _ _) = error "fix only takes lambdas right now"
-- defConstraintsNode (AFix a e1) = do
--  defConstraintsNode e1 

addASTNode :: AExpr Integer -> P.PLC ()
addASTNode (AVar a _) = P.addNode a
addASTNode (AApp a e1 e2) = do 
  P.addNode a
  addASTNode e1
  addASTNode e2
addASTNode (ALam a v body) = do 
  P.addNode a
  P.addNode (extractId v)
  addASTNode body
addASTNode (ALet a v e1 e2) = do 
  P.addNode a
  P.addNode (extractId v)
  addASTNode e1
  addASTNode e2
addASTNode (ALit a _ ) = do P.addNode a
addASTNode (AIf a e0 e1 e2) = do {P.addNode a; addASTNode e0; addASTNode e1; addASTNode e2}
addASTNode (AFix a e) = do {P.addNode a; addASTNode e}
addASTNode (AOp a _ e1 e2) = do {P.addNode a; addASTNode e1; addASTNode e2}

extractId :: AExpr Integer -> Integer 
extractId (AVar a _) = a
extractId (AApp a _ _) = a
extractId (ALam a _ _) = a
extractId (ALet a _ _ _) = a
extractId (ALit a _ ) = a
extractId (AIf a _ _ _) = a
extractId (AFix a _) = a
extractId (AOp a _ _ _) = a

extractName :: AExpr Integer -> AExpr Integer -> String
extractName (AVar _ v) _ = v
extractName e parent = error $ show e ++ " " ++ show parent

-- jamba2: AIf 3 (AOp 4 Eql (AVar 5 "x") (ALit 6 (LInt 70))) (ALit 7 (LInt 99)) (ALit 8 (LInt 70))


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
         -- print ast
          --(a -> b -> a) -> a -> [b] -> a
          -- let w = \(res,num) func -> (res : annotateExpr num func, )
          let threadThruUniqID :: ([(AExpr Integer, Integer)], Integer) -> Expr -> ([(AExpr Integer, Integer)], Integer)
              threadThruUniqID ([],_) e  = let res = annotateExpr 0 e in ([res], snd res)
              threadThruUniqID (prev,num) e = let res = annotateExpr num e in (res:prev, snd res)
          -- let w = \(res,num) -> annotateExpr num
          -- let z = foldl w (AVar 9999 "disappears", 0) (snd <$> ast)
          -- let z = reverse .map fst.fst $ foldl threadThruUniqID ([], 0) (snd <$> ast)
          -- let a = (annotateExpr 0) . snd <$> ast -- HOODLE
          -- let b = fst <$> ast
          let c = zip (fst <$> ast) $ reverse .map fst.fst $ foldl threadThruUniqID ([], 0) (snd <$> ast)
         -- print c
          _ <- P.solve c traverseAST -- typechecking
          let eval = foldl' evalDef emptyTmenv ast
          case Map.lookup mainfn eval of
            Just v -> print v
            Nothing -> die $ "No jambajuice function (" ++ mainfn ++ ") in file\n"
          pure ()

    _ -> die $ "Error: incorrect usage.\n Example usage:\n"  ++ usage

-- annotateAST :: [(String, Expr)] -> [(String, Expr)]
-- annotateAST = _


-- Expr -> m (Expr int)
-- used execState to spit out (Expr int) without the m

{-
let id = \x.x in isNum(id 4) && isNum(id False)
                         X4            X5
                    id :: int -> int    id :: bool -> bool
                  ((Var "id"), X4)
                  ( (Var "id"), X5)

                  (4, X4)
                  (5, X5)
    id to node
    4 ---> (Var "id")
    5 ---> (Var "id")

    AST a
    AST int
-}
