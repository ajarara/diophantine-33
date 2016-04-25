;; TEST FILE

(load "../interface.scm")
(use-modules (ggspec lib))

(suite "verbose-attempt suite"
       (tests
	 (test "verbose-attempt spits out false when it should"
	       e
	       (assert-false (verbose-attempt `(10 -20 3))))
	 (test "verbose-attempt spits out true when it should"
	       e
	       (assert-true (verbose-attempt `(5 12 16))))
	 ))

(suite "silent-attempt suite"
       (tests
	 (test "silent-attempt spits out false when it should"
	       e
	       (assert-false (verbose-attempt `(5 25 -25))))
	 (test "silent-attempt spits out true when it should"
	       e
	       (assert-true (verbose-attempt `(10 25 -2))))
	 ))

(suite "victorystring testing suite"
       (tests
	 (test "If this fails, solution might've been changed."
	       e
	       (assert-equal "Hooray! (5 5 5) yields 33! Back to work.\n"
			     (victorystring `(5 5 5))))
	 ))

(suite "find-proc-from-signal gets out the correct procedure given a signal"
       (tests
	 (test "`c yields the one-off-loop"
	       e
	       (assert-equal one-off-loop
			     (cadr (find-proc-from-signal `c))))
	 (test "a signal not defined in signal-proc-pairing yields false"
	       e
	       (assert-false (find-proc-from-signal `u)))
	 (test "`v yields verbose-try-until-input"
	       e
	       (assert-equal verbose-try-until-input
			     (cadr (find-proc-from-signal `v))))
	 ))

