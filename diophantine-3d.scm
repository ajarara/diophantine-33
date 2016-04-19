;; need this for our control mechanism, will possibly move this out to some other file someday
(use-modules (rnrs io ports))

;; needed entirely for the fold proc
(use-modules (srfi srfi-1))
;; it's pretty hard to enumerate through 3 dimensions by walking through a 3d lattice, especially when you introduce duplicates. so the inspiration from the pairing function's geometric representation is not really applicable here..
;; instead, we can just enumerate through tuples, being careful to avoid repeats.
;; the way we do this is by constructing a list, like below
;;
;; (0 0 0)
;;
;; the first element is our pivot, in this case 0.
;; compare the other elements in the list with the pivot.
;; in the 3 dimensional situation (it gets more complicated with n), we only have 3 cases that concern us:
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
;; now the second case is satisfied, we inc the element to the right of the last
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
        (second (cadr pivot-list))
        (third (caddr pivot-list)))
    (* (expt 2 pivot)
       (expt 3 second)
       (expt 5 third))))

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
        (second (cadr pivot-list))
        (third (caddr pivot-list)))
    (cond ((= pivot second third)
           (list (1+ pivot) 0 0))
          ((= pivot second)
           (list pivot (1+ second) (1+ second)))
          (else
           (list pivot (1+ second) third)))))

(define (2+ number)
  (+ 2 number))

;; given an odd number, returns 1, given an even, returns 2.
;; this proc is only used once, but warrants a description, the reason I use this instead of remainder is because I want to elimate all solutions with 0 in them (there is no 2-dimensional solution for 33), and this provides a very convenient way to reset our third number in the following procedure
(define (upper-mod number)
  (- 2 (remainder number 2)))

;; start by checking all the possible solutions with 1 odd, 2 even, until incrementing the third value is more than the pivot
;; then check all the possible solutions with all odd.
(define (increment-3-pivot-list pivot-list)
  (let ((pivot (car pivot-list))
        (second (cadr pivot-list))
        (third (caddr pivot-list)))
    (cond ((even? pivot)
           (error "pivot should never be even!" pivot second third))
          ((= pivot second third) ; odds are done, increment the pivot and start again with 2s
           (list (2+ pivot) 2 2))
          ((< pivot (2+ third)) ; evens are done, switch to odd solutions
           ; this is provided that our second is never greater than our third, which we'll take care of in the next cond
           (list pivot 1 1))
          ((< second (2+ third)) ; incrementing our third number breaks our enumeration scheme
           (list pivot (2+ second) (upper-mod third))) ; bump our second number, reset the second to its parity
          (else ; we're safe to increment our third number
           (list pivot second (2+ third)))
          )))
           

;; given three numbers, sum them
(define (dioph-calc a b c)
  (+ (expt a 3)
     (expt b 3)
     (expt c 3)))


;; given a list of three numbers and another number, apply the list to dioph-calc and compare it with the other number.
(define (check-for-solution guess-list value-in-question)
  (= (apply dioph-calc guess-list)
     value-in-question))

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
  	(cond 
          ((eq? signal `next)
           (set! pivot-list (inc-function pivot-list))
           pivot-list)
	  ((eq? signal `current)
           pivot-list)
          ((eq? signal `index)
           (index pivot-list))
          ((eq? signal `inc-get)
           inc-function)
          ))
  dispatch)

;; given a 3-multiset (as defined by GSL), we want to generate all combinations of negative and positive entries. we need to identify the type of the multiset, and then call the appropriate generating function
;; there are only 3 cases we should be handling:
;;   1. all integers are distinct
;;   2. the pivot and the 2nd integer are the same
;;   3. the 2nd and 3rd integer are the same.
;; the most intensive (and unfortunately most common case) is when all the integers are distinct, and we have to generate all possibilities (besides all negative and all positive).
;; one thing we are not worried about is when all three entries are the same, they can't all be positive, they can't all be negative, so one has to cancel out the other. but that would imply a 1 dimensional solution, which we know is not possible.
;; we're also not worried about the pivot and the 3rd integer being equal. in order for that to happen, then we must have a list that also satisfies the sentence right above this one, and we've already proven that it's a non-issue.

