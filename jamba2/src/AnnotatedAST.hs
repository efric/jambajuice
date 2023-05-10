module AnnotatedAST where

import AST 
import Control.Monad.State

data AExpr a
  = AVar a Var
  | AApp a (AExpr a) (AExpr a)
  | ALam a (AExpr a)  (AExpr a)
  | ALet a (AExpr a) (AExpr a) (AExpr a)
  | ALit a Lit
  | AIf a (AExpr a) (AExpr a) (AExpr a)
  | AFix a (AExpr a)
  | AOp a Binop (AExpr a) (AExpr a)
  deriving (Show, Eq, Ord)

type ID = State Integer

-- checkPure :: I.Expr I.Type -> IsPure
-- checkPure e = runComp $ do
--   resetToPure
--   everywhereM (mkM isPure) e
--  where runComp :: CheckPure a -> IsPure
--        runComp a = execState a True

annotateExpr :: Expr -> AExpr Integer
annotateExpr = runComp . giveId
 where runComp a = evalState a 0

getFreshId :: ID Integer
getFreshId = do
  num <- get
  put (num +1)
  return num

giveIdVar :: Var -> ID (AExpr Integer)
giveIdVar v =  do 
  fid <- getFreshId
  return (AVar fid v)

giveId :: Expr -> ID (AExpr Integer)
giveId (Var v) = do {fid <- getFreshId; return (AVar fid v)}
giveId (Lit l) = do {fid <- getFreshId; return (ALit fid l)}
giveId (App a b) = do 
  fid <- getFreshId
  a' <- giveId a
  b' <- giveId b 
  return $ AApp fid a' b'
giveId (Lam v e) = do
  fid <- getFreshId
  v' <- giveIdVar v
  e' <- giveId e
  return $ ALam fid v' e'
giveId (Let v a b) = do
  fid <- getFreshId
  v' <- giveIdVar v
  a' <- giveId a
  b' <- giveId b 
  return $ ALet fid v' a' b'
giveId (If a b c) = do
  fid <- getFreshId
  a' <- giveId a
  b' <- giveId b 
  c' <- giveId c 
  return $ AIf fid a' b' c'
giveId (Fix e) = do
  fid <- getFreshId
  e' <- giveId e 
  return $ AFix fid e'
giveId (Op binop a b) = do 
  fid <- getFreshId
  a' <- giveId a
  b' <- giveId b 
  return $ AOp fid binop a' b'