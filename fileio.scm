(use-modules (ice-9 rdelim))
;; given an input stream, read its contents until you encounter an #EOF. return the last line in the file.
(define (last-line-of-file input-stream)
  (define line-we-want "")
  (define buffer (read-line input-stream))
  (if (eof-object? buffer)
      (error "input-stream already empty when passed to last-line-of-file" input-stream))

  ;; the first check is guaranteed not to be an EOF signal, so we will read the input-stream at least once.
  (while (not (eof-object? buffer))
         ;; save the contents of buffer before overwriting it
         (set! line-we-want buffer)
         ;; read the contents of the stream, and invoke the loop again.
         (set! buffer (read-line input-stream)))
  ;; once we've encountered an EOF object, the last invocation of line-we-want has the line in question.

  line-we-want)
