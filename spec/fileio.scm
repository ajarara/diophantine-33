;; TEST FILE
(load "../fileio.scm")
(use-modules (ggspec lib))

(suite "procedures that read files work as expected"
       (tests
        (test "last-line-of-file does just that"
              e
              (assert-equal "And drunk the milk of Paradise"
                            (last-line-of-file (open-file "spec/text/xanadu" "r"))))
        (test "last-line-of-file raises error when given empty file"
              e
              (assert-true (error? (last-line-of-file (open-file "spec/text/empty" "r")))))
        ))
