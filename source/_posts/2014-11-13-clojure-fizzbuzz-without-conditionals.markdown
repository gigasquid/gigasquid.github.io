---
layout: post
title: "Clojure FizzBuzz without Conditionals"
date: 2014-11-13 21:43
comments: true
categories:
- All
- Clojure
---

{% img https://c1.staticflickr.com/5/4136/4825113119_9630b7927f.jpg %}

Sure you may have done FizzBuzz before.  Maybe you have even done it
in Clojure.  But have you done it without the use of _any_
conditionals?

As your brain starts to work on the _how_ this we be done, you might
be wondering _why_ you should do this in the first place?

There are two very good reasons for this.  The first is that it is a
_kata_.

## Katas build your code practice

{% img https://c4.staticflickr.com/4/3552/3434757877_711709da58_b.jpg %}

Code katas build your skill through practice.  It doesn't matter if
you are a beginner or an expert.  Just, like in all those martial arts
movies with the swordsman practicing, so must we.  We stretch and
flex our coding muscles with katas to grow them and keep them in shape.

Yes, you may code every day at work.  But it is not the same as kata
practice.  So much of _day to day_ work involves complexity
with large interconnected concerns.  Our  kata practice cuts the extra
complexity out and leaves you alone with a focused small problem.

The second reason involves why you
should try it, this time,  _without conditionals_.  The answer is _creativity_.

## Constraints build creativity.

It turns out that constraints are a
[key way to drive creativity](http://www.forbes.com/sites/groupthink/2013/07/12/creativity-how-constraints-drive-genius/).
Programming does not only require technical skills, but also a
creativity. We are seldom asked to build software without constraints.
It drives design.  Sure, it can be annoying when we have to communicate with
a server that is only active on Tuesday and emits its response in
Morse Code.  But it gives us boundaries to unleash our creative
spirit.


So go for it.

## Give it a try

Ready?  Here are the details.

- Given a number, if it number is divisible by 3 return "fizz".
- If it is divisible by 5 return "buzz".
- If it is divisible by 3 and 5 return "fizzbuzz".
- Otherwise, just return the number.
- Don't use any conditionals like _if_ _else_ _case_ _cond_.


When you are done, you can check out some of the other solutions. Try
not to peek until you have done your version first though.

(There are some really awesome ones so far).

_Feel free to link to yours in the comments too_ :)

## Solutions



[From @aderth](https://twitter.com/adereth/status/530740818420957184)

[From @IamDrowsy](https://twitter.com/IamDrowsy/status/530900853855899648)

[From @Bryanwoods](https://twitter.com/bryanwoods/status/530822584963584000)

[From @defndaines](https://twitter.com/defndaines/status/532368201472950272)

[From _me_](https://gist.github.com/gigasquid/dc4686e8245154482be8) 

[From @hyPiRion](https://twitter.com/hyPiRion/status/530718638064828416) -
a couple of notes for this one is that:

```clojure
(+)
;; -> 0
```
and

```clojure
(*)
;; -> 1
```

And once you think about that you might want to read :) [this](https://gist.github.com/igstan/c3797e51aa0784a5d275)

Happy Clojure Kataing!







