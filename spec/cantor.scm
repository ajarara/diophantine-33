;; TEST FILE
(load "../cantor.scm")
(load "../utility.scm")
(use-modules (ggspec lib))

(suite "Two dimensional cantor pairing functions return expected values"
       (tests
	(test "cantor-pairing returns expected values"
	      e
             (let ((expected-behavior `(((0 0) 0)
                                         ((1 1) 4)
                                         ((1 0) 1)
                                         ((0 1) 2)
                                         ((2 1) 7)
                                         ((1 2) 8))))

               (assert-false (memq #f (mapf cantor-pairing expected-behavior)))))
        ))
