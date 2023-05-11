![jamba juice logo](https://github.com/efric/jambajuice/blob/main/jamba_juice_logo2.png)

To build and run jambajuice programs: 

```
cd jamba2
stack build
stack run <path/to/testfile/filename.jj>
```

To run the regression test suite against all jamba programs in the tests directory:

```
cd jamba2
./runtests.sh
```

Note that the test cases that are marked "failing" should indeed fail because the programs are intentionally not correct.
