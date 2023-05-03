{-# LANGUAGE OverloadedStrings #-}

module Parser (
  parseModule
) where

import Text.Parsec
    ( ParseError, many1, (<|>), many, parse, try )
import Text.Parsec.Text.Lazy (Parser)
import qualified Text.Parsec.Expr as Ex
import qualified Text.Parsec.Token as Tok
import qualified Data.Text.Lazy as L

import Lexer
    ( Operators,
      Op,
      lexer,
      reserved,
      reservedOp,
      identifier,
      parens,
      contents,
      braces )
import AST
    ( Binop(Neq, Add, Sub, Mul, Eql), Lit(LBool, LInt), Expr(..) )

natural :: Parser Integer
natural = Tok.natural lexer

variable :: Parser Expr
variable = Var <$> identifier

number :: Parser Expr
number = Lit . LInt  <$> natural

bool :: Parser Expr
bool = (reserved "true" >> return (Lit (LBool True)))
    <|> (reserved "false" >> return (Lit (LBool False)))

fix :: Parser Expr
fix = do
  reservedOp "fix"
  Fix <$> expr

lambda :: Parser Expr
lambda = do
  reservedOp "\\"
  args <- many identifier
  reservedOp "->"
  body <- expr
  pure $ foldr Lam body args

letin :: Parser Expr
letin = do
  reserved "let"
  x <- identifier
  reservedOp "="
  e1 <- expr
  reserved "in"
  e2 <- braces expr
  pure $ Let x e1 e2

ifthen :: Parser Expr
ifthen = do
  reserved "if"
  cond <- expr
  tr <- braces expr
  reserved "else"
  fl <- braces expr
  pure $ If cond tr fl

aexp :: Parser Expr
aexp =
      parens expr
  <|> bool
  <|> try number
  <|> ifthen
  <|> fix
  <|> letin
  <|> lambda
  <|> variable

term :: Parser Expr
term = aexp >>= \x ->
                (many1 aexp >>= \xs -> return (foldl App x xs))
                <|> return x

infixOp :: String -> (a -> a -> a) -> Ex.Assoc -> Op a
infixOp x f = Ex.Infix (reservedOp x >> return f)

table :: Operators Expr
table = [
    [
      infixOp "+" (Op Add) Ex.AssocLeft
    , infixOp "-" (Op Sub) Ex.AssocLeft
    ],
    [
      infixOp "*" (Op Mul) Ex.AssocLeft
    ],
    [
      infixOp "==" (Op Eql) Ex.AssocLeft,
      infixOp "!=" (Op Neq) Ex.AssocLeft
    ]
  ]

expr :: Parser Expr
expr = Ex.buildExpressionParser table term

type Binding = (String, Expr)

letdecl :: Parser Binding
letdecl = do
  name <- identifier
  args <- many identifier
  reservedOp "="
  body <- braces expr
  pure (name, foldr Lam body args)

letrecdecl :: Parser (String, Expr)
letrecdecl = do
  reserved "jambatime"
  name <- identifier
  args <- many identifier
  reservedOp "="
  body <- braces expr
  pure (name, Fix $ foldr Lam body (name:args))

val :: Parser Binding
val = do
  ex <- expr
  return ("it", ex)

decl :: Parser Binding
decl = try letrecdecl <|> letdecl <|> val

top :: Parser Binding
top = do
  decl

modl ::  Parser [Binding]
modl = many top

parseModule ::  L.Text -> Either ParseError [(String, Expr)]
parseModule = parse (contents modl) ""