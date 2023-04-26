{
module Parser
  ( parseJamba,
    parseJambaProgram
  ) where

import Data.ByteString.Lazy.Char8 (ByteString)
import Data.Maybe (fromJust)
import Data.Monoid (First (..))

import qualified Lexer as L
import AST
}

%name parseJamba decs
%tokentype { L.RangedToken }
%error { parseError }
%monad { L.Alex } { >>= } { pure }
%lexer { lexer } { L.RangedToken L.EOF _ }
%expect 0

%token
  -- Identifiers
  identifier { L.RangedToken (L.Identifier _) _ }
  -- Constants
  string     { L.RangedToken (L.String _) _ }
  integer    { L.RangedToken (L.Integer _) _ }
  -- Keywords
  let        { L.RangedToken L.Let _ }
  in         { L.RangedToken L.In _ }
  if         { L.RangedToken L.If _ }
  then       { L.RangedToken L.Then _ }
  else       { L.RangedToken L.Else _ }
  -- Arithmetic operators
  '+'        { L.RangedToken L.Plus _ }
  '-'        { L.RangedToken L.Minus _ }
  '*'        { L.RangedToken L.Times _ }
  '/'        { L.RangedToken L.Divide _ }
  -- Comparison operators
  '='        { L.RangedToken L.Eq _ }
  '!='       { L.RangedToken L.Neq _ }
  '<'        { L.RangedToken L.Lt _ }
  '<='       { L.RangedToken L.Le _ }
  '>'        { L.RangedToken L.Gt _ }
  '>='       { L.RangedToken L.Ge _ }
  -- Logical operators
  '&'        { L.RangedToken L.And _ }
  '|'        { L.RangedToken L.Or _ }
  -- Parenthesis
  '('        { L.RangedToken L.LPar _ }
  ')'        { L.RangedToken L.RPar _ }
  -- Braces
  '{'        { L.RangedToken L.LBrace _ }
  '}'        { L.RangedToken L.RBrace _ }
  -- Lists
  '['        { L.RangedToken L.LBrack _ }
  ']'        { L.RangedToken L.RBrack _ }
  ','        { L.RangedToken L.Comma _ }
  -- Types
  ':'        { L.RangedToken L.Colon _ }
  '->'       { L.RangedToken L.Arrow _ }

%right else in
%right '->'
%left '|'
%left '&'
%nonassoc '=' '!=' '<' '>' '<=' '>='
%left '+' '-'
%left '*' '/'

%%
{-
$1, $2, etc: index of body
e.g let name '=' expr. then $1 is let, $2 is name, $3 is '=', etc
-}

optional(p)
  :   { Nothing }
  | p { Just $1 }

many_rev(p)
  :               { [] }
  | many_rev(p) p { $2 : $1 }

many(p)
  : many_rev(p) { reverse $1 }

sepBy_rev(p, sep)
  :                         { [] }
  | sepBy_rev(p, sep) sep p { $3 : $1 }

sepBy(p, sep)
  : sepBy_rev(p, sep) { reverse $1 }

type :: { Type L.Range }
  : name           { TVar (info $1) $1 }
  | '(' ')'        { TUnit (L.rtRange $1 <-> L.rtRange $2) }
  | '(' type ')'   { TPar (L.rtRange $1 <-> L.rtRange $3) $2 }
  | '[' type ']'   { TList (L.rtRange $1 <-> L.rtRange $3) $2 } -- to be removed
  | type '->' type { TArrow (info $1 <-> info $3) $1 $3 }

typeAnnotation :: { Type L.Range }
  : ':' type { $2 }

argument :: { Argument L.Range }
  : '(' name optional(typeAnnotation) ')' { Argument (L.rtRange $1 <-> L.rtRange $4) $2 $3 }
  | name                                  { Argument (info $1) $1 Nothing }

--   = Dec a (Name a) [Argument a] (Maybe (Type a)) (Exp a)
dec :: { Dec L.Range }
  : name many(argument) optional(typeAnnotation) '=' '{' exp  '}' { Dec (info $1 <-> L.rtRange $7) $1 $2 $3 $6 }

decs :: { [Dec L.Range] }
  : many(dec) { $1 }

-- pass identifier to the lambda where it is rewrapped from L.RangedToken (which has token and range) to Name range name
name :: { Name L.Range }
  : identifier { unTok $1 (\range (L.Identifier name) -> Name range name) }

