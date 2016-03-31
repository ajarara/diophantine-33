;; generalized to z dimensions
;; also the ordering function
;; also the incrementing function

;; the below are example functions to demonstrate how this package works.
;; (define ordering =) ; the function used to compare elements in a list. We expect a boolean out of this. Soon will also abstract this away, although not quite sure how
(define inc 1+) ; the function used to mutate elements with the goal of eventual successful ordering. We expect this operation to be able to be continuously applied to its output.
(define initial-element 1) ; the value to set the rest of the list once a successful comparison has been made. really the rest of the list is just thrown out, and a new list is created with these as entries


;; given a list, uniform? returns whether that list only contains multiple instances of the same object. automatically succeeds by design on lists of 1 element.
(define (uniform? list)
  "stub")

;; the meat of our enumerate function, given an atomic head and a list of atoms, compare the head to the first item of the tail using the ordering given. if the head is equal to every element in the tail, increment the head, and cons it to a new tail of the same length with every element set to the initial one

;; if our comparison function holds, we leave the head unchanged and reiterate with a new head (the car of our tail) and the rest of the tail (the cdr of our tail)

(define enumerate
  (lambda (an-ordering inc-function initial-element)
    (display "nothing")
    ))

