(prinl "^J  Testing Internal Functions^J")

(de test-dont-randomize ()
  (setq *My_tests_are_order_dependent T)
  (let Result (randomize '(1 2 3 4))
    (setq *My_tests_are_order_dependent NIL)
    Result ) )

[execute
  '(assert-equal "yellow "  (prog (colour "Yellow") (prin "yellow ")) "That text should be yellow")
  '(assert-equal "bold "    (prog (colour "bold") (prin "bold ")) "That text should be bold")
  '(assert-nil   (colour)   "This text should be back to its normal colour")
  '(assert-kind-of 'List (randomize '(1 2)) "Randomize the list")
  '(assert-equal '(1 2 3 4) (test-dont-randomize) "Don't randomize the list") ]
