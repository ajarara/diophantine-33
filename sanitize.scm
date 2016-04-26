;; need a way to sanitize dirty user input
(define (sanitize some-list)
  (if (not (= 3
	      (length some-list)))
    (error "incorrect number of entries in given list: " some-list))
  (let ((pivot (car some-list))
	(second (cadr some-list))
	(third (caddr some-list)))
    (cond ((not
	     (and-map
	       (lambda (entry)
		 (integer? entry))
	       some-list))
	   (error "some of the elements aren't integers!" some-list))
	  ((even? pivot)
	   (error "the first element should not be even!" some-list))
	  ((or-map
	     (lambda (number)
	       (> 0 number))
	     some-list)
	   (error "no numbers should be negative!" some-list))
	  ((or (< second third) (< pivot second))
	   (error "numbers should be in strictly decreasing order" some-list))
	  ((not (= (remainder second 2)
		   (remainder third 2)))
	   (error "the second and third entries are not the same parity!" some-list))
	  )))
