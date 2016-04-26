;; TEST FILE

(use-modules (ggspec lib))

(suite "sanitize makes sure our user doesn't act sneaky"
       (tests
	 (test "sanitize exits with error on lists that aren't of length 3"
	       e
	       (assert-true
		 (error? (sanitize `(5 4 3 2 1 0)))))
	 (test "sanitize exits with error on non-integer input"
	       e
	       (assert-true
		 (error? (sanitize `(5 6 honeydew)))))
	 (test "sanitize exits with error with even first element"
	       e
	       (assert-true
		 (error? (sanitize `(10 1 1)))))
	 (test "sanitize exits with error when supplied some negative numbers"
	       e
	       (assert-true
		 (error? (sanitize `(9 1 -1)))))
	 (test "sanitize exits when supplied a valid list in the incorrect order"
	       e
	       (assert-true
		 (error? (sanitize `(101 50 70)))))
	 (test "sanitize exits with error when supplied a list with 2nd and 3rd numbers being diff parity"
	       e
	       (assert-true
		 (error? (sanitize `(9 3 2)))))
	 ))
