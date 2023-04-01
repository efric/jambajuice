# Lambda Calculus Expressions

## Building

Use the Haskell Tool Stack [https://www.haskellstack.org]

`stack build`

## Testing

```
cd tests
./runtests.sh
beta1...OK
beta2...OK
beta3...OK
```

## Use

```
stack ghci
ghci> parse "x y z"
x y z
ghci> parse "(\\ n . pred n) 3"
(\n . pred n) 3
ghci> parse "x (y z)"
x (y z)
ghci> parse "(x y) z"
x y z
ghci> parse "\\x.y z"
\x . y z
ghci> parse "\\x y z . x (y z)"
\x . \y . \z . x (y z)
ghci> parse "\\x.x (\\z . z)"
\x . x (\z . z)
ghci> parse "(\\x.x) (\\z . z)"
(\x . x) (\z . z)
ghci> :i Expr
type Expr :: *
data Expr = Var String | Lam String Expr | App Expr Expr
instance Show Expr
ghci> Lam "a" (App (Var "b") (Var "c"))
\a . b c
```

# Syntax

```
<expr>  ::= <id>                  -- variable
          | `\' <id>+ `.' <expr>  -- lambda abstraction
          | <expr> <expr>         -- application
          | `(' <expr> `)'        -- grouping
```

Variable identifiers are any sequence of characters excluding
`\`, `.`, `(`, `)`, `-`, and whitespace

Lambda abstractions are at the lowest precedence;
application binds left-to-right

Space is needed to separate identifiers but is optional elsewhere

Single-line comments start with `--`

Multi-line comments are between `{-` and `-}' and may nest
