(load "./diophantine-3d.scm")

(define our-inc (make-incrementer increment-3-pivot-list 30))
(define our-enum (space-enumerator our-inc))

(prelim our-enum 33 #f)
