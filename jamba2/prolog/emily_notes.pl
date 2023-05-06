% Let's make app rule work in prolog!

use_module(library(apply)). %to import include

likesImprov(jane). % sanity check

% rlwrap swipl emily_notes.pl

% % type schemes
% hasTypeScheme(plus, [], [int,int,int]).
% hasTypeScheme(f, FORALL, T) :- generalize(f_i, FORALL, T). % program specific

% % instantiations of type schemes needed for typechecking
% instantiates(plus_i, plus).                                % program specific
% instantiates(f_i,f).                                       % program specific

% convert the type of FUNC_I into a type scheme
generalize(FUNC_I, FORALL, T):- hasType(FUNC_I, T), include(var, T, FORALL).

% types
type(int).
type(bool).
type(X) :- arrow(X).
arrow([H1, H2]):- type(H1), type(H2).

% literals have known types
hasType('false', bool).
hasType('true', bool).
hasType(6, int).                                           % program specific
hasType(38, int).                                          % program specific

% rest of knowledge base below is program specific...
sup_typechecks(A,B,C,D,E,F,G,H) :- [C, D] = [A, B], C = C, H = C, F = int.

hasType(node_1, [A,B]):- sup_typechecks(A,B,_,_,_,_,_,_).
hasType(node_2, C):- sup_typechecks(_,_,C,_,_,_,_,_).
hasType(node_3, D):- sup_typechecks(_,_,_,D,_,_,_,_).
hasType(node_4, E):- sup_typechecks(_,_,_,_,E,_,_,_).
hasType(node_5, F):- sup_typechecks(_,_,_,_,_,F,_,_).
hasType(node_6, G):- sup_typechecks(_,_,_,_,_,_,G,_).
hasType(node_7, H):- sup_typechecks(_,_,_,_,_,_,_,H).

% How to express the app constraints?
% _______________________
% Func name | Type Scheme
% "add"     | For every [], [int, int, int]
% ...
% Node 3 (App expr expr):
% - head node 4 = node 5          --------------------> head E = F
% - tail node 4 = node 3          --------------------> tail E = D

% Node 4 (App var expr):
% - head node 6 = node 7          --------------------> head G = H
% - tail node 6 = node 4          --------------------> tail G = E 
% Node 6 (var):
% - node 6 = lookupFunc("add")    --------------------> G = [int, int, int]

