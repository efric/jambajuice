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