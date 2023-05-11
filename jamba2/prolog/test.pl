hasType(node_1, [A,B]).
hasType(node_2, C).
hasType(node_3, D).
hasType(node_4, E).
hasType(node_5, F).
hasType(node_6, G).
hasType(node_7, H).

sup_typechecks(A,B,C,D,E,F,G,H) :- [C, D] = [A, B], C = C, G = [int, int, int],  H = C, F = int, F = E, E = int.

hasType(node_1,[A,B]):- sup_typechecks(A,B,_,_,_,_,_,_).
hasType(node_2, C)   :- sup_typechecks(_,_,C,_,_,_,_,_).
hasType(node_3, D)   :- sup_typechecks(_,_,_,D,_,_,_,_).

hasType(node_4, E)   :- sup_typechecks(A,B,C,D,E,F,G,H).


% - head node 4 = node 5          --------------------> head E = F
% - tail node 4 = node 3          --------------------> tail E = D
% - head node 6 = node 7          --------------------> head G = H
% - tail node 6 = node 4          --------------------> tail G = E



:- initialization forall(hasType(X,Y), (writeln(X), writeln(Y))),halt.