(define populate-list
  (lambda (seed-list)
    (let ((pivot (car seed-list))
	  (2nd (cadr seed-list))
	  (3rd (caddr seed-list)))
      (cond ((= pivot 2nd)
	     (if (= pivot 3rd)
	       `() ; then we have a triplet, so we'll ignore it and return the empty list
	       (generate-from-seed seed-list 1,2-dup-map))) ; then we only have the 1st two integers as duplicates, with the third one distinct. return the list we want
	    ((= 2nd 3rd)
	     (generate-from-seed seed-list 2,3-dup-map))
	    (else
	      (generate-from-seed seed-list distinct-map))
	    ))))



;; these two functions are used by populate-list to generate a list of attempts, based on the type of attempt family (1,2-dup, 2,3-dup, all distinct, etc.)
(define (multiply-two-lists list1 list2)
  (map * list1 list2))

(define (generate-from-seed seed-list list-of-lists)
  (map (lambda (list-from-listol)
	 (multiply-two-lists seed-list list-from-listol))
       list-of-lists))

;; this is the list we're mapping to when all our elements are distinct:
;; there are no solutions of all negative and positive values
(define distinct-map
  `(
    (1 -1 -1)
    (-1 1 -1)
    (-1 -1 1)
    (1 1 -1)
    (1 -1 1)
    (-1 1 1)))

;; this is the list we're mapping to when our pivot and 2nd integer are the same:
;; they can't have opposite signs, as that would imply that we would have a 1 dimensional solution, which we clearly don't
;; that combined with the fact that we have no solutions that are all negative or all positive means we only need to check two solutions.
(define 1,2-dup-map
  `(
    (1 1 -1)
    (-1 -1 1)))

;; analagous to the above, applies if our 2nd and 3rd integers are equal.
(define 2,3-dup-map
  `(
    (-1 1 1)
    (1 -1 -1)))
    
;; now we have all the machinery for the full fledged enumerator

(define (space-enumerator incrementer)
  (define working-list `())
  (define (dispatch signal)
    ; if the working list is null, populate it with new values and recall dispatch with the signal it was given
    (cond ((null? working-list)
	   (set! working-list (populate-list (incrementer `next)))
	   (dispatch signal))
	  ((eq? signal `current)
	   (car working-list))
	  ((eq? signal `next)
	   (set! working-list (cdr working-list))
	   (dispatch `current))
	  ((eq? signal `index)
	   (incrementer `index))
	  ((eq? signal `inc-get)
	   (incrementer `inc-get))
	  ))
  dispatch)

;; I know this is significantly better implemented as a stream of values to be tested instead of something that holds the lists and dispenses them one at a time, generating new lists when needed (sometimes every other element in some bad cases) but this seemed to be the most natural way to write it as of the knowledge I have

;; BEGIN user interface portion of the script

(define helpstring
  "Incorrect command. Currently supported commands are:
  \tq : display where we're at, quit the program
  \tc : display where we're at
  \tanything else: display this message. It's free!")


;; big meaty function, is our preliminary controller for our enumeration. i have no idea how to break this down into further parts.
(define prelim
  (lambda (the-incrementer the-value-in-question verbosity)
    (define input (standard-input-port))
    (define continuation-condition ; should we iterate? well, if...
      (lambda ()
        (not (or (char-ready? input) ; no commands are available
	         (= the-value-in-question
	            (apply dioph-calc (the-incrementer `current))))))) ; or the equation isn't solved
    ;;; then keep iterating baby!
    (if (not verbosity)
      ;;; simple enough, check the cont condition defined above, then try again with the next value
      (while (continuation-condition)
	     (the-incrementer `next))
      ;;; okay, verbosity is enabled. this program was not designed to be ran with verbosity enabled all the time, which is both really inefficient and annoying (especially with tmux)
      ;;; it can't use the continuation condition as that causes it to apply dioph-calc twice.
      (while (continuation-condition)
	     (let ((our-try (the-incrementer `current)))
	       (display (format #f "Trying ~a yielded: ~a\n" our-try (apply dioph-calc our-try)))
	       (the-incrementer `next))))
	     

    ;;; oh boy something happened!
    (cond ((not (char-ready? input))
	   (display "Holy shit we found it! The answer is: ")
	   (display (the-incrementer `current))
	   ;;; just so we have something for our unit tests
	   #t)
	  (else
	    ;;; okay, we haven't solved it... what did the user interru -- I mean.. input?
	    ;;; only lines with one character are entertained.
	    (let ((command (read input)))
	      (cond ((eq? command `q)
		     (display (the-incrementer `current))
		     (newline))
		    ((eq? command `c)
		     (let ((status (the-incrementer `current)))
		       (display status)
		       (display " yields: ")
		       (display (apply dioph-calc status)))
		     (newline)
		      (prelim the-incrementer the-value-in-question verbosity))
		    ((eq? command `i)
		     (display (format #f "Quitting program.\n To restart at the point where we saved, use this index:\n~a" (the-incrementer `index)))
		     (newline))
		    ((eq? command `v)
		     ; ugh, why'd you enable verbosity?
		     (if verbosity
		       (display "Verbosity disabled")
		       (display "Verbosity enabled"))
		     (newline)
		     (prelim the-incrementer the-value-in-question (not verbosity)))

		     
		    (else 
		      (display helpstring)
		      (newline)
		      (prelim the-incrementer the-value-in-question verbosity))
	      ))))))
	  



;; END user interface portion of the script
