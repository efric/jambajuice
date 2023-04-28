module Desugar where
import AST
import qualified Data.ByteString.Lazy.Char8 as C


type Var = String

data Expr
  = Var Var
  | App Expr Expr
  | Lam Var Expr
  | Let Var Expr Expr
  | Lit Lit
  | If Expr Expr Expr
  | Fix Expr
  | Op Binop Expr Expr
  deriving (Show, Eq, Ord)

data Lit
  = LInt Integer
  | LBool Bool
  deriving (Show, Eq, Ord)

data Binop = Add | Sub | Mul | Eql
  deriving (Eq, Ord, Show)

type Decl = (String, Expr)

data Program = Program [Decl] Expr deriving (Show, Eq)

desugardec :: Dec a -> Expr
desugardec (Dec a name args returntype body) = foldr Lam (desugar body) (map desugararg args)

desugararg :: Argument a -> Var
desugararg (Argument _ (Name _ name) t) = C.unpack name

desugar :: Exp a -> Expr
desugar (EApp _ fun arg) = App (desugar fun) (desugar arg)