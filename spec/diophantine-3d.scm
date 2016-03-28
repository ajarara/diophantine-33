;; TEST FILE
(load "../utility.scm")
(load "../diophantine-3d.scm")
(use-modules (ggspec lib))

(suite "Auxiliary functions of dio-3d work as expected"
       (tests
        (test "index returns values consistent with description (abbrev rvcwd)"
              e
              (let ((input-output-pairing `(((2 1 1) 60)
                                           ((3 1 1) 120)
                                           ((1 1 1) 30)
                                           ((1 0 1) 10))))
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
        (test "unopt-inc-3-pivot-list rvcwd"
              e
              (let ((input-output-pairing `(((2 1 1) (2 1 2))
                                            ((1 0 0) (1 0 1))
                                            ((0 0 0) (1 0 0))
                                            ((2 2 2) (3 0 0))
                                            ((3 0 3) (3 1 1)))))
                (assert-false (memq #f (mapf unopt-increment-3-pivot-list input-output-pairing)))))
        (test "diophantine-calculate rvcwd"
              e
              (let ((input-output-pairing `(((2 1 1) 10)
                                            ((3 2 1) 36)
                                            ((1 1 1) 3)
                                            ((4 3 1) 92))))
                (assert-false (memq #f (mapf dioph-calc input-output-pairing)))))
        (test "inc-3-pivot-list exits with error on even pivot"
              e
              (assert-true (error? (increment-3-pivot-list 2 0 0))))
        (test "inc-3-pivot-list rvcwd"
              e
              (let ((input-output-pairing `(((1 1 1) (3 2 2)) ;; testing jump to next pivot
                                            ((3 1 1) (3 3 1)) ;; testing incrementation within the range of a given pivot
                                            ((5 5 5) (7 2 2)) ;; testing jump to next pivot
                                            ((5 1 1) (5 1 3)) ;; more regular incs
                                            ((5 1 3) (5 1 5))
                                            ((5 1 5) (5 3 3)))))
                (assert-false (memq #f (mapf increment-3-pivot-list input-output-pairing)))))
        ))
