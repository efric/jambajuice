%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%         these predicates should be at the top of every typechecking file              %%

use_module(library(apply)).       % to import include
:- discontiguous hasType/2.       % ignore discontiguous warnings
:- discontiguous hasTypeScheme/3. % ignore discontiguous warnings
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

% language specific
hasTypeScheme(and,[],[bool,[bool,bool]]).
hasTypeScheme(isBool,[X],[X,bool]).
hasTypeScheme(isNum,[X],[X,bool]).

% program specific
test_let_typechecks(X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22):-
X11=X12, X10=X14, 
arrow(X12), fst(X12,X13), snd(X12,X16),
X15=X17, X14=X18,
arrow(X19), fst(X19,X20), snd(X19,X17),
arrow(X21), fst(X21,X22), snd(X21,X18),
X20=bool, X22=int, X16=X13, copy_term(X11,X21), copy_term(X11,X19).

hasType(node_17,X10) :- test_let_typechecks(X10,_,_,_,_,_,_,_,_,_,_,_,_).
hasType(node_18,X11) :- test_let_typechecks(_,X11,_,_,_,_,_,_,_,_,_,_,_).
hasType(node_19,X12) :- test_let_typechecks(_,_,X12,_,_,_,_,_,_,_,_,_,_).
hasType(node_20,X13) :- test_let_typechecks(_,_,_,X13,_,_,_,_,_,_,_,_,_).
hasType(node_21,X14) :- test_let_typechecks(_,_,_,_,X14,_,_,_,_,_,_,_,_).
hasType(node_22,X15) :- test_let_typechecks(_,_,_,_,_,X15,_,_,_,_,_,_,_).
hasType(node_23,X16) :- test_let_typechecks(_,_,_,_,_,_,X16,_,_,_,_,_,_).
hasType(node_24,X17) :- test_let_typechecks(_,_,_,_,_,_,_,X17,_,_,_,_,_).
hasType(node_25,X18) :- test_let_typechecks(_,_,_,_,_,_,_,_,X18,_,_,_,_).
hasType(node_26,X19) :- test_let_typechecks(_,_,_,_,_,_,_,_,_,X19,_,_,_).
hasType(node_27,X20) :- test_let_typechecks(_,_,_,_,_,_,_,_,_,_,X20,_,_).
hasType(node_28,X21) :- test_let_typechecks(_,_,_,_,_,_,_,_,_,_,_,X21,_).
hasType(node_29,X22) :- test_let_typechecks(_,_,_,_,_,_,_,_,_,_,_,_,X22).

% output results of typechecking!
:- initialization forall(hasType(X,Y), (write(X),write(' has type '), writeln(Y))).
