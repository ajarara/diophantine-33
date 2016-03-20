
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

(define (index pivot 2nd 3rd)
  (* (expt 2 pivot)
     (expt 3 2nd)
     (expt 5 3rd)))

(define (increment-3-pivot-list pivot 2nd 3rd)
  (cond ((= pivot 2nd 3rd)
         (list (1+ pivot) 0 0))
        ((= pivot 3rd)
         (list pivot (1+ 2nd) (1+ 2nd)))
        (else
         (list pivot 2nd (1+ 3rd)))))
;;(define (increment-3-pivot-list pivot 2nd 3rd)
  ;;(cond ((= pivot 2nd 3rd)
         ;;(list (+1 pivot) 0 0))
        ;;((= pivot 3rd)
         ;;(list pivot (+1 3rd) (+1 3rd)))
        ;;(else
         ;;(list pivot 2nd (+1 3rd)))))
