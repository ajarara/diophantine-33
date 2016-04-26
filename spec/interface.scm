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

(suite "verbose-lump-attempt suite"
       (tests
	 (test "verbose-lump-attempt fails when given the wrong input"
	       e
	       (assert-false (verbose-lump-attempt `(125 119 86))))
	 (test "verbose-lump-attempt passes when given a solution. if I could test this with integers, I wouldn't need to write any of this code, so I'm going to use a canned answer"
	       e
	       (assert-true (verbose-lump-attempt (list (expt 23 1/3) (expt 12 1/3) (expt 2 1/3)))))
	 ))

(suite "silent-attempt suite"
       (tests
	 (test "silent-attempt spits out false when it should"
	       e
	       (assert-false (silent-attempt `(5 25 -25))))
	 (test "silent-attempt spits out true when it should"
	       e
	       (assert-true (silent-attempt `(10 25 -2))))
	 ))

(suite "silent-lump-attempt suite"
       (tests
	 (test "silent-lump-attempt fails when given the wrong input"
	       e
	       (assert-false (silent-lump-attempt `(81 16 8))))
	 (test "silent-lump-attempt passes when given an answer in the same manner as verbose-lump-attempt"
	       e
	       (assert-true (silent-lump-attempt (list (expt 25 1/3) (expt 9 1/3) (expt 1 1/3)))))
	 ))



=======
	       (assert-false (verbose-attempt `(5 25 -25))))
	 (test "silent-attempt spits out true when it should"
	       e
	       (assert-true (verbose-attempt `(10 25 -2))))
	 ))

>>>>>>> c1d64062c0ddc6aef2eb3ee08c5c0ef4c5a0b247
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
			     (find-proc-from-signal `c)))
	 (test "a signal not defined in signal-proc-pairing yields false"
	       e
	       (assert-false (find-proc-from-signal `u)))
	 (test "`v yields verbose-try-until-input"
	       e
	       (assert-equal verbose-try-until-input
			     (find-proc-from-signal `v)))
	 ))

