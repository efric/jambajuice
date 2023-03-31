module HW
  ( fv
  , subst
  , normalstep
  , pickFresh
  , repeatedly 
  , printnormal
  ) where

import AST
import qualified Data.Set as Set
import Parse (parse)

-- | Return the free variables in an expression
fv :: Expr -> Set.Set String
fv _ = Set.singleton "UNIMPLEMENTED" -- Replace with your solution to problem 1



-- | Substitute n for x in e, avoiding name capture
--    subst n x e     e[x := n]
subst :: Expr -> String -> Expr -> Expr
subst _ _ _ = Var "UNIMPLEMENTED" -- Replace with your solution to problem 2



-- | Take a single step in normal order reduction or return Nothing
normalstep :: Expr -> Maybe Expr
normalstep _ = Just (Var "UNIMPLEMENTED") -- Replace with your solution to problem 3




-- | Return a "fresh" name not already in the set.
-- Tries x' then x'', etc.
pickFresh :: Set.Set String -> String -> String
pickFresh s = pickFresh'
  where pickFresh' n | n `Set.notMember` s = n
        pickFresh' n                       = pickFresh' $ n ++ "'"
               
-- | Repeatedly apply a function to transform a value, returning the list
-- of steps it took.  The result list starts with the given initial value
repeatedly :: (a -> Maybe a) -> a -> [a]
repeatedly f = repeatedly'
  where repeatedly' x = x : case f x of Nothing -> []
                                        Just y -> repeatedly' y

-- | Print out the series of normal order reduction steps
printnormal :: String -> IO ()
printnormal = mapM_ print . repeatedly normalstep . parse
