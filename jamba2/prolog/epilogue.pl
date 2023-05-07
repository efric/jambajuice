% output results of typechecking!
:- initialization forall(hasType(X,Y), (write(X),write(' has type '), writeln(Y))).