% Let's make app rule work in prolog!

use_module(library(apply)). %to import include
:- discontiguous hasType/2.
:- discontiguous hasTypeScheme/3.
:- style_check(-singleton).

% rlwrap swipl emily_notes.pl
likesImprov(jane). % sanity check

% generate a type scheme if possible
hasTypeScheme(F, FORALL, T) :- generalize(F, FORALL, T).

% convert the type of a top level definition into a type scheme
generalize(FUNC_I, FORALL, T):- hasType(FUNC_I, T), include(var, T, FORALL).
generalize(FUNC_I, [], T):- hasType(FUNC_I, T), T\=[], T\=[H|T].
% trying these
% generalize(T, FORALL, G) :- G=T,include(var, T, FORALL).
% generalize(T, [], G) :- G=T.

% convert the type scheme of a top-level definition into a type
instantiates(Y,F) :- hasTypeScheme(F, FORALL, T), Y=T.
% we use copy_term/2 to instantiate the type scheme of a local definition (let bindings)

%trying these
% instantiate(T,I) :- generalize(T, FORALL, G), I=T.

% helper constraints
arrow([_,_]).
snd(A,B):-A=[H1,H2],B=H2.
fst(A,B):-A=[H1,H2],B=H1.

% built in functions (target language specific)
hasTypeScheme(add,[],[int, [int, int]]).
hasTypeScheme(and,[],[bool,[bool,bool]]).
hasTypeScheme(isBool,[X],[X,bool]).
hasTypeScheme(isNum,[X],[X,bool]).

% rest of knowledge base below is program specific...

% # let f = fun x -> x in (f true, f 'a');;
% - : bool * char = (true, 'a')
% test_let = let f = lam x .x in let y =  f true in f 4

% TRY TO INSTANTIATE WITHOUT MAKING LOCAL GLOBAL????
test_let_local_f_typechecks(A,B,C):-A=B, C=[A,B].

hasType(test_let_local_f,C):-test_let_local_f_typechecks(_,_,C).

% test_let_typechecks(X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22):-
% X11=X12, X10=X14, 
% hasType(test_let_local_f,B),X12=B,X11=X12,
% X15=X17, X14=X18,
% arrow(X19), fst(X19,X20), snd(X19,X17),
% arrow(X21), fst(X21,X22), snd(X21,X18),
% instantiates(X21,test_let_local_f), instantiates(X19,test_let_local_f),
% % X21=X11, X19=X11,
% X20=bool, X22=int, X16=X13.

test_let_typechecks(X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22):-
X11=X12, X10=X14, 
X12=[X16,X13],
X15=X17, X14=X18,
arrow(X19), fst(X19,X20), snd(X19,X17),
arrow(X21), fst(X21,X22), snd(X21,X18),
X20=bool, X22=int, X16=X13, copy_term(X11,X21), copy_term(X11,X19).

%making sure I understand how copy_term works...
test(X,Y,Z):-copy_term(X,Y), copy_term(X,Z).

%instantiates(X21,test_let_local_f), instantiates(X19,test_let_local_f),
%instantiates(X19,test_let_local_f)

% test_let_typechecks(X10,X11,X12,X13,X14,X15,X16,X17,X18,X19,X20,X21,X22,X11_I,X11_I2):-
% X11=X12, X10=X14, 
% X12=[X16,X13], X11_I=X12, X11_I2=X12,
% X15=X17, X14=X18,
% arrow(X19), fst(X19,X20), snd(X19,X17),
% arrow(X21), fst(X21,X22), snd(X21,X18),
% % instantiates(X21,test_let_local_f), instantiates(X19,test_let_local_f),
% % X21=X11, X19=X11,
% %instantiate(X11,I),instantiate(X11,I2),X11=I, X19=I2,
% % X21=X11_I, X19=X11_I2,
% % instantiate(X11_I,I),instantiate(X11_I2,I2),X19=I2,X11=I, 
% X20=bool, X22=int, X16=X13.

% hasType(node_17,X10) :- test_let_typechecks(X10,_,_,_,_,_,_,_,_,_,_,_,_,_,_).
% hasType(node_18,X11) :- test_let_typechecks(_,X11,_,_,_,_,_,_,_,_,_,_,_,_,_).
% hasType(node_19,X12) :- test_let_typechecks(_,_,X12,_,_,_,_,_,_,_,_,_,_,_,_).
% hasType(node_20,X13) :- test_let_typechecks(_,_,_,X13,_,_,_,_,_,_,_,_,_,_,_).
% hasType(node_21,X14) :- test_let_typechecks(_,_,_,_,X14,_,_,_,_,_,_,_,_,_,_).
% hasType(node_22,X15) :- test_let_typechecks(_,_,_,_,_,X15,_,_,_,_,_,_,_,_,_).
% hasType(node_23,X16) :- test_let_typechecks(_,_,_,_,_,_,X16,_,_,_,_,_,_,_,_).
% hasType(node_24,X17) :- test_let_typechecks(_,_,_,_,_,_,_,X17,_,_,_,_,_,_,_).
% hasType(node_25,X18) :- test_let_typechecks(_,_,_,_,_,_,_,_,X18,_,_,_,_,_,_).
% hasType(node_26,X19) :- test_let_typechecks(_,_,_,_,_,_,_,_,_,X19,_,_,_,_,_).
% hasType(node_27,X20) :- test_let_typechecks(_,_,_,_,_,_,_,_,_,_,X20,_,_,_,_).
% hasType(node_28,X21) :- test_let_typechecks(_,_,_,_,_,_,_,_,_,_,_,X21,_,_,_).
% hasType(node_29,X22) :- test_let_typechecks(_,_,_,_,_,_,_,_,_,_,_,_,X22,_,_).

% % test_let_typechecks(_,_,_,_,_,_,_,_,_,_,_,_,_).
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

% # (fun f -> (f true, f 'a')) (fun x -> x);;
% Error: This expression has type char but expected an expr of type bool
% test_lam f = let y = f true in f 4

% main = isNum(5) && isNum(false).
main_typechecks(X1,X2,X3,X4,X5,X6,X7,X8,X9):- 
 arrow(X2), snd(X2,X1), fst(X2,X3),
 arrow(X4), snd(X4,X2), fst(X4,X5),
 arrow(X8), snd(X8, X5), fst(X8,X9),
 arrow(X6), snd(X6,X3), fst(X6,X7), 
 instantiates(X4, and), instantiates(X8, isNum), instantiates(X13, isNum),
 X9=int,X7=bool.

hasType(node_8, X1) :- main_typechecks(X1,_,_,_,_,_,_,_,_).
hasType(node_9, X2) :- main_typechecks(_,X2,_,_,_,_,_,_,_).
hasType(node_10, X3) :- main_typechecks(_,_,X3,_,_,_,_,_,_).
hasType(node_11, X4) :- main_typechecks(_,_,_,X4,_,_,_,_,_).
hasType(node_12, X5) :- main_typechecks(_,_,_,_,X5,_,_,_,_).
hasType(node_13, X6) :- main_typechecks(_,_,_,_,_,X6,_,_,_).
hasType(node_14, X7) :- main_typechecks(_,_,_,_,_,_,X7,_,_).
hasType(node_15, X8) :- main_typechecks(_,_,_,_,_,_,_,X8,_).
hasType(node_16, X9) :- main_typechecks(_,_,_,_,_,_,_,_,X9).
       
% sup n = {
%     n + 5
% }
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


:- initialization forall(hasType(X,Y), (write(X),write(' has type '), writeln(Y))).