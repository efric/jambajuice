module Eval (
  runEval,

  TermEnv,
  emptyTmenv
) where

import AST
import qualified Data.ByteString.Lazy.Char8 as C
import Control.Monad.Identity
import qualified Data.Map as Map

instance MonadFail Identity where
  fail = error "Jamba went bad" 

data Value a
  = VInt Integer
  | VBool Bool
  | VClosure String (Exp a) (TermEnv a)

type TermEnv a = Map.Map String (Value a)
type Interpreter t = Identity t

emptyTmenv :: TermEnv a
emptyTmenv = Map.empty

instance Show (Value a) where
  show (VInt n) = show n
  show (VBool n) = show n
  show VClosure{} = "<<closure>>"

eval :: TermEnv a -> Exp a -> Interpreter (Value a)
eval env expr = case expr of
  EInt _ k -> return $ VInt k
--  Lit (LBool k) -> return $ VBool k
  EVar _ (Name _ x) -> do
    let Just v = Map.lookup (C.unpack x) env 
    pure v

  EBinOp _ a op b -> do
    VInt a' <- eval env a
    VInt b' <- eval env b
    return $ (binop op) a' b' 

{-
  ELetIn _ x body ->
    return (VClosure x body env)

  App fun arg -> do
    VClosure x body clo <- eval env fun
    argv <- eval env arg
    let nenv = Map.insert x argv clo
    eval nenv body

  Let x e body -> do
    e' <- eval env e
    let nenv = Map.insert x e' env
    eval nenv body

  If cond tr fl -> do
    VBool br <- eval env cond
    if br == True
    then eval env tr
    else eval env fl

  Fix e -> do
    eval env (App e (Fix e))
-}

binop :: Operator a -> Integer -> Integer -> Value a
binop (Plus _) a b = VInt $ a + b
binop (Times _)  a b = VInt $ a * b
binop (Minus _)  a b = VInt $ a - b
binop (Eq _)  a b = VBool $ a == b

runEval :: TermEnv a -> String -> Exp a -> (Value a, TermEnv a)
runEval env nm ex =
  let res = runIdentity (eval env ex) in
  (res, Map.insert nm res env)