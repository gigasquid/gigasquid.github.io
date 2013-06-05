---
author: gigasquid
comments: false
date: 2011-03-01 02:43:29+00:00
layout: post
slug: bowling-game-kata-in-clojure-with-stm-and-defrecord
title: Bowling Game Kata in Clojure with STM and defrecord
wordpress_id: 151
categories:
- Clojure
---

We took our kids bowling for the first time the other day. I have to admit, that I am not a great bowler. I had only been bowling two or three times in my life previous to that event and I was very thankful that those bumpers were up. The computer program malfunctioned in the final frames of our last game. I realized then, that I really had no idea how to score bowling. Later that night, in my surfing, I came across a reference to the [Bowling Game Kata](http://butunclebob.com/ArticleS.UncleBob.TheBowlingGameKata).

Such Kata serendipity could not be ignored. I decided to implement it in Clojure using defrecords to mimic the object model with Frames and the Game and use STM to keep the state of the Game in an atom. Finally, the unit tests are using [Midje](https://github.com/marick/Midje) facts – which has a syntax that I enjoy.

All in all, it was a great learning exercise and as a bonus... I know how to score a bowling game now!
