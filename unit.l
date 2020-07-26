# unit.l
#
# The MIT License (MIT)
#
# Copyright (c) 2020 Alexander Williams, Unscramble <license@unscramble.jp>

(load (pack (car (file)) "module.l"))
(load (pack (car (file)) "reporters/" (if (sys "TEST_REPORTER") @ "default") ".l"))

(setq
  *My_tests_are_order_dependent NIL
  *Results                      NIL )


# initialize
(seed (in "/dev/urandom" (rd 20)))


# internal
[de randomize (List)
  (if *My_tests_are_order_dependent
      List
      (by '((N) (rand 1 (size List))) sort List) ]

[de passed (Message)
  (queue-results T Message) ]

[de failed (Expected Result Message)
  (queue-results NIL Message Expected Result) ]

[de queue-results (Flag . @)
  (queue '*Results
    (pass list
          Flag
          (inc (length *Results)) ) )

  Flag ]


# reporter
[de colour (Colour)
  (err "/dev/null"
    (cond ((assoc (lowc Colour) *Colours) (call 'tput "setaf" (cdr @)))
          ((= (lowc Colour) "bold")       (call 'tput "bold"))
          (T                              (call 'tput "sgr0")) )
    NIL ]

[de plural? (String)
  (unless (= (length String) 1) "s") ]

(de get-results (Type)
  (filter '((N) (= Type (car N))) *Results) )


# public
[de execute @
  (mapcar eval (randomize (rest) ]

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
        (failed (text "@1 should be of type @2" Value Type) Result Message) ]

[de assert-throws (Type Error Result Message)
  (let Result (catch Type (eval Result) NIL)
    (if (= Error Result)
        (passed Message)
        (failed Error Result Message) ]

(de report ()
  (print-report) )
