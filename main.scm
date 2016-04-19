#!/usr/local/bin/guile \
-e main -s
!#
;; MAIN FILE
;; command arguments are of pivot list form

(define input-args `(1 1 1))
(let ((input-len (length (command-line))))
  (cond ((= 4 input-len)
	 (set! input-args (map string->number (cdr (command-line))))) ; get the rest of the arguments and use that as our starting point
	((= 1 input-len)) ; nothing was input, don't do anything
	(else
	  (error "expecting 3 numbers as input!" (command-line)))))

(if (< 1
       (length (command-line)))
  (set! input-args (map string->number (cdr (command-line)))))

(load "./sanitize.scm")
(if (not (sanitize input-args))
  (error "input arguments are not correct as defined by the sanitize function in sanitize.scm" input-args))
;; okay we're all good
(load "./diophantine-3d.scm")

(define our-inc (make-incrementer increment-3-pivot-list (index input-args)))
(define our-enum (space-enumerator our-inc))

(prelim our-enum 33 #f)
