;; for 2 dimensions...
;; example usage (cantor-pairing 2 0)
(define (cantor-pairing tuple1 tuple2) 
  (+
   (/
    (* (+ tuple1 tuple2)
       (+ tuple1 tuple2 1))
    2)
   tuple2))

;; given an arbitrary-sized list of natural numbers, return the index of it will occur in. Currently just a wrapper to the iterative proc defined a little ways below
(define (cantor-tuple tuple)
  (cantor-iter 0 tuple))

;; for n dimensions, given as a list, recursively defined. 
;; example usage (cantor-tuple `(5 0 3 5 7 4))
(define (cantor-recur tuple)
  (if (null? (cdr tuple))
    (car tuple)
    (cantor-pairing (cantor-recur (cdr tuple)) (car tuple))))

;; iterative method, using invariant quantities and cobbled together dreams
(define (cantor-iter rolling tuple)
  (if (null? (cdr tuple))
    (cantor-pairing rolling (car tuple))
    (cantor-iter (cantor-pairing rolling (car tuple)) (cdr tuple))))
