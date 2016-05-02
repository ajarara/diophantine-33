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

(suite "max-of-em-pairs test suite"
       (tests
	 (test "listing of 1 pair gets the cadr of that pair"
	       e
	       (assert-equal 5
			     (max-of-em-pairs `((1 5)))))
	 (test "listing of 2 pairs"
	       e
	       (assert-equal 10
			     (max-of-em-pairs `((1 2) (0 10)))))
	 ))

(suite "curry suite"
       (tests
	 (test "residue-builder built off an expt of 0 returns the list of 1s"
	       e
	       (assert-equal (make-list 5 1)
			     (map
			       (residue-builder 0 25)
			       `(1 2 3 4 5))
			     ))
	 (test "residue-builder works in the semi-trivial cases"
	       e
	       (assert-equal `(0 1 2)
			     (map
			       (residue-builder 1 3)
			       `(0 1 2)
			       )
			     ))
	 (test "residue-builder works with harder cases"
	       e
	       (assert-equal `(1 8 27)
			     (map
			       (residue-builder 3 33)
			       `(1 2 3))
			     ))
	 ))

(suite "em-proc-list suite"
       (tests
	 (test "given a list of ((1 100)), return the proc that gives us the identity function, essentially"
	       e
	       ;; jeeze these are getting complicated
	       (assert-equal (numbers-less-than 99)
			     (map
			       (car (em-proc-list `((1 100))))
			       (numbers-less-than 99))
			     ))
	 (test "em-proc-list builds residues as expected"
	       e
	       (assert-equal
		 (let
		   ; this let is so that I don't rebuild these procedures each time.
		   ((residue-1-5
		      (residue-builder 1 5))
		    (residue-10-103
		      (residue-builder 10 103))
		    (residue-89-95
		      (residue-builder 89 95)))
		   (map
		     (lambda (number)
		       (list
			 (residue-1-5 number)
			 (residue-10-103 number)
			 (residue-89-95 number)))
		     (numbers-less-than 104)))
		 (map
		   ; feed each procedure in this list the number given from the first map
		   (lambda (number)
		     (map
		       (lambda (proc)
			 (proc number))
		       (em-proc-list
			 `((1 5)
			   (10 103)
			   (89 95)))))
		   (numbers-less-than 104))
		 ))
	 ))



