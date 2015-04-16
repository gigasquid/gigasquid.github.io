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


### Music

Creating music with Clojure is a joy. The [Overtone](https://github.com/overtone/overtone) library allows you to not only make music with Clojure.  Underneath the covers, the library provides an api to the
[SuperCollider](http://supercollider.github.io/) synthesis engine.  It has a rich set of scales, chords, rhythm, as well as a metronome timing system.  One of the coolest things about Overtone, is the ability to
make music interactively.  Using the REPL, (Read-Eval-Print-Loop), a programmer can build up and create music real-time.  A wonderful example of this is a talk by [Chris Ford](https://twitter.com/ctford) on [Functional Composition](https://www.youtube.com/watch?v=Mfsnlbd-4xQ)
in where he shows off Overtone in action.  He starts off with simple principles builds up music in the REPL bit by bit.

This interactive, and collaborative nature of using Overtone was taken to new levels with [Sam Aaron](https://twitter.com/samaaron) and [Jonathan Graham](https://twitter.com/graham_jp). The combined forces to create a fantastic  _live coding_ band called [Meta-eX](http://meta-ex.com/). When performing,
the music surrounding the audience is driven by live code.  The code is front and center, being projected on a screen.  The audience watches as the code is created and modified, driving the beat and the music.  You really have to see them live to appreciate the whole experience, but here is a small excerpt from one of their live coding sessions, entitled [Machine Run](https://soundcloud.com/meta-ex/machine-run).

For live performances, Meta-eX also combines a visual element as well.  Along with displaying the code, they will also show images, colors, and shadows, that dance along with the music. Overtone has integration for two of the visual art libraries, Quil and Shadertone,  that will we explore next.

### Visual Art

One of the most well known Clojure art libraries is [Quil](https://github.com/quil/quil).  It uses [Processing](https://processing.org/reference/) to create sophisticated visual structures and artwork such as this by [Danielle Kefford/ Quephird](https://twitter.com/quephird).

{% img http://fc08.deviantart.net/fs71/i/2015/003/4/3/hedera_helix_by_quephird-d8chot2.png %}


Quil supports both Clojure and ClojureScript.  It is also well documented and provides examples of how to do [generative art](https://github.com/quil/quil-examples/blob/master/src/quil_sketches/gen_art/README.md).

[Shardertone](https://github.com/overtone/shadertone) is another lovely art library. One of the things I love about it is the integration with Overtone.  It was designed to mix the Musical Synthesis and OpenGL shaders seen in the [Shadertoy](https://www.shadertoy.com/)website.  When combined with the music of Overtone in a live-coding environment, the results are mesmerizing as in this video example by the [REPL Electric](https://vimeo.com/95988263).


People have also been experimenting with Clojure Game Platforms for visual art. This stunning pieces of visual art by [Joseph Parker](https://twitter.com/jplur_) uses the [Arcadia](https://github.com/arcadia-unity/Arcadia) library to integrate Clojure with the Unity 3D game engine.

{% img https://files.gitter.im/selfsame/hard/gSBk/003.gif %}

{% img http://selfsamegames.com/gifs/wacky/001.gif %}


Some people have even been experimenting with combining Overtone and games as art.  [Joseph Wilk](https://twitter.com/josephwilk) has been harnessing the musical beat in Overtone to generate 3D shapes in minecraft.  By embedding a Clojure REPL inside the Minecrafter server, sound creates blocks and structures in this amazing [demo](https://vimeo.com/120907923).

Finally, Clojure has enabled a cool art project whose aim is to allow anyone to be an artist.  The [Devart-Codefactory project](http://devartcodefactory.com/#/home) is an online design tool that empowers people by giving them a tool to create a complex 3d form.  There is even the chance of having their art fabricated in 3D and showcased in an art exhibition.  The tool is written in Clojure provide people to create many intricate forms seen on the [gallery](http://devartcodefactory.com/#/gallery).

Creativity is not limited to the visual and musical arts.  The written word is also used by Clojure for art to produce poetry.

### Poetry

Can computers create poetry?  With Clojure, the answer is a resounding yes.  People have used Clojure to generate [Haikus](http://jr0cket.co.uk/2012/09/clojure-poetry-in-motion-developers-get.html.html).  They have also used them to generate text using [Markov Chains](http://en.wikipedia.org/wiki/Markov_chain).  This method is trained on a set of text and them randomly generates new text and phrases with combined inputs.  A neat example of this is a Markov Chain generator that is trained on the poetry of Edward Lear's [Nonsense Books](http://www.gutenberg.org/ebooks/13650?msg=welcome_stranger) and a goodly dose of Functional Programming from Wikipedia.  The program is used by a twitter bot named [FunctionalELear](https://twitter.com/FunctionalELear), who generates _art tweets_ based off the input texts.  The artful combination of such two different spheres makes for some amusing text snippets as in the one below.

{% img http://c1.staticflickr.com/9/8748/16983522639_59a0bd68d0_b.jpg %}

So far we have covered music, visual art, and poetry.  We haven't yet mentioned dance.  But I am not talking about humans dancing with Clojure, I am talking about robots.


### Dance


### Summary 



