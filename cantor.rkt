;; for 2 dimensions...
;; example usage (cantor-pairing 2 0)
(define (cantor-pairing k1 k2) 
  (+
   (/
    (* (+ k1 k2)
       (+ k1 k2 1))
    2)
   k2))


;; for n dimensions, given as a list, recursively defined. I'd love to change this into a wrapper for an iteration routine
;; example usage (cantor-tuple `(5 0 3 5 7 4))
(define (cantor-tuple k)
  (if (null? (cdr k))
    (car k)
    (cantor-pairing (cantor-tuple (cdr k)) (car k))))

;; implementing some in line unit testing here, forgive me lord!
;; todo written in org
(define zombie-unit-test-pairing-vals
  (list `((2 0) 3)
	`((0 2) 5)
	`((3 1) 13)
	`((1 1) 4)
	`((3 2) 18)
	`((1 3) 11)))

;; takes arguments in the form of
;; `((2 0) 3)
(define zombie-unit-test-pairing
  (lambda (pairing-expected)
    (define pairing (car pairing-expected))
    (define expected (cadr pairing-expected))

    (= (cantor-pairing (car pairing) (cadr pairing))
       expected)))

;; actual test case

(define test-results
  (map zombie-unit-test-pairing zombie-unit-test-pairing-vals))
(define test-cantor-pairing
  (if (memq #f test-results)
      (display "Test failed! cantor-pairing did not display expected behavior!")))


