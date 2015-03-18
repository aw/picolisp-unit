#!/usr/bin/env pil

(when symbols (symbols 'unit 'pico))

(load "unit.l")

(chdir "test/"
  (mapcar load (filter '((N) (sub? "test_" N)) (dir "."))) )
  # (mapcar load '("test_internal.l" "test_unit.l")) ) # same as above

(report)
