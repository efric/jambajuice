```
sup n = {
    n + 5 // where we assume + is a built in func instead of a primitive operator
}
```

![image info](./supv2.png)
```
Typechecking...
_______________________
Func name | Type Scheme
"add"     | For every [], [int, int, int]
_____________________
Node ID | Type Var(s)
1       | A -> B
2       | C
3       | D
4       | E
5       | F
6       | G
7       | H 

Traverse AST Tree...

______________________
Var name | Node ID
"n"      | 2

Node 1 (lam var expr):
- [node 2, node 3] = node 1     --------------------> [C, D] = [A, B]
- add "n" to var table          --------------------> n/a

Node 2 (var):
- node 2 = lookup("n")          --------------------> C = C

Node 3 (App expr expr):
- head node 4 = node 5          --------------------> head E = F
- tail node 4 = node 3          --------------------> tail E = D

Node 4 (App var expr):
- head node 6 = node 7          --------------------> head G = H
- tail node 6 = node 4          --------------------> tail G = E 
Node 6 (var):
- node 6 = lookupFunc("add")    --------------------> G = [int, int, int]

Node 7 (var):
- node 7 = lookup("n")          --------------------> H = C

Node 5 (lit):
- node 5  = int                 --------------------> F = int
```