#!/usr/bin/env pil

(when symbols (symbols 'unit 'pico))

(load "unit.l")

(chdir "test/"
  (mapcar load '("test_internal.l" "test_unit.l" `(pack "test_reporter_" (if (sys "TEST_REPORTER") @ "default") ".l"))) )
  # (mapcar load (filter '((N) (sub? "test_" N)) (dir "."))) ) # almost same as above

(report)
