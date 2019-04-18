# picolisp-unit Makefile

.PHONY: all

all: check

check:
		@for i in plain default; do TEST_REPORTER="$$i" ./test.l; done
