% Example 1.1 from
% https://course.ccs.neu.edu/cs4410sp19/lec_type-inference_notes.html

use_module(library(apply)). %to import include

% messing around
likesImprov(jane).

/* Let's typecheck this program; first we will typecheck f, then we will typecheck f(38).

def f(x):
  x + 6

f(38)

Typechecking f:
    f(x)             f(x): T2
      |
     plus            (x+6): PRIM2RESULT
     /  \
    /    \
   x      6          x:T1  6:int  

We know that plus : [int, int, int].
Unify [T1, int, PRIM2RESULT] with [int, int, int].
Unify T2 with PRIM2RESULT.
Conclusion: f : [int, int].

Typechecking f(38):
    f(38)          f(38): APP_RESULT
    
We know that f : [int, int].
Unify [int, APP_RESULT] with [int, int]
Conclusion: f(38) : int.

Longer explanation + link at bottom of this file!
*/

% type schemes
hasTypeScheme(plus, [], [int,int,int]).
hasTypeScheme(f, FORALL, T) :- generalize(f_i, FORALL, T). % program specific

% instantiations of type schemes needed for typechecking
instantiates(plus_i, plus).                                % program specific
instantiates(f_i,f).                                       % program specific

% convert the type of FUNC_I into a type scheme
generalize(FUNC_I, FORALL, T):- hasType(FUNC_I, T), include(var, T, FORALL).

% types
type(int).
type(bool).
type(X) :- arrow(X).
arrow([H1, H2]):- type(H1), type(H2).

% literals have known types
% hasType('false', bool).
% hasType('true', bool).
% hasType(6, int).                                           % program specific
% hasType(38, int).                                          % program specific


% rest of knowledge base below is program specific...

% we can instantiate the type scheme of plus as the type [int, int, int]
hasType(plus_i, [int,int,int]).

hasType(f_i,[T1,T2])              :- f_typechecks(T1, T2, _).
hasType(x,T1)                     :- f_typechecks(T1, _, _).
hasType(x_plus_six, PRIM2RESULT)  :- f_typechecks(_, _, PRIM2RESULT).
hasType(f_of_38, APP_RESULT)      :- hasType(f_i,X), [int, APP_RESULT] = X.

f_typechecks(T1, T2, PRIM2RESULT) :- [T1, int, PRIM2RESULT] = [int, int, int], T2 = PRIM2RESULT.

:- initialization forall(hasType(X,Y), (writeln(X), writeln(Y))), halt.

/*
Hindley Milner Example: https://course.ccs.neu.edu/cs4410sp19/lec_type-inference_notes.html#%28part._.Type_inference__guessing_correctly__every_time%29

def f(x):
  x + 6

f(38)

Let’s start by inferring a type for f. We have no annotations, so we simply create new type variables as needed, 
and assert that f has type 'T1 -> 'T2, for two unknown type variables 'T1 and 'T2. 
We begin to infer a type for the body of f 
by binding the arguments to their types in our type environment – here, x : 'T1.
We recur into the body of f, and examine x + 6. This is an EPrim2 expression, 
so we look up the type scheme for Plus, and see that it is Forall [], (Int, Int -> Int). 
We look at the arguments to the operator, and infer their types. 
We look up x in the environment and obtain 'T1, and determine that all numbers have type Int. 
We know that this operation will produce some result type, so we make up a new type variable 'prim2result. 
We can now construct a type ('T1, Int -> 'prim2result), and unify it with the type (Int, Int -> Int). 
This produces a substitution ['T1 = Int, 'prim2result = Int] We apply that substitution, and deduce that x : Int. 
The result of our expression has type 'prim2result, and since it is the entirety of the body of f, 
we unify that with the result type 'T2, making sure to preserve the substitution where ['prim2result = Int]. 
Our net result is f : Int -> Int, which we can generalize to the type scheme Forall [], Int -> Int, 
and update our function environment accordingly.

We next need to infer types for f(38). We repeat a similar process: 
we lookup the type scheme for f, we infer a type for 38, and make up a new result type 'app_result, 
and unify Int -> Int (which is the type of f) with Int -> 'app_result. 
We deduce that ['app_result = Int], and this is the final type of our program.

*/

