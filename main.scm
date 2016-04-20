#!/usr/local/bin/guile \
-e main -s
!#
;; MAIN FILE
;; command arguments are of pivot list form

(define input-args `(1 1 1))

(if (< 1
       (length (command-line)))
  (set! input-args (map string->number (cdr (command-line)))))

(load "./sanitize.scm")
(sanitize input-args)
;; okay we're all good, fire up the interface and start 'er up
(load "./interface.scm")
(display "WE DID IT REDDIT\n")
