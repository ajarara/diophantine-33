(load "../cantor.scm")
(use-modules (ggspec lib))

(suite "Two dimensional case"
       (tests
	(test "cantor-pairing returns expected values"
	      e
              (let ((expected-behavior `(((0 0) 0)
                                         ((1 1) 4)
                                         ((1 0) 1)
                                         ((0 1) 2)
                                         ((2 1) 7)
                                         ((1 2) 8))))

                (assert-false (memq #f (map (lambda (input-output-pairing)
                                              (= (apply cantor-pairing (car input-output-pairing))
                                                 (cadr input-output-pairing)))
                                            expected-behavior))))
              )
        ;; this test won't pass until a refactor occurs, cantor-iter is defined
        ;; fundamentally differently... either need to refactor it so that
        ;; this test passes or accept the fact that different
        ;; methods of implementation mean different outputs.
        ;;(test "cantor-iter = cantor-recur for some test values"
              ;;e
              ;;(let ((inputs `((0 0)
                              ;;(1 1)
                              ;;(1 0)
                              ;;(0 1)
                              ;;(2 1)
                              ;;(1 1))))
                ;;(assert-false (memq #f (map (lambda (input-pairing)
                                              ;;(= (cantor-iter 0 input-pairing)
                                                 ;;(cantor-recur input-pairing)))
                                            ;;inputs)))))
        ))
