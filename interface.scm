(define helpstring
  "Incorrect command. Currently supported commands are:
  \tc : display where we're at
  \tv : toggle verbosity, at the cost of slowing down
  \tw : write the results of the next try to file, and quit
  \tanything else: display this message. It's free!")

(define input-port (current-input-port))

(define (handle-input signal current-list)
  (cond ((eq? signal `c)
	 ; print the next try, and then resume silent calculation
	 (display-one-off-and-resume current-list))
	((eq? signal `v)
	 ; need a way to neatly toggle verbosity
	 (toggle-verbosity current-list))
	((eq? signal `w)
	 (write-out current-list))
	(else
	  (display helpstring)
	  (resume current-list))
	 
