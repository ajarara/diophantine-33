;; TEST FILE
(load "../utility.scm")
(use-modules (ggspec lib))

(suite "Function generators return functions that work with the documented format of usage"
       (tests
        (test "mapf takes a function, applies it to a given list of input-output pairings, and then returns the results of comparing it to expected values"
              e
              (let ((pairings `(((8 0) 8)
                               ((1 4) 5)
                               ((0 0) 10)
                               ((9 1) 10)))
                    (expected `(#t #t #f #t)))
                (assert-true (equal? expected (mapf + pairings)))))
        ))
