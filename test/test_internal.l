(prinl "^J  Testing Unit Testing^J")

(de test-dont-randomize ()
  (setq *My_tests_are_order_dependent T)
  (let Result (randomize '(1 2 3 4))
    (setq *My_tests_are_order_dependent NIL)
    Result ) )

[execute
  (assert-kind-of 'List (randomize '(1 2)) "Randomize the list")
  (assert-equal '(1 2 3 4) (test-dont-randomize) "Don't randomize the list") ]
