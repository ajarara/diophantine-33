;; TEST FILE

(use-modules (ggspec lib))

(load "../modulo.scm")


(suite "numbers-less-than suite"
       (tests
	 (test "trivial case, where number = 1"
	       e
	       (assert-equal `(0)
			     (numbers-less-than 1)))
	 (test "non-trivial case, number = 8"
	       e
	       (assert-equal `(7 6 5 4 3 2 1 0)
			     (numbers-less-than 8)))
	 ))
