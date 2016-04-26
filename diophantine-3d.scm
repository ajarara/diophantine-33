;; need this for our control mechanism, will possibly move this out to some other file someday
(use-modules (rnrs io ports))

;; needed entirely for the fold proc
(use-modules (srfi srfi-1))
;; it's pretty hard to enumerate through 3 dimensions by walking through a 3d lattice, especially when you introduce duplicates. so the inspiration from the pairing function's geometric representation is not really applicable here..
;; instead, we can just enumerate through tuples, being careful to avoid repeats.
;; the way we do this is by constructing a list, like below
;;
;; (1 0 0)
;; (1 1 0)
;; (1 1 1)
;;
;; then this 'shell' of potential solutions has been exhausted, and we move on to the next one
;;
;; (2 0 0)
;; (2 1 0)
;; (2 1 1)
;; (2 2 0)
;; (2 2 1)
;; (2 2 2)
;;
;; and this 'shell' of size 2 has been exhausted. move to size 3, and repeat.

;; document everything!
(define (2+ number)
  (+ 2 number))

;; given an odd number, returns 1, given an even, returns 2.
;; this proc is only used once, but warrants a description, the reason I use this instead of remainder is because I want to elimate all solutions with 0 in them (there is no 2-dimensional solution for 33), and this provides a very convenient way to reset our third number in the following procedure
(define (upper-mod number)
  (- 2 (remainder number 2)))

;; we're solving for the solution, always. if you want to apply this program to another number, you can do so, but the incrementing procedure and the list maps are tuned to find solutions specifically for 33
(define solution
  33)


;; here's where most of the 'optimization' is.
;; What is embodied here:
;;   if there is a solution to our problem w.r.t 33, then
;;   all solutions must contain either 1 or 3 odd numbers.
;;
;;   0 does not appear in any solution, ever. sorry.
;;
;;   the diophantine equation we're interested in is symmetric
;;   that is, if a solution (a b c) exists, then any permutation
;;   also solves it (aka (b a c) (c b a) (c a b)...) so we're
;;   only going to test one permutation
;;   
;; since we always are guaranteed one odd number in the solution, we'll make the pivot always odd (in fact, there used to be a condition here that made sure the pivot was odd, but short of cosmic bit flipping there is no way that it will turn out to be odd, so it was unnecessary computation.
;; start by checking all the possible solutions with 1 odd, 2 even, until incrementing the third value is more than the pivot
;; then check all the possible solutions with all odd.
(define (increment-3-pivot-list pivot-list)
  (let ((pivot (car pivot-list))
        (second (cadr pivot-list))
        (third (caddr pivot-list)))
    (cond ((= pivot second third) ; odds are done, increment the pivot and start again with 2s
           (list (2+ pivot) 2 2))
          ((< pivot (2+ third)) ; evens are done, switch to odd solutions
           ; this is provided that our second is never greater than our third, which we'll take care of in the next cond
           (list pivot 1 1))
          ((< second (2+ third)) ; incrementing our third number breaks our enumeration scheme
           (list pivot (2+ second) (upper-mod third))) ; bump our second number, reset the second to its parity (with our special procedure)
          (else ; we're safe to increment our third number
           (list pivot second (2+ third)))
          )))
           



;; given a list, sum the elements
(define (sum-list some-list)
  (if (null? some-list)
    0
    (+ (car some-list) (sum-list (cdr some-list)))))


;; this however, I do need
;; given a list, construct a new list with each element cubed
(define (cube-list some-list)
  (map
    (lambda (number)
      (expt number 3))
    some-list))

(define (cbrt-list some-list)
  (map
    (lambda (number)
      (inexact->exact
	(expt number 1/3)))
    some-list))

;; given a 3-multiset (as defined by GSL), we want to generate all combinations of negative and positive entries. we need to identify the type of the multiset, and then call the appropriate generating function
;; there are only 3 cases we should be handling:
;;   1. all integers are distinct
;;   2. the pivot and the 2nd integer are the same
;;   3. the 2nd and 3rd integer are the same.
;; the most intensive (and unfortunately most common case) is when all the integers are distinct, and we have to generate all possibilities (besides all negative and all positive).
;; one thing we are not worried about is when all three entries are the same, they can't all be positive, they can't all be negative, so one has to cancel out the other. but that would imply a 1 dimensional solution, which we know is not possible.
;; we're also not worried about the pivot and the 3rd integer being equal. in order for that to happen, then we must have a list that is also a triplet, because of the way we arrived at that solution.


;; !!! THIS PROCEDURE IDENTIFIES (5 1 5) AS DISTINCT !!!
(define (identify-list some-list)
  (let ((pivot (car some-list))
	(second (cadr some-list))
	(third (caddr some-list)))
    (cond ((= second third)
	   (if (= pivot second)
	     triplet-map
	     2,3-dup-map))
	  ((= pivot second)
	   1,2-dup-map)
	  (else
	   distinct-map))))


;; these two functions are used by populate-list to generate a list of attempts, based on the type of attempt family (1,2-dup, 2,3-dup, all distinct, etc.)
(define (multiply-two-lists list1 list2)
  (map * list1 list2))

;; given a 3-list and a list of 3-lists, apply multiply-two-lists to each list in the list of 3-lists
;; could probably come up with better variable names
(define (generate-from-list some-list list-of-lists)
  (map (lambda (list-from-listol)
	 (multiply-two-lists some-list list-from-listol))
       list-of-lists))

;; this is the list we're mapping to when all our elements are distinct:
;; there are no solutions of all negative and positive values, so we can eliminate those.
;; further, since we know that the pivot is >= the rest of the list, and that 2nd >= 3rd, we can throw out the (-1 -1 1) entry as well, as we're guaranteed that is negative, provided the list isn't all 0's
(define distinct-map
  `((1 -1 -1)
    (-1 1 -1)
    (1 1 -1)
    (1 -1 1)
    (-1 1 1)))

;; this is the list we're mapping to when our pivot and 2nd integer are the same:
;; they can't have opposite signs, as that would imply that we would have a 1 dimensional solution, which we clearly don't
;; that combined with the fact that we have no solutions that are all negative or all positive means we only need to check two solutions.
(define 1,2-dup-map
  `((1 1 -1)
    (-1 -1 1)))

;; analagous to the above, applies if our 2nd and 3rd integers are equal.
(define 2,3-dup-map
  `((-1 1 1)
    (1 -1 -1)))
    
;; triplets are never a solution
(define triplet-map
  `())

;; given a 3-list, get the associated list-map, cube the elements, and apply the list-map to the elements
(define (list-generate some-list)
  (let ((list-map (identify-list some-list))
	(cubed-list (cube-list some-list)))
    (generate-from-list cubed-list list-map)))

