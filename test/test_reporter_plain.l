(setq *My_tests_are_order_dependent NIL)

[execute
  '(assert-t (fun? print-report) "Ensure (print-error) is a function") ]
