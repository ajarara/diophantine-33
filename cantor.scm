;; for 2 dimensions...
;; example usage (cantor-pairing 2 0)
(define (cantor-pairing tuple1 tuple2) 
  (+
   (/
    (* (+ tuple1 tuple2)
       (+ tuple1 tuple2 1))
    2)
   tuple2))


;; for n dimensions, given as a list, recursively defined. I'd love to change this into a wrapper for an iteration routine
;; example usage (cantor-tuple `(5 0 3 5 7 4))
(define (cantor-tuple tuple)
  (if (null? (cdr tuple))
    (car tuple)
    (cantor-pairing (cantor-tuple (cdr tuple)) (car tuple))))

;; iterative method, using invariant quantities and cobbled together dreams
(define (cantor-iter rolling tuple)
  (if (null? (cdr tuple))
    (cantor-pairing rolling (car tuple))
    (cantor-iter (cantor-pairing rolling (car tuple)) (cdr tuple))))
