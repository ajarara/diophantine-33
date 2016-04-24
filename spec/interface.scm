;; TEST FILE

(load "../interface.scm")
(use-modules (ggspec lib))

(suite "verbose-attempt suite"
       (tests
	 (test "verbose-attempt spits out false when it should"
	       e
	       (assert-false (verbose-attempt `(5 25 -25) 6)))
	 (test "verbose-attempt spits out true when it should"
	       e
	       (assert-true (verbose-attempt `(13 12 1) 26)))
	 ))

