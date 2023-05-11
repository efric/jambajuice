# prolog-shenanigans
## prolog how-to

**Setup**

Install

```
`$ sudo apt install swi-prolog-core`
```

Launch REPL

```shell
$ swipl
```

Compile the file

```shell
$ swipl

-? ['filename.pl'].
```



**Consult the knowledge base of the file with queries...**

```prolog
-? likesImprov(X).
```

Getting stuck? Try using the debugger!

```prolog
-? trace.
```

To turn off the debugger, do

```prolog
-? notrace.
```



***Want use of the up arrow to see your history of commands while using swipl?***

Install rlwrap from: https://github.com/hanslub42/rlwrap

Then launch the REPL with

```shell
$ rlwrap swipl
```



## Experimenting with prolog + typechecking

Hindley-Milner Type Checking Explanation: https://course.ccs.neu.edu/cs4410sp19/lec_type-inference_notes.html

- [Example 1.1](hmex1.1.pl)

- [Example 1.2](hmex1.2.pl)

  
