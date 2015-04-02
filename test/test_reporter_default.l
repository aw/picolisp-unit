(setq *My_tests_are_order_dependent NIL)

[execute
  '(assert-nil   (prog (colour "yellow") (colour)) "Set colour to yellow")
  '(assert-nil   (colour)   "Reset colour") ]
