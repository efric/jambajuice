-- | Abstract syntax tree for the untyped lambda calculus, plus some helpers.
module AST (
  Expr (..)
) where

-- | Lambda Expressions
data Expr
  = Var String
  | Lam String Expr
  | App Expr Expr
  deriving (Eq, Ord)


-- https://www.haskellforall.com/2020/11/pretty-print-syntax-trees-with-this-one.html
showLam, showApp, showVar :: Expr -> String
showLam (Lam i e) = "\\" ++ i ++ " . " ++ showLam e
showLam e = showApp e

showApp (App e1 e2) = showApp e1 ++ " " ++ showVar e2
showApp e = showVar e

showVar (Var i) = i
showVar e = "(" ++ showLam e ++ ")"

instance Show Expr where
  show e = showLam e


