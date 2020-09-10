#!/usr/bin/env pil

(load "unit.l")

(chdir "test/"
  (mapcar load '("test_internal.l" "test_unit.l" `(pack "test_reporter_" (if (sys "TEST_REPORTER") @ "default") ".l"))) )

(report)
