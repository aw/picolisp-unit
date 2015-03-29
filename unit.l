# unit.l
#
# The MIT License (MIT)
#
# Copyright (c) 2015 Alexander Williams, Unscramble <license@unscramble.jp>

(when symbols (symbols 'unit 'pico))

(local MODULE_INFO *Colours *My_tests_are_order_dependent *Passed *Failed *Counter *Results)
(local colour randomize plural? passed failed print-report report-failed print-error print-expected print-got exit-gracefully)
(local print-passed print-failed)

(load (pack (car (file)) "module.l"))

(setq
  *Colours  '(("red"    . 1)
              ("green"  . 2)
              ("yellow" . 3)
              ("blue"   . 4) )

  *My_tests_are_order_dependent NIL
  *Passed                       0
  *Failed                       NIL
  *Counter                      0
  *Results                      NIL )


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

[de plural? (String)
  (when (not (= (length String) 1)) "s") ]

[de print-passed @
  (prinl  (colour "green")
          (char (hex "2713"))
          (align 2 " ")
          (colour)
          (next) ) ]

[de print-failed (Message Expected Result)
  (prinl  (colour "red")
          (char (hex "2715"))
          (align 2 " ")
          Message
          (colour) ]

[de passed @
  (inc '*Passed)
  (inc '*Counter)
  (queue '*Results (list T *Counter Message))
  T ]

[de failed (Expected Result Message)
  (inc '*Counter)
  (queue '*Failed  (list *Counter Expected Result Message))
  (queue '*Results (list NIL *Counter Message Expected Result))
  NIL ]

[de print-report ()
  (mapcar '((N) (prin (align 3 (cadr N)) ") ")
                (if (=T (car N))
                    (print-passed (cddr N))
                    (print-failed (cddr N)) ) )
          *Results )

  (prinl  (colour "bold")
          "----^J"
          (colour "green")
          *Passed
          " test" (plural? *Passed)
          " passed, "
          (colour "red")
          (length *Failed)
          " test" (plural? *Failed)
          " failed"
          (colour) )

  (report-failed)
  (exit-gracefully) ]

(de report-failed ()
  (when *Failed
    (prinl "^J" (colour "red") "^J  Failed test" (plural? *Failed) ": ")

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
  (prin (align 8 " ")
        "Expected: "
        (colour "green") )

  (println Result)
  (colour) ]

[de print-got (Result)
  (prin (align 8 " ")
        (align 10 " Actual: ")
        (colour "red") )

  (println Result)
  (colour) ]

[de exit-gracefully ()
  (if (gt0 (length *Failed))
      (bye 1)
      (bye) ]


# public
(de execute @
  (mapcar
    '((N) (eval N))
    (randomize (rest)) ]

[de assert-equal (Expected Result Message)
  (if (= Expected Result)
      (passed Message)
      (failed Expected Result Message) ]

[de assert-nil (Result Message)
  (if Result
      (failed NIL Result Message)
      (passed Message) ]

[de assert-t (Result Message)
  (if (=T Result)
      (passed Message)
      (failed T Result Message) ]

[de assert-includes (String List Message)
  (if (sub? String List)
      (passed Message)
      (failed (pack String " in " List) String Message) ]

[de assert-kind-of (Type Value Message)
  (let Result
    (cond ((flg? Value) 'Flag)
          ((str? Value) 'String)
          ((num? Value) 'Number)
          ((lst? Value) 'List)
          ((atom Value) 'Atom) )

    (if (= Type Result)
        (passed Message)
        (failed (pack Value " should be of type " Type) Result Message) ]

[de assert-throws (Type Error Result Message)
  (let Result (catch Type (eval Result) NIL)
    (if (= Error Result)
        (passed Message)
        (failed Error Result Message) ]

(de report ()
  (print-report) )
