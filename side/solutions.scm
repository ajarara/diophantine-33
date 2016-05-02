(load "./modulo.scm")
(import (srfi srfi-1))

;; functions we care about are pretty much only modulus-profile

;; given a list spit out by modulus-profile
;; (try pretty print to see what this looks like, an example is:
;;   (modulus-profile 3 3)
;;   => ((0 0)
;;       (1 1)
;;       (2 2))


;; why not just add them?
;; (+ 1 1) = 2 mod n for n greater than 1
;; but
;; (- 1 1) = 0 mod n for any n
;; honestly we only need to check for equality in the second case, as we're dealing with numbers strictly less than the modulus. but I'd rather inefficiency than possibly miss the solution due to some oversight, so I'm playing it safe.
(define (combination-modulo num1 num2 modulus)
  (or
    (= 0
       (modulo (+ num1 num2) modulus))
    (= 0
       (modulo (- num1 num2) modulus))))


;; given a predicate, a list given of value-result pairs (say, like the one given by modulus-profile)...
;; and an element of that list, return all the values whose results when fed to predicate alongside the result of the lone element return true.
;; the predicate recieves the value-result pairing and the list is of all values returned satisfying the predicate
;; I'm assuming a lot with this function.
;;   firstly, if there are duplicate values in the list-value listing whose results satisfy the predicate, there will be duplicate values in the returned list
(define (find-all-values pred list-value-result)
  (map value
       (filter pred list-value-result)))


;; given a number (that is appropriate, strictly less than the modulus), a list given by modulus-profile, and a target modulus, find all values that give satisfy our combination-modulus procedure above.
(define (modulus-matches to-be-tested-against list-value-result modulus)
  (let
    ((our-pred (lambda (some-pairing)
		(combination-modulo
		  to-be-tested-against
		  (result some-pairing)
		  modulus))))
    (find-all-values
      our-pred
      list-value-result)))


