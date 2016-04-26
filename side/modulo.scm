;; given a procedure, apply the procedure to the argument, and return the pair of the argument with the result of the procedure
(define (value-result-pairing proc value)
  (list value
	(apply proc (put-in-list value))))

(define (put-in-list thing)
  (if (list? thing)
    thing
    (list thing)))

;; given a procedure and a list of values, map value-result-pairing on each value in the list. return the list.
;; an example:
;; (proc-list-pairing + `((1 1)
;; 			  (2 2)
;; 			  (4 5))
;; yields
;; `(((1 1) 2)
;;   ((2 2) 4)
;;   ((4 5) 9))
(define (proc-list-pairing proc list-of-values)
  (map
    (lambda (to-be-applied)
      (value-result-pairing proc to-be-applied))
    list-of-values))

;; given a number, return the list of all positive numbers and 0 strictly less than it. num must be positive. doesn't seem to be a built in proc, and please don't feed it anything less than or equal to 0. pretty please?
(define (numbers-less-than number)
  (let ((number-to-add (- number 1)))
    (if (zero? number-to-add)
      `(0)
      (cons number-to-add 
	    (numbers-less-than number-to-add)))))

;; given an exponent and a modulus, return another proc that takes a number that returns its residue with respect to the modulus.
;; CURRY
(define (residue-builder exponent modulus)
  (define (residue number)
    (modulo-expt number exponent modulus))
  residue)


;; given an exponent and a modulus, get the list of numbers defined by numbers-less-than, and apply modulo-expt to all of them. return the list as defined by proc-list-pairing
(define (modulus-profile exponent modulus)
  (let ((value-list (numbers-less-than modulus)))
    (proc-list-pairing (residue-builder exponent modulus)
		       value-list)))

(define (prettyprint exponent modulus)
  (for-each
    (lambda (pairing)
      (display (format #f "~a\n" pairing)))
    (modulus-profile exponent modulus)))
