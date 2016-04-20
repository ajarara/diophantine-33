(define helpstring
  "Incorrect command. Currently supported commands are:
  \tq : display where we're at, quit the program
  \tc : display where we're at
  \tanything else: display this message. It's free!")

(define input-port (current-input-port))

(define (handle-input signal current-list)
  (cond ((eq? signal `v)
	 ; verbose mode, spew out all tries
	 (verbose-loop current-list))
	((eq? signal `c)
	 (one-off-calc current-list)
