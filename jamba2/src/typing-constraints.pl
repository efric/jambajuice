%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         these predicates should be at the top of every typechecking file              %%

use_module(library(apply)).       % to import include
:- discontiguous hasType/2.       % ignore discontiguous warnings
:- discontiguous hasTypeScheme/3. % ignore discontiguous warnings
:- discontiguous isTopLevelDef/1. % ignore discontiguous warnings
:- style_check(-singleton).       % ignore singleton var warnings

% generate a type scheme for a top level definition if possible
hasTypeScheme(F, FORALL, T) :- generalize(F, FORALL, T).

% convert the type of a top level definition into a type scheme
generalize(FUNC_I, FORALL, T):- hasType(FUNC_I, T), include(var, T, FORALL).
generalize(FUNC_I, [], T):- hasType(FUNC_I, T), T\=[], T\=[H|T].

% convert the type scheme of a top-level definition into a type
instantiates(Y,F) :- hasTypeScheme(F, FORALL, T), Y=T.
% we use copy_term/2 to instantiate the type scheme of a local definition (let bindings)

% helper constraints
arrow([_,_]).
snd(A,B):-A=[H1,H2],B=H2.
fst(A,B):-A=[H1,H2],B=H1.
%%                                                                                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
foo_typechecks(X0,X1,X2,X3,X4):-(arrow(X0),fst(X0,X1),snd(X0,X2),X1=X1,X3=X4,X4=X2,X2=int,X3=X1,X4=int).
hasType(foo , X0):-foo_typechecks(X0,X1,X2,X3,X4).
isTopLevelDef(foo).
hasType(node_0 , X0):-foo_typechecks(X0,X1,X2,X3,X4).
hasType(node_1 , X1):-foo_typechecks(X0,X1,X2,X3,X4).
hasType(node_2 , X2):-foo_typechecks(X0,X1,X2,X3,X4).
hasType(node_3 , X3):-foo_typechecks(X0,X1,X2,X3,X4).
hasType(node_4 , X4):-foo_typechecks(X0,X1,X2,X3,X4).
jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7):-(arrow(X6),fst(X6,X7),snd(X6,X5),instantiates(X6,foo),X7=int).
hasType(jambajuice , X5):-jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7).
isTopLevelDef(jambajuice).
hasType(node_0 , X0):-jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7).
hasType(node_1 , X1):-jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7).
hasType(node_2 , X2):-jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7).
hasType(node_3 , X3):-jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7).
hasType(node_4 , X4):-jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7).
hasType(node_5 , X5):-jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7).
hasType(node_6 , X6):-jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7).
hasType(node_7 , X7):-jambajuice_typechecks(X0,X1,X2,X3,X4,X5,X6,X7).

% output results of typechecking!
:- initialization forall((hasType(X,Y),not(isTopLevelDef(X))), (write(X),write(' '), writeln(Y))),halt().
