# Unit Testing framework for PicoLisp

[![GitHub release](https://img.shields.io/github/release/aw/picolisp-unit.svg)](https://github.com/aw/picolisp-unit) ![Build status](https://github.com/aw/picolisp-unit/workflows/CI/badge.svg?branch=master)

This library can be used for Unit Testing your [PicoLisp](http://picolisp.com/) code.

![picolisp-unit](https://cloud.githubusercontent.com/assets/153401/6712097/b1b77e14-cd82-11e4-9603-cae666b8655d.png)

Please read [EXPLAIN.md](EXPLAIN.md) to learn more about PicoLisp and this Unit Testing framework.

  1. [Requirements](#requirements)
  2. [Getting Started](#getting-started)
  3. [Usage](#usage)
  4. [Examples](#examples)
  5. [Testing](#testing)
  6. [Reporters](#reporters)
  7. [Alternatives](#alternatives)
  8. [Contributing](#contributing)
  9. [Changelog](#changelog)
  10. [License](#license)

# Requirements

  * PicoLisp 32-bit or 64-bit `v3.1.9+`, or `pil21`
  * Tested up to PicoLisp `v20.6.29`, [see test runs](https://github.com/aw/picolisp-unit/commit/1a455ba10058dffacfb3d4ef930c89ee82a57a83/checks)

# Getting Started

This is a pure PicoLisp library with no external dependencies. You can either copy `unit.l` into your project(s), or add it as a git submodule to stay up-to-date (recommended).

### Add submodule to your project

  1. git submodule add https://github.com/aw/picolisp-unit vendor/picolisp-unit
  2. Include `unit.l` in your test file
  3. See the [examples](#examples) below

# Usage

Here are some guidelines on how to use `unit.l`, but you're free to poke around the code and use it as you wish.

There exists a few public functions: `(execute)`, `(report)`, and a bunch of `(assert-X)` where X is a type of assertion.

  * **(execute arg1 ..)** Executes arg1 to argN tests
    - `arg1` _Quoted List_: a list of assertions, example `'(assert-nil NIL "I AM NIL")`
  * **(report)** Prints a report of failed tests, and exits with 1 if there is a failure
  * **(assert-X)** Various assertions for testing

### Assertions table

Only a few assertions exist for the moment; more [can](#contributing)/will be added.

| Assertion | Arguments | Example |
| :----------| :---------: | :-------: |
| (assert-equal) | Expected Result Message | `(assert-equal 0 0 "It must be zero")` |
| (assert-nil) | Result Message | `(assert-nil NIL "It must be NIL")` |
| (assert-t) | Result Message | `(assert-t T "I pity the fool!")` |
| (assert-includes) | String List Message | `(assert-includes "abc" '("def") "It includes abc")` |
| (assert-kind-of) | Type Value Message | `(assert-kind-of 'Number 42 "The answer..")` |
| (assert-throws) | Type Error 'Result Message | `(assert-throws 'Err "fail" '(throw 'Err "fail") "Throws a fail")` |

### (assert-kind-of) types

There are 5 types currently defined:

* **'Flag** Uses [flg?](http://software-lab.de/doc/refF.html#flg?) to test if the value is `T` or `NIL`.
* **'String** Uses [str?](http://software-lab.de/doc/refS.html#str?) to test if the value is a string.
* **'Number** Uses [num?](http://software-lab.de/doc/refN.html#num?) to test if a value is a number.
* **'List** Uses [lst?](http://software-lab.de/doc/refL.html#lst?) to test if a value is a list.
* **'Atom** Uses [atom](http://software-lab.de/doc/refA.html#atom) to test if a value is an atom.

>> **Warning:** `NIL` is also list, but will be asserted as a `'Flag` when using `(assert-kind-of)`. Use `(assert-nil)` if you specifically want to know if the value is `NIL`.

### Notes

  * Use `(execute)` at the start of your tests (see [examples](#examples))
  * Unit Tests are run in **RANDOM** order.
  * If your tests are **order dependent**, then you can: `(setq *My_tests_are_order_dependent T)`
  * Colours and bold text are only displayed if your terminal supports it, and if your system has the `tput` command.
  * The `(assert-includes)` function uses [sub?](http://software-lab.de/doc/refS.html#sub?) to find a substring in a string or list.
  * The `(assert-throws)` function requires the `(throw)` to be [quoted](http://software-lab.de/doc/refQ.html#quote).
  * Assertions return `T` if the test passed, and `NIL` if the test failed
  * Results of all tests are accumulated in the `*Results` global variable

### Test results

The `*Results` global variable is a list of lists, which will have one of two formats:

    ((NIL 1 "should be NIL" NIL T) (T 2 "should be NIL"))

  1. `NIL` or `T` in the `(car)` if the test failed or passed, respectively
  2. Number indicating the counter for the test
  3. Message of the test
  4. Expected result (only when the test failed)
  5. Actual result (only when the test failed)

# Examples

It is recommended to create a "test runner" similar to what's found in [test.l](https://github.com/aw/picolisp-unit/blob/master/test.l).

Tests should be placed in a `test/` directory, and the test files should be prefixed with `test_`.

### A simple unit test

```lisp
pil +

(load "unit.l")

(setq *My_tests_are_order_dependent NIL)

[execute
  '(assert-equal 0 0 "(assert-equal) should assert equal values")
  '(assert-nil   NIL "(assert-nil) should assert NIL")
  '(assert-t     T   "(assert-t) should assert T")
  '(assert-includes "abc" '("xyzabcdef")  "(assert-includes) should assert includes")
  '(assert-kind-of  'Flag NIL  "(assert-kind-of) should assert a Flag (NIL)")
  '(assert-kind-of  'Flag T    "(assert-kind-of) should assert a Flag (T)")
  '(assert-kind-of  'String "picolisp"  "(assert-kind-of) should assert a String")
  '(assert-kind-of  'Number 42  "(assert-kind-of) should assert a Number")
  '(assert-kind-of  'List (1 2 3 4)  "(assert-kind-of) should assert a List")
  '(assert-kind-of  'Atom 'atom  "(assert-kind-of) should assert a Atom") ]

# output

  1) ✓  (assert-kind-of) should assert a List
  2) ✓  (assert-kind-of) should assert a Flag (T)
  3) ✓  (assert-includes) should assert includes
  4) ✓  (assert-t) should assert T
  5) ✓  (assert-kind-of) should assert a Number
  6) ✓  (assert-nil) should assert NIL
  7) ✓  (assert-equal) should assert equal values
  8) ✓  (assert-kind-of) should assert a Flag (NIL)
  9) ✓  (assert-kind-of) should assert a Atom
 10) ✓  (assert-kind-of) should assert a String

-> (T T T T T T T T T T)
```

### When tests fail

```lisp
pil +

(load "unit.l")

[execute
  '(assert-equal 0 1 "(assert-equal) should assert equal values")
  '(assert-nil   NIL "(assert-nil) should assert NIL")
  '(assert-t     NIL   "(assert-t) should assert T")
  '(assert-includes "abc" '("hello")  "(assert-includes) should assert includes")
  '(assert-kind-of  'Flag "abc"  "(assert-kind-of) should assert a Flag (NIL)") ]

(report)

# output

-> (T NIL NIL NIL NIL)

  1) ✓  (assert-nil) should assert NIL
  2) ✕  (assert-kind-of) should assert a Flag (NIL)
  3) ✕  (assert-includes) should assert includes
  4) ✕  (assert-t) should assert T
  5) ✕  (assert-equal) should assert equal values

-> ----
1 test passed, 4 tests failed

  Failed tests: 

  - 2)  (assert-kind-of) should assert a Flag (NIL)
        Expected: "abc should be of type Flag"
          Actual: String

  - 3)  (assert-includes) should assert includes
        Expected: "abc in hello"
          Actual: "abc"

  - 4)  (assert-t) should assert T
        Expected: T
          Actual: NIL

  - 5)  (assert-equal) should assert equal values
        Expected: 0
          Actual: 1
```

# Testing

This testing library has its own set of tests (hehe). You can use those as examples as well. To run them type:

    ./test.l

or

    make check

# Reporters

If you don't call `(report)`, the test results will not be printed to the screen.

This allows you to create your own custom reporter and use it to output the test results however you like.

There are two existing reporters, to use one set the `TEST_REPORTER` environment variable:

    TEST_REPORTER=plain ./test.l

or

    TEST_REPORTER=default ./test.l

### Creating a custom reporter

Your custom reporter only needs to implement the `(print-report)` function. This gets called by the public `(report)` function.

Add a file to the `reporters/` directory (ex: `custom.l`). The filename (without `.l` extension) will be the name of your reporter.

You can use any of the following helper functions/variables:

  * `(colour)`
  * `(plural?)`
  * `(get-results)`
  * `*Results` global variable

> **Note:** Avoid using the internal functions as they might change without notice.

  * All test results can be obtained with the `*Results` global variable.
  * All _failed_ results can be obtained with `(get-results NIL)`.
  * All _passed_ results can be obtained with `(get-results T)`.

Please make a pull-request if you would like your custom reporter to be added to this library.

# Alternatives

The alternative approaches to testing in PicoLisp involve the use of [test](http://software-lab.de/doc/refT.html#test) and [assert](http://software-lab.de/doc/refA.html#assert).

# Contributing

If you find any bugs or issues, please [create an issue](https://github.com/aw/picolisp-unit/issues/new).

If you want to improve this library, please make a pull-request.

### Contributors

* @cryptorick [Rick Hanson](https://github.com/cryptorick)

# Changelog

* [Changelog](CHANGELOG.md)

# License

[MIT License](LICENSE)

Copyright (c) 2015-2020 Alexander Williams, Unscramble <license@unscramble.jp>
