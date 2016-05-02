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

;; given an element of proc-list-pairing, return the value contained within it.
(define (value element-of-proc-list-pairing)
  (car element-of-proc-list-pairing))

(define (result element-of-proc-list-pairing)
  (cadr element-of-proc-list-pairing))
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


;; given an exponent and a modulus, get the list of numbers defined by numbers-less-than, and apply modulo-expt to all of them. return the list as defined by proc-list-pairing. 
(define (modulus-profile exponent modulus)
  (let ((value-list (numbers-less-than modulus)))
    (proc-list-pairing (residue-builder exponent modulus)
		       value-list)))

;; print out the result of the above list for given exponent, modulus
(define (prettyprint exponent modulus)
  (for-each
    (lambda (pairing)
      (display (format #f "~a\n" pairing)))
    (modulus-profile exponent modulus)))

;; given a list of exponent-modulus pairs, return the largest modulus
(define (max-of-em-pairs em-pairing)
  (let ((modulus-listing
	  (map cadr em-pairing)))
    (apply max modulus-listing)))

;; given a list of exponent-modulus pairs, build a list of residue finders
(define (em-proc-list em-pairing)
  (map
    (lambda (pairing)
      (apply residue-builder pairing))
    em-pairing))

;; given a list of residue finders, return a procedure that takes a number and returns the list containing number, followed by the residue w.r.t expt/modulus pairs used to construct those residue finders. the residue finders are the result of em-proc-list
(define (residue-profiler-builder residue-finders)
  (lambda (number)
    (cons number
	  (map
	    (lambda (proc)
	      (proc number))
	    residue-finders))))

;; handy... shows us if each number less than the modulus has a distinct value
(define (smooth-residue-profile? exponent modulus)
  (let ((number-profile (numbers-less-than modulus)))
    (equal? number-profile
	 (sort
	   (map
	     (residue-builder exponent modulus)
	     number-profile)
	   >))))
	 
