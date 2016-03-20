;; given a function and a list of inputs of this form
;; (((inputs to function) expected-output)
;;  ((another input) expected-output))
;; then apply the inputs to the function and compare with the expected-output
;; ex usage (mapf + `(((8 0) 8) ((1 4) 5) ((9 1) 10)))
;; returns a list of booleans of each comparison in order
;; so in the example, first it would evaluate (+ 8 0), compare it to 8, return the
;; value of the comparison
(define (mapf proc input-output-pairing-list)
  (map (lambda (input-output-pairing)
         (let ((inputs (car input-output-pairing))
               (expected-output (cadr input-output-pairing)))
           (equal? (apply proc inputs)
              expected-output)))
       input-output-pairing-list))

           
