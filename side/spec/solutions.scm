;; TEST FILE

(use-modules (ggspec lib))
(load "../solutions.scm")

(suite "find-all suite"
       (tests
	 (test "combination-modulo positive test"
	       e
	       (assert-true
		 (combination-modulo 
		   `(19 91)
		   55)))
	 (test "combination-modulo negative test"
	       e
	       (assert-true
		 (combination-modulo
		   `(20 20)
		   143)))
	 (test "combination-modulo excessively negative test"
	       e
	       (assert-true
		 (combination-modulo
		   `(30 60)
		   15)))
	 (test "find-all-values test"
	   e
	   (assert-equal
	     `((8 3)
	       (1 3)
	       (2 3))
	     (find-all-values
	       (lambda (somenum)
		 (= 3 (result somenum)))
	       `((8 3)
		 (7 1)
		 (6 2)
		 (1 3)
		 (2 3)
		 (5 6)
		 (9 0)))))
	 ))

(suite "modulus-matches suite"
       (tests
	 (test "trivial case where all results are 0"
	       e
	       (assert-equal
		 `((1 0)
		   (5 0)
		   (4 0)
		   (3 0)
		   (7 0)
		   (8 0)
		   (9 0))
		 (modulus-matches
		   50
		   `((1 0)
		     (2 2)
		     (5 0)
		     (4 0)
		     (3 0)
		     (6 15)
		     (7 0)
		     (9 9)
		     (8 0)
		     (9 0))
		   25)))
	 (test "testing negative case"
	       e
	       (assert-equal
		 `((8 1)
		   (9 1)
		   (10 101))
		 (modulus-matches
		   101
		   `((1 5)
		     (4 6)
		     (8 1)
		     (7 15)
		     (9 1)
		     (10 101))
		   100)))
	 ))
