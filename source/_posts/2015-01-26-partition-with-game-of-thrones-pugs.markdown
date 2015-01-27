---
layout: post
title: "Partition with Game of Thrones Pugs"
date: 2015-01-26 18:55
comments: true
categories:
- All
- Clojure
---

Clojure's _partition_ and _partition-all_ functions are very useful.
However, I have been bitten a few times using _partition_ when I
really wanted _partition-all_.  So to help myself and all of you to
remember it, I have made some diagrams with [pugs from the Game of Thrones](http://www.designswan.com/archives/the-pugs-of-westeros-cute-pugs-dressed-up-like-characters-in-game-of-thrones.html)

In code, [partition](http://clojuredocs.org/clojure.core/partition) takes a collection and returns a lazy sequence of
lists, each containing n items.

To demonstrate this with pugs, we will partition 5 pugs into groups of
twos.

{% img  https://c4.staticflickr.com/8/7301/15757758964_570d260a31_c.jpg %}


This partition will give you two groups of two pugs.

{% img https://c4.staticflickr.com/8/7350/16380203235_91c8c4e9ee_c.jpg %}

Notice, (and here is the important part), the last pug is missing.  The Joffrey pug is not included because _partition_ will not include items that do not make a complete partition.  In this case, because there is no group of 2 pugs for the Joffrey pug to be in, it gets dropped.

_This is the thing that has bitten me in the past._

A common use for wanting to partition things is to control the number
of things that you process at one time.  An example of this is sending only 500 items to be processed in a batch job at one time.  If you have a few thousand items to be processed, partitioning them is a good way of chuncking.  However, if you have an arbitrary number of items, you most certainly want to process them _all_ and not drop any.  This is where you should use _partition-all_ instead.

[Partition-all](http://clojuredocs.org/clojure.core/partition-all) chunks the items as well, but also includes any leftovers.  Demonstrating again with pugs.

{% img  https://c4.staticflickr.com/8/7427/15757758884_20bfd014eb_c.jpg %}

This _partition-all_ will give you three groups of pugs.

{% img  https://c4.staticflickr.com/8/7323/16193980179_229343f7f3_c.jpg %}

This time pug Joffrey is not left out!


Remember, think carefully before using _partition_.  Don't leave a pug out.

By the way, I can't wait till the next season of Game of Thrones.  Until then ..

{% youtube 2EoQCtPR2-I %}



