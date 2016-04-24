;; This code is a direct interface to the computational portion of the code. Certain definitions like compute-with-output are designed to be run in a while loop that checks for user input.
(load "./diophantine-3d.scm")
(use-srfis `(1))

(define helpstring
  "Incorrect command. Currently supported commands are:
  \tc : display where we're at
  \tv : toggle verbosity, at the cost of slowing down
  \tw : write the results of the next try to file, and quit
  \tanything else: display this message. It's free!")


;; return the victorystring
(define (victorystring victorylist comparison)
  (format #f "Hooray! ~a yields ~a! Back to work.\n" victorylist comparison))

;; given an attempt, display the result of the attempt, and return the comparison to the given number. needs to be generalized to write to any port (aka not using straight up display)
;; this is the only function that has a function built into it from dio-3d
(define (verbose-attempt some-list compared-num)
  (let ((result (sum-list some-list))) ; don't get confused here...
    (display (format #f "\tTrying ~a yields ~a\n" some-list result))
    (= result compared-num)))

;; given a list fresh from our enumerator, cube it, generate the coefficient family, and see if any attempt satisfies the predicate. return the result of the find attempt (if it's not false, then we've found an attempt)
(define (verbose-lump-attempt root-list compared-num)
  (let ((attempt-list (list-generate root-list)))
    (display (format #f "Attempting family of solutions for ~a\n" root-list))
    (find 
      (lambda (attempt)
	(verbose-attempt attempt compared-num))
      attempt-list)))

;; quiet calculation
(define (quiet-attempt some-list num)
  (= num
     (sum-list some-list)))

(define (quiet-lump-attempt root-list compared-num)
  (let ((attempt-list (list-generate root-list)))
    (find
      (lambda (attempt)
	(quiet-attempt attempt compared-num))
      attempt-list)))

(define input-port (current-input-port))

;; this is a relatively big function. it checks an input port for input. if there isn't any, it applies a lump-attempt to the list passed, and checks if the result is true. if not, it tries again.
;; parameters are: 
;; a procedure that takes a list and a value and returns a boolean
;; the value (applied to the above proc)
;; a list
;; a procedure that takes a list and returns a new one (that can also be applied to this proc)
;; needs to also take an input/output port. wondering if that's a performance hit.


(define (try-until-input list-procedure compared-value current-list inc-list)
  (cond ((char-ready? input-port)
	 (handle-input (read input-port)
		       (list list-procedure
			     compared-value
			     current-list
			     inc-list))) ; pass over control to handle-input, with a list of state
	((list-procedure current-list compared-value)
	 (display (victorystring current-list comparison))) ; we win!
	(else
	  (try-until-input
	    list-procedure
	    compared-value
	    (inc-list current-list)
	    inc-list)))) ; try again with another list

;; hey that wasn't too bad...

;; the above is an infinite loop until handle-input is called, so let's define handle-input. state is a list of all the params we had with try-until-input
(define (handle-input signal state)
  (cond ((eq? signal `c)
	 (verbose-lump-attempt (caddr state) (cadr state))
	 (apply try-until-input state)) ; print out an attempt, then resume whatever we were doing. we could turn off verbosity, but that will complicate things. we could also use the increment procedure, since we tested the procedure, but that will also complicate things.
	((eq? signal `q)
	 (display (format #f "Execution halted at ~a" (caddr state))))
	(else
	  (display helpstring)
	  (apply try-until-input state))))
