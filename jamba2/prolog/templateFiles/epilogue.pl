% output results of typechecking!
:- initialization forall((hasType(X,Y),not(isTopLevelDef(X))), (write(X),write(' '), writeln(Y))),halt().