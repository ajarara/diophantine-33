;; TEST FILE
(load "../diophantine-3d.scm")
(use-modules (ggspec lib))

(suite "2+ increments numbers by 2"
       (tests
	 (test "2+ works on trivial entry"
	       e
	       (assert-equal 2
			     (2+ 0)))
	 (test "2+ works on negative numbers"
	       e
	       (assert-equal -1
			     (2+ -3)))
	 (test "2+ works on positive numbers"
	       e
	       (assert-equal 5
			     (2+ 3)))
	 ))

(suite "applying upper-mod to a number gives us a number of the same parity as the original number, s.t. 0 < the new number <= 2"
       (tests
	 (test "upper-mod odd num gives 1"
	       e
	       (assert-equal 1
			     (upper-mod 5253451)))
	 (test "upper-mod even num gives 2"
	       e
	       (assert-equal 2
			     (upper-mod 757456724534)))
	 ))

(suite "increment-3-pivot-list takes a list and increments it with the enumeration scheme provided in the description of the dio-3d file a directory below this one"
       (tests
	 (test "inc-3-pivot-list moves up to the next pivot on completion of the all odd solution attempts"
	       e
	       (assert-equal `(7 2 2)
			     (increment-3-pivot-list `(5 5 5))))
	 (test "inc-3-pivot-list moves to the odd solutions after all evens have been exhausted"
	       e
	       (assert-equal `(13 1 1)
			     (increment-3-pivot-list `(13 12 12))))
	 (test "inc-3-pivot-list handles intra-pivot inc well, odd case, 3rd element"
	       e
	       (assert-equal `(15 7 5)
			     (increment-3-pivot-list `(15 7 3))))
	 (test "inc-3-pivot-list handles intra-pivot inc well, odd case, 2nd element"
	       e
	       (assert-equal `(23 15 1)
			     (increment-3-pivot-list `(23 13 13))))
	 ))


(suite "cube-list supersizes our lists"
       (tests
	 (test "works with trivial list"
	       e
	       (assert-equal `(0 0 0)
			     (cube-list `(0 0 0))))
	 (test "works with semi-trivial list"
	       e
	       (assert-equal `(1 1 1)
			     (cube-list `(1 1 1))))
	 (test "works with actual numbers"
	       e
	       (assert-equal `(27 125 216)
			     (cube-list `(3 5 6))))
	 ))

(suite "identify-list suite"
       (tests
	 (test "given a distinct list we get the distinct map"
	       e
	       (assert-equal distinct-map
			     (identify-list `(8 6 3))))
	 (test "given a 1,2-dup we get the 1,2-dup-map"
	       e
	       (assert-equal 1,2-dup-map
			     (identify-list `(101 101 3))))
	 (test "given a 2,3-dup we get the 2,3-dup-map"
	       e
	       (assert-equal 2,3-dup-map
			     (identify-list `(250 105 105))))
	 (test "given a triplet, we get the triplet-map"
	       e
	       (assert-equal triplet-map
			     (identify-list `(6 6 6)))) ; the NUMBER of the BEAST
	 ))

