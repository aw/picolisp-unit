(setq *My_tests_are_order_dependent NIL)

[execute
  (assert-equal 0 0 "(assert-equal) should assert equal values")
  (assert-nil   NIL "(assert-nil) should assert NIL")
  (assert-t     T   "(assert-t) should assert T")
  (assert-includes "abc" '("xyzabcdef")  "(assert-includes) should assert includes")
  (assert-kind-of  'Flag NIL  "(assert-kind-of) should assert a Flag (NIL)")
  (assert-kind-of  'Flag T    "(assert-kind-of) should assert a Flag (T)")
  (assert-kind-of  'String "picolisp"  "(assert-kind-of) should assert a String")
  (assert-kind-of  'Number 42  "(assert-kind-of) should assert a Number")
  (assert-kind-of  'List (1 2 3 4)  "(assert-kind-of) should assert a List")
  (assert-kind-of  'Atom 'atom  "(assert-kind-of) should assert a Atom")
  (assert-throws   'InternalError '(UnitTestError . "Unit test throws an error") '(throw 'InternalError (cons 'UnitTestError "Unit test throws an error")) "(assert-throws) should assert a thrown error") ]
