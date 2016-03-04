;; describing the system of enumeration:
;; Cantor's enumeration works great if you want to enumerate through all
;; possible pairings of numbers, however it repeats values if you're
;; considering sets of certain numbers of a certain size (in this file's case,
;; size 2, in the next implementation, size n). There is an easy way to fix this
;; for size 2, but as will soon be demonstrated, once you get to size 3, things
;; get quite hairy, there is no simple spatial method to enumerate through sets of
;; size three with all elements selected from Z.

;; given a shell number, return the minimal index that is in it
;; usage (minimal-index-of-shell 3) => 16
;; 15 is given the coordinates (3, 3) in this system of enumeration
(define minimal-index-of-shell
  (lambda (shell)
    (+ (* 2 (* shell shell)) (* 3 shell) 1)))

;; given a shell number, return the maximal index that is contained in it
;; usage (maximal-index-of-shell 3) => 28
;; 28 is given the coordinates (-3, -3) in this system of enumeration
;; this is implemented directly as a result of minimal-index-of-shell, it can
;; be implemented as it's own procedure, but I've got an 8:30 tomorrow.
(define maximal-index-of-shell
  (lambda (shell)
    (- (minimal-index-of-shell (1+ shell)) 1)))


;; given an index, determine the shell it's in
;; inverted functionality of minimal-index-of-shell
(define shell-of-index
  (lambda (index)
    (inexact->exact
     (floor
      (* (/ 1 4)
	 (- (sqrt (+ 1
		     (* 8 index)))
	    3))))))


;; more inline testing.. this bugs me so much.
;; generalized testing procedure follows,
;; given a function and a list of samples,
;; map the function with the first entry of
;; the sample and compare with the second entry
;; save the results of the compare in a list
;; and check for inconsistent values
;; if there are any consistencies, print the message
(define test
  (lambda (function samples diagnostic-message)
    (if (memq #f
              (map (lambda (sample)
		     (define sample-input (car sample))
		     (define sample-output (cadr sample))
	            (= (apply function sample-input)
		       sample-output))
		   samples))
	      
	(lambda () ((newline) (display "TESTING ERROR: ") (display diagnostic-message) (newline) #f))
      #t)))

(define test-test
  (lambda ()
    (define samples
      `(((10 5) 15)
	((22 -1) 21)
	((1 1) 2)))
    (test + samples "procedure test failed it's test! Madness.")))
(test-test)


;; testing minimal-index-of-shell
;; list of pairs following the format (input expected-output)
(define minimal-index-of-shell-data
  (list `(0 1)
	`(1 2)
	`(2 7)
	`(3 16)
	`(4 29)))


;; testing maximal-index-of-shell
;; list of pairs following the format (input expected-output)
(define maximal-index-of-shell-data
  (list `(0 1)
	`(1 6)
	`(2 15)
	`(3 28)
	`(4 45)))

	
	
