module PrologParser (
    parseProlog
) where

import qualified Data.Map as M
import qualified Data.Text.Lazy as L
import Text.Parsec
    ( alphaNum,
      char,
      space,
      endBy,
      (<|>),
      many,
      parse,
      ParseError,
      try,
      ParsecT,
      endOfLine, digit, optional )
import Text.Parsec.Text.Lazy (Parser)
import qualified Data.Functor.Identity

data Type = Type String | Arrow Type Type deriving Show

singletype :: Parser Type
singletype = do
    stype <- many alphaNum
    return $ Type stype

arrow :: Parser Type
arrow = do
    input <- many alphaNum <* char ','
    output <- try arrowtype <|> singletype
    return $ Arrow (Type input) output

arrowtype :: Parser Type
arrowtype = char '[' *> arrow <* char ']'

types :: Parser Type
types = try arrowtype <|> singletype

line :: Parser (M.Map Integer Type)
line = do
    node <- many alphaNum *> char '_' *> many digit <* space
    M.singleton (read node) <$> types

prolog :: ParsecT
  L.Text () Data.Functor.Identity.Identity (M.Map Integer Type)
prolog = do
    res <- endBy line (optional endOfLine)
    return $ M.unions res

parseProlog :: L.Text -> Either ParseError (M.Map Integer Type)
parseProlog = parse prolog ""