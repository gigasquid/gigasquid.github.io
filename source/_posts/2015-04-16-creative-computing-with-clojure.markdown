---
layout: post
title: "Creative Computing with Clojure"
date: 2015-04-16 09:09
comments: true
categories: 
---

Clojure is gaining more and more traction and popularity as a programming language.  Both enterprises and startups are adopting this functional language because of the simplicity,
elegance, and power that it brings to their business.  The language originated on the JVM, but has since spread to run on the CLR, Node.js, as well as web browsers and mobile devices.
Alongside the spread of practical innovation that has followed, there has also been another delightful development, a groundswell of people making art with Clojure.

## Creative Computing with Clojure

Creative computing combines the power and engineering of the computer with the artistic inspirations of humans.  People are using Clojure as a tool to generate music, visual art, poetry, and
even dance.  This ability to harness technology for creative purposes is both exciting and important.  For it not only touches the heart and inspires existing technologists, but it also
transcends all barriers.  Art is a gateway to bring new people, young and old, from all walks of life,  to programming.

This article will explore some of the areas of Creative Computing with Clojure, and showcase some inspiring examples from artists. On our journey, we will touch on music, art, games, writing, and even robots.
The field of artistic expression is very large, and we can only hope to scratch the surface.  But we will attempt to highlight some libraries and tools in each area that will provide a jumping off point
to those that are inspired.

We start our tour with the realm of music.


### Music and Clojure

Creating music with Clojure is a joy. The [Overtone](https://github.com/overtone/overtone) library allows you to not only make music with Clojure.  Underneath the covers, the library provides an api to the
[SuperCollider](http://supercollider.github.io/) synthesis engine.  It has a rich set of scales, chords, rhythm, as well as a metronome timing system.  One of the coolest things about Overtone, is the ability to
make music interactively.  Using the REPL, (Read-Eval-Print-Loop), a programmer can build up and create music real-time.  A wonderful example of this is a talk by [Chris Ford](https://twitter.com/ctford) on [Functional Composition](https://www.youtube.com/watch?v=Mfsnlbd-4xQ)
in where he shows off Overtone in action.  He starts off with simple principles builds up music in the REPL bit by bit.

This interactive, and collaborative nature of using Overtone was taken to new levels with [Sam Aaron](https://twitter.com/samaaron) and [Jonathan Graham](https://twitter.com/graham_jp). The combined forces to create a fantastic  _live coding_ band called [Meta-eX](http://meta-ex.com/). When performing,
the music surrounding the audience is driven by live code.  The code is front and center, being projected on a screen.  The audience watches as the code is created and modified, driving the beat and the music.  You really have to see them live to appreciate the whole experience, but here is a small excerpt from one of their live coding sessions, entitled [Machine Run](https://soundcloud.com/meta-ex/machine-run).

For live performances, Meta-eX also combines a visual element as well.  Along with displaying the code, they will also show images, colors, and shadows, that dance along with the music. Overtone has integration for two of the visual art libraries that will we explore next.

#### Visual Art and Clojure

One of the most well known Clojure art libraries is [Quil](https://github.com/quil/quil).  




