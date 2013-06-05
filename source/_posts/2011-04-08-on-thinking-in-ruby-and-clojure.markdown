---
author: gigasquid
comments: true
date: 2011-04-08 02:02:09+00:00
layout: post
slug: on-thinking-in-ruby-and-clojure
title: On Thinking in Ruby and Clojure
wordpress_id: 160
categories:
- Clojure
- Ruby
---

Recently, I decided to work on a set of code Katas.  I couldn't decide whether to do them in Ruby or Clojure, so I decided to do them in both.  I did the Kata in Ruby first and then immediately followed up with the same one in Clojure.  It was an interesting exercise, not only for the learning of the languages, but to highlight how I thought about the problems differently depending on the language.

Ruby is a fantastic language.  It would delight and sometimes surprise me with how elegant and natural it was to solve problems.  When I approached the Kata, I found myself thinking, “How can I make this more readable?”.   Ruby never failed to please.

Clojure is also a wonderful language.  One of the things that I really enjoy about it is that it changed that way that I approach problems.  This was particularly evident when I turned to solve the same problem in Ruby that I just had in Clojure.  First and foremost, I thought about the data.  Then about how the data could be transformed.  The transformation isn't like the serial steps that you normally take to hold the data in your hand and bit by bit mold it into the result – like a sculptor with clay.  It is the kind of transformation that takes a rolled ball of yarn and transforms into a beautiful lace pattern.

The closest that I had come to this functional way of thinking was when I was doing some heavy SQL and database work.  I went to a talk by Jay Pipes on MySQL.  I remember him saying that to be really good at SQL, you needed to think in sets.  You couldn't effectively solve the queries with the regular programming for-loop construct.  You needed to think of the sets of data joining and intersecting and the transformations needed to be applied to the data elements.  The same focus on the data seemed to hold true for Clojure too.

I highly recommend both Ruby and Clojure as programming languages.  Each are dynamic, elegant and powerful and a lot of fun.  Next time you sit down to do a Kata, and can't decide what language to use, try them both – and let me know how you think...
