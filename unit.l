(when symbols (symbols 'unit 'pico))

[setq MODULE_INFO
  '(("name"       "unit")
    ("version"    "0.1.1")
    ("summary"    "Unit Testing framework for PicoLisp")
    ("source"     "https://github.com/aw/picolisp-unit.git")
    ("author"     "Alexander Williams")
    ("license"    "MIT")
    ("copyright"  "(c) 2015 Alexander Williams, Unscramble <license@unscramble.jp>") ]

(setq
  *Colours  '(("red"    . 1)
              ("green"  . 2)
              ("yellow" . 3)
              ("blue"   . 4) )

  *My_tests_are_order_dependent NIL
  *Passed                       0
  *Failed                       NIL
  *Counter                      0 )


# initialize
(seed (in "/dev/urandom" (rd 20)))


# internal
[de colour (Colour)
  (cond ((assoc (lowc Colour) *Colours) (call 'tput "setaf" (cdr @)))
        ((= (lowc Colour) "bold")       (call 'tput "bold"))
        (T                              (call 'tput "sgr0")) )
  NIL ]

[de randomize (List)
  (if *My_tests_are_order_dependent
      List
      (by '((N) (rand 1 (size List))) sort List) ]

[de passed @
  (prinl  (colour "green")
          (char (hex "2713"))
          (align 2 " ")
          (colour)
          (next) )

  (inc '*Passed) ]

[de failed (Expected Result Message)
  (prinl  (colour "red")
          (char (hex "2715"))
          (align 2 " ")
          Message
          (colour) )

  (queue '*Failed (list *Counter Expected Result Message)) ]


[de print-report ()
  (prinl  (colour "bold")
          "----^J"
          (colour "green")
          *Passed
          " test" (when (not (= *Passed 1)) "s")
          " passed, "
          (colour "red")
          (length *Failed)
          " test" (when (not (= (length *Failed) 1)) "s")
          " failed"
          (colour) )

  (report-failed)
  (exit-gracefully) ]

(de report-failed ()
  (when *Failed
    (prinl "^J" (colour "red") "^J  Failed test" (when (not (= (length *Failed) 1)) "s") ": ")

    (mapcar
      '((N) (print-error (car N) (cdddr N))
            (print-expected (cadr N))
            (print-got (caddr N)) )
      *Failed )

    (colour) ]

[de print-error (Number Result)
  (prinl  (colour "red")
          "^J"
          (align 4 " - ")
          Number
          ")  "
          Result
          (colour) ]

[de print-expected (Result)
  (prinl  (align 8 " ")
          "Expected: "
          (colour "green")
          Result
          (colour) ]

[de print-got (Result)
  (prinl  (align 8 " ")
          (align 10 " Actual: ")
          (colour "red")
          Result
          (colour) ]

[de exit-gracefully ()
  (if (gt0 (length *Failed))
      (bye 1)
      (bye) ]


# public
(de execute @
  (mapcar
    '((N) (prin (align 3 (inc '*Counter)) ") ") (eval N))
    (randomize (rest)) ]

[de assert-equal (Expected Result Message)
  (if (= Expected Result)
      (passed Message)
      (failed Expected Result Message) ]

(de report ()
  (print-report) )
