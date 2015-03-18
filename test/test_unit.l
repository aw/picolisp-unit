(setq *My_tests_are_order_dependent NIL)

(prinl "^J  Testing Unit Testing^J")

[execute
  '(assert-equal 0 0 "This test should return zero")
  '(assert-equal 1 1 "This test should return one")
  '(assert-equal "three" "three" "This test should return \"three\"") ]
