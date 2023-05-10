module AnnotatedAST where

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


{-
 5 + 6
 Op Add (Lit LInt 5) (Lit LInt 6)
 App (App (Var "Add") (Lit LInt 5)) (Lit LInt 6)
 
 Op Binop Expr Expr
 (Op Binop X1   X2) X3
 X1 = X2  // unify
 X3 = int // unify

 Let id = lam y. y in isNum (id 2) && isNum (id False)
     X1                        X4                X5
  table: "id", IsScheme =true
  X4 = type (id) but we check if id is a type scheme
  instead of this, X4 = X1 we do
  copy_term(X1,X4) -- X4 must unify with a copy of X1 with fresh type variables
  
 // unify with instantiated type scheme

^ true for Add | Sub | Mul

Op Binop Expr Expr
Eql | Neq
X1 = X2
X3 = bool

If Expr Expr Expr
(If X1    X2   X3) X4
X1 = bool
X2 = X3
X4=X2=X3
-}

data Lit
  = LInt Integer
  | LBool Bool
  deriving (Show, Eq, Ord)

data Binop = Add | Sub | Mul | Eql | Neq | Lt | Le | Gt | Ge
  deriving (Eq, Ord, Show)

type Decl = (String, Expr)

data Program = Program [Decl] Expr deriving (Show, Eq)