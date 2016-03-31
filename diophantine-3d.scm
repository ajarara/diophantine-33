
;; it's pretty hard to enumerate through 3 dimensions by walking through a 3d lattice, especially when you introduce duplicates. so the inspiration from the pairing function's geometric representation is not really applicable here..
;; instead, we can just enumerate through tuples, being careful to avoid repeats.
;; the way we do this is by constructing a list, like below
;;
;; (0 0 0)
;;
;; the first element is our pivot, in this case 0.
;; compare the other elements in the list with the pivot.
;; in the 3 dimensional situation, we only have 3 cases that concern us:
;;
;; the case where the other 2 elements are equal to the pivot
;; the case where the last element is equal to the pivot
;; the else case
;;
;; in the example given above, we satisfied the first case, so we inc the pivot
;; and we get
;; 
;; (1 0 0)
;;
;; and now 1 is the new pivot. Compare the two, and we move to the else case
;; and we increment the last term.
;;
;; (1 0 1)
;;
;; now the 2nd case is satisfied, we inc the element to the right of the last
;; element, and reset the last element.
;;
;; (1 1 0)
;;
;; now we again have the else case, and increment the last element.
;;
;; (1 1 1)
;;
;; now the first case is satisfied, we can finally move the pivot.
;;
;; (2 0 0)
;;
;; so for every pivot, we have a way to get every set s.t. every element is less than or equal to the pivot.
;; so pivots partition the set of all 3-sets of N, since a pivot-set does not include any of the sets from lower pivots (since a pivot-set has a pivot in every set, and lower pivot-sets, by definition, cannot have a number higher than it's pivot.)
;;
;; INDEXING
;; one important feature of this suite of functions is the ability to assign a number to each set so that we can stop and start our search at will.
;; take each set, order them into a tuple consistent with what we might get
;; from our pivot generation technique outlined above, and assign an index to it by the following rule:
;; again this function is specific to 3-tuples

(define (index pivot-list)
  (let ((pivot (car pivot-list))
        (2nd (cadr pivot-list))
        (3rd (caddr pivot-list)))
    (* (expt 2 pivot)
       (expt 3 2nd)
       (expt 5 3rd))))

;; given a number, return the associated pivot list in that order.
(define (pivot-list-of-index index)
  ;; given a number and a factor, return the factor of the number with respect to that base.
  (define (order-of-factor number factor)
    (define (iter number factor order)
      (if (= (modulo number factor) 0)
          (iter (inexact->exact (/ number factor)) ;; divide the number by the given factor, since we know it divides it evenly there should be no remainder and inexact->exact only does type conversion
                factor
                (1+ order))
          order)) ;; if the factor does not divide the current number, return the order.
    (iter number factor 0))

  (list (order-of-factor index 2)
        (order-of-factor index 3)
        (order-of-factor index 5)))
          
      
;; this is without optimizations for the solution with respect to 33, for example we know that there are no solutions that are all even, so the regular increment-3-pivot simply skips all those solutions.
(define (gen-increment-3-pivot-list pivot-list)
  (let ((pivot (car pivot-list))
        (2nd (cadr pivot-list))
        (3rd (caddr pivot-list)))
    (cond ((= pivot 2nd 3rd)
           (list (1+ pivot) 0 0))
          ((= pivot 2nd)
           (list pivot (1+ 2nd) (1+ 2nd)))
          (else
           (list pivot (1+ 2nd) 3rd)))))

;; The following optimizations are made
;; all solutions have exactly 1 or 3 odd integers
;; there is no 2 dimensional solution (proof incoming), so there are no 0's in any solution
(define (increment-3-pivot-list pivot-list)
  (let ((pivot (car pivot-list))
        (2nd (cadr pivot-list))
        (3rd (caddr pivot-list)))
    (cond ((even? pivot)
           (error "pivot should not be even!" pivot 2nd 3rd))
          ((= pivot 2nd 3rd)
           (list (+ pivot 2) 2 2))
          ((< pivot (+ 2 3rd))
           (list pivot 1 1)) ;; evens are done, now do odds.
          ((< pivot (+ 2 2nd))
           (list pivot 2nd (+ 2 3rd))) ;; there are still combinations in our given parity that we're not considering, iterate again 
          ((= 2nd (+ 2 3rd))
           (list pivot 2nd (+ 2 3rd)))
          (else
           (list pivot (+ 2 2nd) 3rd)))))

(define 2+
  (lambda (number)
    (+ 2 number)))

;; start by checking all the possible solutions with 1 odd, 2 even, until incrementing the 3rd value is more than the pivot
;; then check all the possible solutions with all odd.
(define (increment-3-pivot-list pivot-list)
  (let ((pivot (car pivot-list))
        (2nd (cadr pivot-list))
        (3rd (caddr pivot-list)))
    (cond ((even? pivot)
           (error "pivot should never be even!" pivot 2nd 3rd))
          ((= pivot 2nd 3rd) ; odds are done, increment the pivot and start again with 2s
           (list (2+ pivot) 2 2))
          ((< pivot (2+ 3rd)) ; evens are done, switch to odd solutions
           ; this is provided that our 2nd is never greater than our 3rd, which we'll take care of in the next cond
           (list pivot 1 1))
          ((< 2nd (2+ 3rd)) ; incrementing our 3rd number breaks our enumeration scheme
           (list pivot (2+ 2nd) (remainder 3rd 2))) ; bump our 2nd number, reset the 2nd to its parity
          (else ; we're safe to increment our 3rd number
           (list pivot 2nd (2+ 3rd)))
          )))
           

;; given three numbers, sum their cubes
(define (dioph-calc a b c)
  (+ (expt a 3)
     (expt b 3)
     (expt c 3)))


;; instantiate an object with a given index. Given an index one would expect from the index function, construct the pivot list (allowing incrementers to be made at any point of the enumeration)
;; given the signal `current
;; return the current pivot list without incrementing
;; given the signal `next
;; increment the pivot list as defined by the inc-function, and return the new pivot-list
;; given the signal `index
;; return the number that can be used to generate a new incrementer with the same pivot-list
;; given the signal `inc-get
;; return the function passed in the instantiation of dispatch
(define (make-incrementer inc-function some-index)
  (define pivot-list (pivot-list-of-index some-index))
  (define (dispatch signal)
    (cond ((eq? signal `current)
           pivot-list)
          ((eq? signal `next)
           (set! pivot-list (inc-function pivot-list))
           pivot-list)
          ((eq? signal `index)
           (index pivot-list))
          ((eq? signal `inc-get)
           inc-function)
          ))
  dispatch)
