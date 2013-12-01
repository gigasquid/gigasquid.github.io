---
author: gigasquid
comments: true
date: 2012-09-29 16:00:36+00:00
layout: post
slug: 7-john-mccarthy-papers-in-7-weeks-2
title: '7 John McCarthy Papers in 7 Weeks - #2'
wordpress_id: 504
categories:
- All
- John McCarthy Papers
---

Well, life threw me for a bit of a loop and delayed my post on my second paper. So I am going to consider this a "weekish" period of time and just continue on.

I read [ Towards a Mathematical Science of Computation](http://web.archive.org/web/20131014084908/http://www-formal.stanford.edu/jmc/towards/towards.html).  It is quite a meaty paper and was certainly a lot to digest.  Here are some highlights that I gleaned from it.



### How can a Mathematical Science of Computation help in a practical way?


McCarthy points out that while it is hard to predict practical applications ahead of time.  A couple of could be




  * Provide a systematic way to create of programming language.  Rather than just arguing and arbitrarily adding language features whilly nilly.

  * "It should be possible to eliminate debugging.  Debugging is the testing of a program on cases one hopes are typical, until it seems to work.  This frequently is in vain."


This last point of being able to eliminate debugging really stuck with me.  Even with the best of TDD and test suites, we as developers still struggle with the testing of programs against what we hope is "typical".  Over the past years we have improved our techniques and made our programs more robust, but it would certainly be nice to be able to prove a program correct.

If fear that even if this was possible, it would not be enough. At least in my experience, a considerable amount of debugging happens at the human level:


  * The translation of understanding of what the human product owner wants to what the software developer can understand.

  * The human product owner's understanding of what they want in the first place.


In my experience, we have just as much trouble (or even more) stating the problem for the program as we do in attempting to solve and prove that it works.

 

###  What we already know that can be applied to a Mathematical Science of Computation 







  * The existence of Turing's Universal computers

  * The existence of classes of unsolvable problems




### Perhaps a sonic screwdriver will help?


McCarthy then goes on to add another tool to the Mathematical Science of computation toolbox. He shows that conditional expressions can be defined recursively.  Then he expands this to relate to programs/computers that can be defined recursively.



### Can a man make a computer program that is as intelligent as him?


Here is the real question.  McCarthy has us consider the following problem of whether a program on a computers with unlimited memory will ever stop:

A procedure does the following




  1. If the number is in a [creative set](http://en.wikipedia.org/wiki/Creative_and_productive_sets) then return -> yes.
If a number is not in a creative set then return -> no
or it may run indefinitely

  2. There is no procedure while will always return -> yes when the answer is yes.  and return -> no when the answer is no


It is a bit depressing that we can't figure out which ones that are really no and which ones run forever.  But don't give up.  We can just try to do the best we can.  [Emil Post](http://en.wikipedia.org/wiki/Emil_Leon_Post) discovered that whenever we try to do the best we can, one can always improve upon it.  He showed that given any procedure, he could make a new procedure that solved all the previous cases plus some new ones. McCarthy pointed out that this process, even though it is really like trying to count the biggest ordinal number, can be mechanized.  So really there is no reason why a machine could not continually improve its own program.

In summary, McCarthy's own words are the best:




> "In conclusion, let me re-assert that the question of whether there are limitations in principle of what problems man can make machines solve for him as compared to his own ability to solve problems, really is a technical question in recursive function theory."








 
