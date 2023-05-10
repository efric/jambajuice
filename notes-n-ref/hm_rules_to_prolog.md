For reference:

![image info](./slide_17.png)

![image info](./slide_59.png)

![image info](./TAPL_page_144.png)

1. App rule

   ```
   App Expr Expr
   (App (arg1 :: X1) (arg2 :: X2)) :: X3
   ```

   Since we are applying `arg1` to `arg2`, `arg1` must be a function, so it must have a type like `A -> B`.

   Suppose then `arg1` :: `A -> B`.

   Since `arg1` takes `arg2` as input, the type of `arg2` must be the same as the type `A`.

   After applying `arg1` to `arg2`, the result of their application must be the return type of `arg1`, type `B`.

   Prolog Constraints:

   ```
   arrow(X1),
   fst(X1,X2),
   snd(X1, X3).
   ```

   

2. Let rule

   ```
   Let Var Expr Expr
   (Let ((Var "someName") :: X1) (arg2 :: X2) (arg3 :: X3)) :: X4
   ```

   Since `arg1` is assigned the value of `arg2`, the types of `arg1` and `arg2` must match.

   The type of a let expression is the type of its body.

   Let's make sure to add the binder to our table, marked with its node number and distinguishing it with the fact that it was defined by a let, not a lambda: `addToTable("someName", node_number, Binder)`.

   Prolog Constraints:

   ```
   X1 = X2,
   X4 = X3.
   ```

   

3. Lambda Rule

   ```
   Lam Var Expr
   (Lam (Var "someName" :: X1) (arg2 :: X2)) :: X3
   ```

   The type of a lambda is a function that takes one input and returns one output. Since this Lambda takes in `"someName"` and returns the expression represented by `arg2`, we can say it takes in the type of `"someName"` and returns the type of `arg2`.

   Prolog Constraints:

   ```
   arrow(X3),
   fst(X3,X1),
   snd(X3,X2).
   ```

   

4. Var Rule

   ```
   (Var "someName") :: X1
   ```

   Let's look up the variable in our table.

   - Case 1: `lookup("someName")` returns `(node_id, Binder)`

     ```
     Node-to-Type table
     _____________________
     Node ID | Type Var(s)           
     1       | A
     ...
     node_id | J
     
     Var-to-Node Table
     ____________________________________
     "Var name" | Node ID | Arg or Binder? 
     "someName" | node_id | Binder
     ```

     Then we know "someName" was defined by a let expression and could be polymorphic. Therefore this instance of "someName" must *instantiate* the type of node_id.

     Prolog Constraints:

     ```
     copy_term(J,X1).
     ```

     

   - Case 2: `lookup("someName")` returns `(node_id, Arg)`

     ```
     Node-to-Type table
     _____________________
     Node ID | Type Var(s)           
     1       | A
     ...
     node_id | J
     
     Var-to-Node Table
     ____________________________________
     "Var name" | Node ID | Arg or Binder? 
     "someName" | node_id | Arg
     ```

     Then we know "someName" was defined by a lambda expression and cannot be polymorphic. Therefore this instance of "someName" must be the same as the type of node_id.

     Prolog Constraints:

     ```
     X1 = J.
     ```

5. Primitive Rule

   ```
   (Lit 5) :: X2
   ```

   Prolog Constraints:

   ```
   X2 = int.
   ```

   

6. Fix Rule

   ```
   (fix (Lam (Var "h")::X1 Expr :: X2)::X3 )::X4
   ```

   ```
   arrow(X1),
   snd(X3,X4).
   ```

   

7. Instantiation in more detail?
   ```
   % generate a type scheme for a top level definition if possible
   hasTypeScheme(F, FORALL, T) :- generalize(F, FORALL, T).
   
   % convert the type of a top level definition into a type scheme
   generalize(FUNC_I, FORALL, T):- hasType(FUNC_I, T), include(var, T, FORALL).
   generalize(FUNC_I, [], T):- hasType(FUNC_I, T), T\=[], T\=[H|T].
   
   % convert the type scheme of a top-level definition into a type
   instantiates(Y,F) :- hasTypeScheme(F, FORALL, T), Y=T.
   % we use copy_term/2 to instantiate the type scheme of a local definition (let bindings)
   ```

   TODO: explain what's going on >.<"

8. Helper Constraints

   ```
   arrow([_,_]).
   snd(A,B):-A=[H1,H2],B=H2.
   fst(A,B):-A=[H1,H2],B=H1.
   ```

   

   