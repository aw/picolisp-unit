# Explanation: Unit Testing framework for PicoLisp

This document provides a short walkthrough of the source code for the [PicoLisp-Unit](https://github.com/aw/picolisp-unit) testing framework.

I won't cover concepts which were discussed in previous source code explanations. You can read them here:

* [Nanomsg Explanation](https://github.com/aw/picolisp-nanomsg/blob/master/EXPLAIN.md)
* [JSON Explanation](https://github.com/aw/picolisp-json/blob/master/EXPLAIN.md)
* [HTTPS Explanation](https://github.com/aw/picolisp-https/blob/master/EXPLAIN.md)

This document is split into a few sections:

1. [Namespace leaky globals](#namespace-leaky-globals): Avoiding side-effects with Namespaces.
2. [Internal functions](#internal-functions): System calls and printing data to the terminal.
  * [System calls](#system-calls)
  * [Printing data](#printing-data)
3. [Public functions](#public-functions): Executing and asserting tests
  * [Executing a series of tests](#executing-tests)
  * [Asserting test results](#assertions)

Make sure you read the [README](README.md) to get an idea of what this library does.

# Namespace leaky globals

Previously, I thought namespaces would protect my variables from modifying the `'pico` namespace.

**I was wrong**.

Here's an example:

```lisp
: (setq *Myvar "I am a var")
: (symbols 'mytest 'pico)
-> pico
mytest: (prinl *Myvar)
-> "I am a var"

# so far so good

mytest: (setq *Myvar "You are a var")
mytest: (symbols 'pico)
: (prinl *Myvar)
-> "You are a var"
```

What? Yes that's right, the `*Myvar` which was originally in the `'pico` (default) namespace was modified from within the `'mytest` namespace. This is normal, but not expected, and quite dangerous actually.

### The fix

PicoLisp provides a nifty [local](http://software-lab.de/doc/refL.html#local) function for fixing that. I admit it's a bit of a pain and quite ugly, but it does the job. You can consider it similar to JavaScript's `var` expression.

Let's try again:

```lisp
: (setq *Myvar "I am a var")
: (symbols 'mytest 'pico)
-> pico
mytest: (local *Myvar)
mytest: (prinl *Myvar)
-> NIL

# that looks promising

mytest: (setq *Myvar "You are a var")
mytest: (symbols 'pico)
: (prinl *Myvar)
-> "I am a var"
```

This is much better, as we can now guarantee "global" functions and variables will not accidentally create side-effects by overwriting existing functions or variables.

This change has been applied everywhere now, and only public/exported functions can affect the global namespace.

# Internal functions

Here we discuss system calls and printing data to the screen with specific alignment.

### System calls

A cool unit-testing framework always displays colours. Just ask anyone from Node.js land.

To achieve this, we make use of an external [system call](http://software-lab.de/doc/refC.html#call), the *NIX `tput` command.

```lisp
[de colour (Colour)
  (cond ((assoc (lowc Colour) *Colours) (call 'tput "setaf" (cdr @)))
        ((= (lowc Colour) "bold")       (call 'tput "bold"))
        (T                              (call 'tput "sgr0")) )
  NIL ]
```

It's quite simple. The first condition checks if the `Colour` is part of the `*Colours` list. If yes, use `tput setaf` to set the terminal colour.

The second condition checks if the `Colour` is `bold`. If yes, use `tput bold` to set the text to bold.

The default catch-all (`T`) resets the terminal back to normal.

I tend to stay away from external system calls as we're not always sure about the environment. In our case though, colour terminal is not such a big deal, and the `(colour)` function will return `NIL` whether `tput` succedes or fails.

### Printing data

Printing data to the screen is simple in PicoLisp, until you realize there are at least 5 known functions to do that: [prin](http://software-lab.de/doc/refP.html#prin), [prinl](http://software-lab.de/doc/refP.html#prinl), [print](http://software-lab.de/doc/refP.html#print), [println](http://software-lab.de/doc/refP.html#println), and [printsp](http://software-lab.de/doc/refP.html#printsp). There's probably more.

In some cases, using a combination of multiple _printing_ functions can be helpful to achieve your designed results:

```lisp
[de print-expected (Result)
  (prin (align 8 " ")
        "Expected: "
        (colour "green") )

  (println Result)
  (colour) ]
```

This has 2 print statements, but it only prints one line. The first uses [align](http://software-lab.de/doc/refA.html#align) to align the column to 8 spaces. This is really useful to help keep displayed text aligned in columns. The second prints the result and appends a newline at the end.

An alternative would have been:

```lisp
[de print-expected (Result)
  (prin (align 8 " ")
        "Expected: "
        (colour "green")
        Result
        "^J" )
  (colour) ]
```

The `^J` character gets translated to a newline.

You'll notice we often call `(colour)` without any arguments, to end-up in the _catch-all_ mentioned earlier, which resets the terminal.

# Public functions

Public functions do all the work in this library. They execute a series of tests, and they assert results to see if your test should pass or fail.

I'll admit I was inspired mostly by Ruby's Minitest framework, which is quite huge compared to this one, but it pretty much does the same thing.

### Executing tests

All good unit tests should be designed to run as **units**. O'Rly? Yeah. This means the order of the tests shouldn't matter at all. The units should not carry state, and this framework tests for that as well.

The magic happens in a simple `(randomize)` function which takes the list of tests to execute, randomizes it, and then returns the list.

```lisp
[de randomize (List)
  (if *My_tests_are_order_dependent
      List
      (by '((N) (rand 1 (size List))) sort List) ]
```

It first checks if the `*My_tests_are_order_dependent` variable is `NIL` (if it isn't, don't randomize).

To randomize, it uses [by](http://software-lab.de/doc/refB.html#by), not to be confused with `(bye)` (that would be a major fail), and does stuff with it.

There's our _anonymous function_ again, used as the 1st argument to `(by)`, which is cons'd to the `List` (3rd argument), and then applied to the 2nd argument, which is the [sort](http://software-lab.de/doc/refS.html#sort) function.

The 1st argument (anonymous function) generates a random number between 1 and the size of the `List`.

It's crazy how that works. I'm not even sure how I came up with that.

```lisp
(de execute @
  (mapcar
    '((N) (prin (align 3 (inc '*Counter)) ") ") (eval N))
    (randomize (rest)) ]
```

Once our list of tests is randomized, we run it through our favourite [mapcar](http://software-lab.de/doc/refM.html#mapcar) function which prints the test's number, stored in `*Counter`, aligned to 3 columns, and then evaluates (runs) the test using the infamous [eval](http://software-lab.de/doc/refE.html#eval).

The `(align 3)` allows the test numbers to go from 1 to 999 without breaking the beautiful output. We can increase that when someone actually encounters that problem.

> **Note:* Technically, assertions don't catch errors, so if your assertion were to throw an unhandled error, then the entire test suite would fail and ugly things will happen. In fact, your terminals colours might not even get reset. That's a good thing. You should handle your errors.

### Assertions

PicoLisp natively supports assertions, and has a ton of predicates for testing and comparing values.

This library introduces simple wrappers around those predicates, which then call a `(passed)` or `(failed)` function with additional arguments.

```lisp
[de assert-equal (Expected Result Message)
  (if (= Expected Result)
      (passed Message)
      (failed Expected Result Message) ]
```

This one is quite simple, all it does is check if `Expected` is equal to `Result`.

The [other assertions](https://github.com/aw/picolisp-unit/blob/master/README.md#assertions-table) are quite similar and seem to cover most test cases. I've considered adding opposite tests such as `refute`, but I've rarely found a need for them as there are alternate approaches.

# The end

That's pretty much all I have to explain about the Unit Testing framework for PicoLisp. I'm very open to providing more details about functionality I've skipped, so just file an [issue](https://github.com/aw/picolisp-unit/issues/new) and I'll do my best.

# License

This work is licensed under a [Creative Commons Attribution-ShareAlike 4.0 International License](http://creativecommons.org/licenses/by-sa/4.0/).

Copyright (c) 2015 Alexander Williams, Unscramble <license@unscramble.jp>
