;; TEST FILE
(load "../utility.scm")
(load "../diophantine-3d.scm")
(use-modules (ggspec lib))

(suite "Auxiliary functions of dio-3d work as expected"
       (tests
        (test "index returns values consistent with its description (r.v.c.w.d)"
              e
              (let ((input-output-pairing `(((2 1 1) 60)
                                           ((3 1 1) 120)
                                           ((1 1 1) 30)
                                           ((1 0 1) 10))))
                (assert-false (memq #f (mapf index input-output-pairing)))))
        (test "inc-3-pivot-list r.v.c.w.d"
              e
              (let ((input-output-pairing `(((2 1 1) (2 1 2))
                                            ((1 0 0) (1 0 1))
                                            ((0 0 0) (1 0 0))
                                            ((2 2 2) (3 0 0))
                                            ((3 0 3) (3 1 1)))))
                (assert-false (memq #f (mapf increment-3-pivot-list input-output-pairing)))))
        ))
