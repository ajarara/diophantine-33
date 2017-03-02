# Diophantine-33
Inspired by [this numberphile video](https://www.youtube.com/watch?v=wymmCdLdPvM), this project was one of my first strange excursions into functional programming.

The aim of the game was to iterate through 3-space as efficiently as possible (please hold your eyerolls within the vehicle for the duration of the ride), trying to find the solution to this equation:

``` math
a^3 + b^3 + c^3 = 33
```

A simple proof clearly shows that all numbers of the form 9n±(4,5) have no such solution:

The residue of a positive number modulo n is whatever is left after removing n from it until the new number is between 0 and n - 1 inclusive.

Further modular arithmetic is simply adding numbers between 0 and n-1, and then removing n until it falls under the range. 8 mod 9 + 4 mod 9 is 12 mod 9, which is really 3 mod 9.

Every integer, when cubed, has a residue of 1, 0, or 8 modulo 9 (the proof of [this is easy][], but I'm taking it for granted here). So adding three numbers can never get you a residue of 4 or 5. The residue of any number of the form 9n±(4,5) is in fact 4 or 5.

[this is easy]: https://en.wikipedia.org/wiki/Cube_(algebra)#Base_ten

So we know for a fact there is no integer solution to 4, 5, 13, 14, 22, 23.. etc.

But no one has found such a proof for 33, or a solution for it.

# Motive for this repo
This code was an attempt to find it, until I got a first hand account of how algorithms like the one encoded here scale: traversing R^3 is terribly unexciting after the first 10,000.

Initially me and my complex analysis professor stripped out lots of values pertaining to the parity (only two or none may be even, for example). But asking my graph theory professor uncovered something rather pertinent, that you can find eliminate most trials by realizing any integer cubed mod 33 has the same residue as everything in its equivalence class (which I guess is obvious when you say it that way, but I do recall spending some time proving it).

Anyway, while I found exploration of that aspect interesting (for example, there is a bijection between equivalence classes and the residues of the numbers (in that equivalence class) cubed mod 33), it _still_ isn't a linear time algorithm. The mathematician in the video had checked everything under 10^14. There was no way I could get anywhere close to that on a Debian VPS.

But of course writing this taught me a lot. After a while, I wanted to watch my algorithm in action, and I wrote in some non-blocking code (when I really should've been looking for a concurrency module) to check for activity in stdin. That way I could monitor progress. I remember being giddy showing my math professor how fast it threw out numbers.


# Plans for a rewrite
It's not likely.

As I was going through SICP at the time, I was (and still am) enamored with tail call optimization. Everything in here tries to embody that, even the interface is tail call optimized, in that every call to display something also carries state with it, which is eventually passed back to silent, traditional computing.

If I were to rewrite this, I would absolutely do it in Racket, specifically because their docs on concurrency are very clear over Guile's. I don't intend to use concurrency for speed or threading, instead I would use it to provide a sane interface to the program state. 

In order to 'see' it, though, I'd have to deposit the last set of trials in some shared state, which as far as I can tell can't be done functionally. Perhaps I'd even do it in Python, instead.

However there really is no reason to write this over if I do not have a linear time algo. I think about it from time to time, and sometimes I fill a page with thoughts, but so far I haven't cracked it. Maybe someday :)
