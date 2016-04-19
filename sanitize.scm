;; need a way to sanitize dirty user input
(define (sanitize some-list)
  (let ((pivot (car some-list))
	(second (cadr some-list))
	(third (caddr some-list)))
    (cond ((= 3
	      (length some-list))
	   (error "incorrect number of entries in given list: " some-list))
	  ((not
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
	  (else
	    #t))))