exp :: { Exp L.Range }
  : expapp                   { $1 }
  | expcond                  { $1 }
  | let dec in '{' exp '}'   { ELetIn (L.rtRange $1 <-> L.rtRange $6) $2 $5 }
  | '-' exp                  { ENeg (L.rtRange $1 <-> info $2) $2 }
    -- Arithmetic operators
  | exp '+'  exp             { EBinOp (info $1 <-> info $3) $1 (Plus (L.rtRange $2)) $3 }
  | exp '-'  exp             { EBinOp (info $1 <-> info $3) $1 (Minus (L.rtRange $2)) $3 }
  | exp '*'  exp             { EBinOp (info $1 <-> info $3) $1 (Times (L.rtRange $2)) $3 }
  | exp '/'  exp             { EBinOp (info $1 <-> info $3) $1 (Divide (L.rtRange $2)) $3 }
  -- Comparison operators
  | exp '='  exp             { EBinOp (info $1 <-> info $3) $1 (Eq (L.rtRange $2)) $3 }
  | exp '!=' exp             { EBinOp (info $1 <-> info $3) $1 (Neq (L.rtRange $2)) $3 }
  | exp '<'  exp             { EBinOp (info $1 <-> info $3) $1 (Lt (L.rtRange $2)) $3 }
  | exp '<=' exp             { EBinOp (info $1 <-> info $3) $1 (Le (L.rtRange $2)) $3 }
  | exp '>'  exp             { EBinOp (info $1 <-> info $3) $1 (Gt (L.rtRange $2)) $3 }
  | exp '>=' exp             { EBinOp (info $1 <-> info $3) $1 (Ge (L.rtRange $2)) $3 }
  -- Logical operators
  | exp '&'  exp             { EBinOp (info $1 <-> info $3) $1 (And (L.rtRange $2)) $3 }
  | exp '|'  exp             { EBinOp (info $1 <-> info $3) $1 (Or (L.rtRange $2)) $3 }


expapp :: { Exp L.Range }
  : expapp atom              { EApp (info $1 <-> info $2) $1 $2 }
  | atom                     { $1 }

expcond :: { Exp L.Range }
  : if exp '{' exp '}' %shift   { EIfThen (L.rtRange $1 <-> L.rtRange $5) $2 $4 }
  | if exp '{' exp '}' else '{' exp '}' { EIfThenElse (L.rtRange $1 <-> L.rtRange $9) $2 $4 $8 }

atom :: { Exp L.Range }
  : integer                  { unTok $1 (\range (L.Integer int) -> EInt range int) }
  | name                     { EVar (info $1) $1 }
  | string                   { unTok $1 (\range (L.String string) -> EString range string) }
  | '(' ')'                  { EUnit (L.rtRange $1 <-> L.rtRange $2) }
  | '[' sepBy(exp, ',') ']'  { EList (L.rtRange $1 <-> L.rtRange $3) $2 } -- not used
  | '(' exp ')'              { EPar (L.rtRange $1 <-> L.rtRange $3) $2 }
   -- Arithmetic operators
  | '(' '+' ')'              { EOp (L.rtRange $1 <-> L.rtRange $3) (Plus (L.rtRange $2)) }
  | '(' '-' ')'              { EOp (L.rtRange $1 <-> L.rtRange $3) (Minus (L.rtRange $2)) }
  | '(' '*' ')'              { EOp (L.rtRange $1 <-> L.rtRange $3) (Times (L.rtRange $2)) }
  | '(' '/' ')'              { EOp (L.rtRange $1 <-> L.rtRange $3) (Divide (L.rtRange $2)) }
  -- Comparison operators
  | '(' '=' ')'              { EOp (L.rtRange $1 <-> L.rtRange $3) (Eq (L.rtRange $2)) }
  | '(' '!=' ')'             { EOp (L.rtRange $1 <-> L.rtRange $3) (Neq (L.rtRange $2)) }
  | '(' '<' ')'              { EOp (L.rtRange $1 <-> L.rtRange $3) (Lt (L.rtRange $2)) }
  | '(' '<=' ')'             { EOp (L.rtRange $1 <-> L.rtRange $3) (Le (L.rtRange $2)) }
  | '(' '>' ')'              { EOp (L.rtRange $1 <-> L.rtRange $3) (Gt (L.rtRange $2)) }
  | '(' '>=' ')'             { EOp (L.rtRange $1 <-> L.rtRange $3) (Ge (L.rtRange $2)) }
  -- Logical operators
  | '(' '&' ')'              { EOp (L.rtRange $1 <-> L.rtRange $3) (And (L.rtRange $2)) }
  | '(' '|' ')'              { EOp (L.rtRange $1 <-> L.rtRange $3) (Or (L.rtRange $2)) }


{
parseError :: L.RangedToken -> L.Alex a
parseError _ = do
  (L.AlexPn _ line column, _, _, _) <- L.alexGetInput
  L.alexError $ "Parse error at line " <> show line <> ", column " <> show column

lexer :: (L.RangedToken -> L.Alex a) -> L.Alex a
lexer = (=<< L.alexMonadScan)

-- | Build a simple node by extracting its token type and range.
unTok :: L.RangedToken -> (L.Range -> L.Token -> a) -> a
unTok (L.RangedToken tok range) ctor = ctor range tok

-- | Unsafely extracts the the metainformation field of a node. basically always gonna be a range
info :: Foldable f => f a -> a
info = fromJust . getFirst . foldMap pure

-- | Performs the union of two ranges by creating a new range starting at the
-- start position of the first range, and stopping at the stop position of the
-- second range.
-- Invariant: The LHS range starts before the RHS range.
(<->) :: L.Range -> L.Range -> L.Range
L.Range a1 _ <-> L.Range _ b2 = L.Range a1 b2

-- | Parse a 'ByteString' and yield a list of 'Dec'.
parseJambaProgram :: ByteString -> Either String [Dec L.Range]
parseJambaProgram = flip L.runAlex parseJamba

}