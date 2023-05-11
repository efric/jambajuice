likesImprov(jane).
likesImprov(helen).
likesImprov(adele) :- X = 5, X = 6.
likesImprov(Y):- inATroupe(Y).
inATroupe(grace).
inATroupe(edward).
:- initialization writeln('START'),forall(likesImprov(X), (write('hey, '), writeln(X))), writeln('DONE').
