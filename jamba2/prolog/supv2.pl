
% rlwrap swipl supv2.pl

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

% built in functions (target language specific)
hasTypeScheme(add,[],[int, [int, int]]).
hasTypeScheme(and,[],[bool,[bool,bool]]).
hasTypeScheme(isBool,[X],[X,bool]).
hasTypeScheme(isNum,[X],[X,bool]).

% rest of knowledge base below is program specific...

sup_typechecks(A,C,D,E,F,G,H) :-
 [C, D] = A, arrow(A),
 arrow(E), fst(E,F), snd(E,D),
 arrow(G), fst(G,H), snd(G,E),
 instantiates(G,add), H = C, F = int.

hasType(node_1, A):- sup_typechecks(A,_,_,_,_,_,_).
hasType(node_2, C):- sup_typechecks(_,C,_,_,_,_,_).
hasType(node_3, D):- sup_typechecks(_,_,D,_,_,_,_).
hasType(node_4, E):- sup_typechecks(_,_,_,E,_,_,_).
hasType(node_5, F):- sup_typechecks(_,_,_,_,F,_,_).
hasType(node_6, G):- sup_typechecks(_,_,_,_,_,G,_).
hasType(node_7, H):- sup_typechecks(_,_,_,_,_,_,H).

% output results of typechecking!
:- initialization forall(hasType(X,Y), (write(X),write(' '), writeln(Y))),halt().