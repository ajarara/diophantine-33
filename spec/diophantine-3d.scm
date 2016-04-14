;; TEST FILE
(load "../utility.scm")
(load "../diophantine-3d.scm")
(use-modules (ggspec lib))

(suite "Auxiliary functions of dio-3d work as expected"
       (tests
        (test "index returns values consistent with description (abbrev rvcwd)"
              e
              (let ((input-output-pairing `((((2 1 1)) 60)
                                           (((3 1 1)) 120)
                                           (((1 1 1)) 30)
                                           (((1 0 1)) 10))))
                (assert-false (memq #f (mapf index input-output-pairing)))))
        (test "pivot-list-of-index is the inverse of the proc index"
              e
              ;; the inputs must be in list form, as mapf expects a list of arguments
              (let ((input-output-pairing `(((60) (2 1 1))
                                            ((120) (3 1 1))
                                            ((45) (0 2 1))
                                            ((10) (1 0 1))
                                            ((337500) (2 3 5)))))
                (assert-false (memq #f (mapf pivot-list-of-index input-output-pairing)))))
        (test "diophantine-calculate rvcwd"
              e
              (let ((input-output-pairing `(((2 1 1) 10)
                                            ((3 2 1) 36)
                                            ((1 1 1) 3)
                                            ((4 3 1) 92))))
                (assert-false (memq #f (mapf dioph-calc input-output-pairing)))))
        ))

(suite "gen-increment-3-pivot-list works as expected"
       (tests
        (test "fringe cases increment the pivot"
              e
              (assert-equal (list 5 0 0)
                            (gen-increment-3-pivot-list `(4 4 4))))
        (test "gen-increment-3-pivot-list increments correctly under non-fringe-cases"
              e
              (assert-equal (list 7 7 5)
                            (gen-increment-3-pivot-list `(7 6 5))))
        ))
(suite "2+ adds two to a number and returns it"
       (tests
        (test "(2+ 0) => 2"
              e
              (assert-equal 2
                            (2+ 0)))
        (test "(2+ 5) => 7"
              e
              (assert-equal 7
                            (2+ 5)))
        (test "(2+ -7) => -5"
              e
              (assert-equal -5
                            (2+ -7)))
        ))

(suite "increment-3-pivot-list optimized works as expected"
       (tests
        (test "inc-3-pivot-list exits with error on even pivot"
              e
              (assert-true (error? (increment-3-pivot-list `(2 0 0)))))
        (test "inc-3-pivot-list jumps to next pivot on equality"
              e
              (assert-equal (list 7 2 2)
                            (increment-3-pivot-list `(5 5 5))))
        (test "inc-3-pivot-list increments correctly under non-fringe cases"
              e
              (assert-equal (list 9 3 1)
                            (increment-3-pivot-list `(9 1 1))))
        (test "inc-3-pivot-list moves to the odd section of iteration"
              e
              (assert-equal (list 5 1 1)
                            (increment-3-pivot-list `(5 4 4))))
        (test "inc-3-pivot-list handles intra-pivot inc correctly"
              e
              (assert-equal (list 3 3 3)
                            (increment-3-pivot-list `(3 3 1))))
        (test "inc-3-pivot-list handles intra-pivot inc correctly"
              e
              (assert-equal (list 5 3 3)
                            (increment-3-pivot-list `(5 3 1))))
))


(suite "incrementer takes signals and behaves expectedly"
       (tests
        (test "incrementer is instantiated with an index, given the signal `current returns the list it is at"
              e
              (let ((our-index (index `(5 1 2))))
                (assert-equal (list 5 1 2)
                              ((make-incrementer increment-3-pivot-list our-index) `current))))
        (test "incrementer given signal `next invokes inc-3-pivot-list and returns the list given"
              e
              (let ((our-index (index `(5 3 1))))
                (assert-equal (list 5 3 3)
                              ((make-incrementer increment-3-pivot-list our-index) `next))))
        (test "incrementer pops out its index"
              e
              (assert-equal 1620000
                            ((make-incrementer increment-3-pivot-list 1620000) `index)))
        (test "incrementer returns the function it is generated with"
              e
              (assert-equal increment-3-pivot-list
                            ((make-incrementer increment-3-pivot-list 1200) `inc-get)))
))

(suite "generate-from-seed takes a 3-list and a list of 3-lists and returns a list of results from the multiplication."
       (tests
	 (test "giving a null list as the list of lists returns the null list"
	       e
	       (assert-true (null? (generate-from-seed `(5 4 3) `()))))
	 (test "trivial case of only one list 0's in the LoL"
	       e
	       (assert-equal `((0 0 0))
			     (generate-from-seed `(5 4 3) `((0 0 0)))))
	 (test "using `(8 9 10) on the distinct map gets us what we're looking for"
	       e
	       (assert-equal `((8 -9 -10)
			       (-8 9 -10)
			       (-8 -9 10)
			       (8 9 -10)
			       (8 -9 10)
			       (-8 9 10))
			     (generate-from-seed `(8 9 10) distinct-map)))
	 (test "using `(8 9 10) on the 1,2-dup-map gets us what we're looking for (note that this wouldn't happen in 'production' but this is good for testing, I think."
	       e
	       (assert-equal `((8 9 -10)
			       (-8 -9 10))
			     (generate-from-seed `(8 9 10) 1,2-dup-map)))

	 ))
(suite "populate takes a 3-list and returns a list of all types of valid tries"
       (tests
	 (test "a distinct list gives us nothing"
	       e
	       (assert-true #t))
	 ))
