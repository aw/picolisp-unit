# Changelog

## 3.1.0 (2020-09-10)

  * Remove colour of output for 'passed' tests in default reporter, 10x speed increase when tests pass
  * Update supported PicoLisp versions to 19.6, 19.12, 20.6, pil21

## 3.0.0 (2019-04-19)

  * Add Makefile for testing the library
  * Update supported PicoLisp version to 18.12
  * **Breaking change:** remove all support for PicoLisp namespaces

## 2.1.0 (2017-03-23)

  * Restore PicoLisp namespaces for backwards compatibility. Disable with PIL_NAMESPACES=false

## 2.0.0 (2017-03-09)

  * Remove the use of PicoLisp namespaces (functionally equivalent to 1.0.0)

## 1.0.0 (2015-06-09)

  * Production release

## 0.6.2 (2015-05-15)

  * Use 'unless' instead of 'when not ='
  * Don't rely on scoped variables
  * Remove unused arguments in 'print-failed'

## 0.6.1 (2015-04-08)

  * Suppress errors if the 'tput' command doesn't exist

## 0.6.0 (2015-04-05)

  * Move test reporters to their own directory
  * Add 'plain' reporter with tests
  * Get rid of *Passed, *Failed, *Counter global variables
  * Lispify some functions
  * Update .travis.yml
  * Update README.md and EXPLAIN.md

## 0.5.2 (2015-03-29)

  * Fix small potential bug in (passed)

## 0.5.1 (2015-03-29)

  * Small refactor: replace anonymous function with simpler eval
  * Update EXPLAIN.md

## 0.5.0 (2015-03-29)

  * Assertions now return T or NIL, for passed or failed tests
  * Nothing is printed to the display if (report) is not called
  * All test results are accumulated in *Results global variable

## 0.4.1 (2015-03-28)

 * Documentation update

## 0.4.0 (2015-03-24)

 * Avoid leaking global variables such as MODULE_INFO, *Colours, *Counter..

## 0.3.1 (2015-03-19)

 * Move MODULE_INFO into module.l

## 0.3.0 (2015-03-19)

 * Add new assertion: assert-throws
 * Minor refactor with (plural?)
 * Stylistic changes to MODULE_INFO (credit Alexander Burger)
 * Update README.md

## 0.2.1 (2015-03-18)

 * Version bump, includes README.md and working .travis.yml

## 0.2.0 (2015-03-18)

  * Add new assertions: nil, t, includes, kind-of
  * Add .travis.yml for automated tests
  * Add a few tests for internal functions
  * Add tests for assertions (yes, we are testing the tests)

## 0.1.2 (2015-03-18)

  * Ensure expected/actual results are displayed correctly

## 0.1.1 (2015-03-18)

  * Adjust alignment of unit test numbers

## 0.1.0 (2015-03-18)

  * First release - Unit Testing framework for PicoLisp
