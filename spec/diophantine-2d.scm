;; TEST FILE
(load "../diophantine-2d.scm")
(use-modules (ggspec lib))

(suite "minimal-index-of-shell rvcwd"
       (tests
        (test "the 0th shell has index 1"
              e
              (assert-equal 1
                            (minimal-index-of-shell 0)))
        (test "the 2nd shell has index 15"
              e
              (assert-equal 15
                            (minimal-index-of-shell 2)))
        ))


(suite "shell-of-index rvcwd"
       (tests
        (test "the 1st index is in the 0th shell"
              e
              (assert-equal 0
                            (shell-of-index 1)))
        (test "the 2nd index is in the 1st shell"
              e
              (assert-equal 1
                            (shell-of-index 2)))
        (test "the 14th index is in the 2nd shell"
              e
              (assert-equal 2
                            (shell-of-index 14)))
        (test "the 27th index is in the 3rd shell"
              e
              (assert-equal 3
                            (shell-of-index 27)))
        (test "the 29th index is in the 4th shell"
              e
              (assert-equal 4
                            (shell-of-index 29)))
        ))

(suite "increment-2-pivot-list rvcwd"
       (tests
        (test "inc-2-pivot-list handles trivial case"
              e
              (assert-equal `(1 0)
                            (increment-2-pivot-list `(0 0))))
        (test "inc-2-pivot-list works with non-fringe cases"
              e
              (assert-equal `(5 3)
                            (increment-2-pivot-list `(5 2))))
        (test "inc-2-pivot-list works with fringe cases"
              e
              (assert-equal `(15 0)
                            (increment-2-pivot-list `(14 14))))
        ))
