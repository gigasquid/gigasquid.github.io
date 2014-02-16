---
layout: post
title: "Hitchhiker's Guide to Clojure - Part 3"
date: 2014-02-15 13:48
comments: true
categories:
- All
- Clojure
- Hitchhiker's Guide to Clojure
---

Amy and Frank ran down the stairs of her work, but came to an
unexpected stop at the side door to the parking lot.  It was locked.  As
they peered out the window, they saw yesterday's Amy pull up in the
parking space, get out and retrieve her laptop, and start to head in
the front door.

"Oh good, we can take your car", said Frank.

Amy took a second to recover from the shock of seeing what her hair really
looked like from behind and then asked, "How can we get to the car?  The door is locked, and we
can't go back up to the office. I would meet myself."

Frank smiled, pulled out the _Hitchhiker's Guide to Clojure_ and
pulled up a page with the heading _Locked Doors and Other Small
Bothers_.

{% img http://farm4.staticflickr.com/3346/3191331375_a773bff1b7_n.jpg %}



_One of the reasons for the surprising success of **The Hitchhiker's Guide
to Clojure** is helpful advice of on an assortment of practical
matters._

_Locked doors are a common nuisance in modern times.  Fortunately,
Clojure provides a very handy function for such occasions [fnil](http://clojuredocs.org/clojure_core/1.2.0/clojure.core/fnil).
This commonly overlooked function, takes an existing function and
returns a new function that allows you to specify a default
for a nil parameter. For example, take this locked door:_


```clojure
(defn locked-door [key]
        (if key "open" "nope - staying shut"))

(locked-door :key) ;=> "open"
(locked-door nil) ;=> "nope - staying shut"
```

_Don't worry, simply apply the fnil and what you really want to happen when you
don't have the key, and you will be on your way._

```clojure
(def this-door (fnil locked-door :another-key-that-works))
 
(this-door :key) ;=> "open"
(this-door nil) ;=> open
```

They unlocked the door and headed for Amy's car.  She couldn't decide
whether she was surprised or not to find her keys in her pocket, so
she gave up and just got in instead.  After a short drive, they
arrived at the zoo and navigated their way through various
school groups and arrive at the Aquarium.

Amy at this point, having prided herself on her adaptable nature, was
still having trouble processing the latest events. She had
discovered that Frank was a Datomic time traveller,  the  world was
made of Clojure, and it was also about to be destroyed in a short
future that she just came from.  Her rational brain, (which was
currently working way too hard), was quite
relieved to be distracted by the sight of two really adorable otters.  They were floating
contentedly around the pool, occasionally stopping to crack an Abalone
shell on their fuzzy tummies.

{% img http://cdn.zmescience.com/wp-content/uploads/2012/09/sea-otters.jpg %}

Her rational brain, after having a nice breather, finally re-asserted
itself and made Amy ask Frank:

"Why are we here?"

"Otters are the front-line Chrono-guards, of course."

He went on to explain that otters are tasked with the important job of
keeping a close watch on human civilization and making critical, minor
adjustments to keep things on an even track.  All those nature videos
of otters cracking shells with rocks?  They are really evaluating
crucial Clojure expressions to our way of life. Most of the time, they
prefer to do their work remote.  They find floating on their backs in
the peaceful waters the most productive work environment.  However,
sometimes they will construct zoos or aquariums, when their work
requires them to keep a closer watch on some areas.  In times of great
need, they might even take a human form for a short while.  Recently,
one of their agents was inadvertently
[exposed](https://i.chzbgr.com/maxW500/6003866624/h0B1E03BF/) and
required a few extra Abalone shells to straighten out.

Frank then opened his pack and handed his evaluator to Amy to hold
while fished out four mini-marshmallows.  He gave two to Amy and then
proceeded to put one in his ear and the other in his mouth.  More
remarkably still, he appeared to be speaking with the otters.

_Mini-marshmallows are the best way to create portable Clojure
[core.async](https://github.com/clojure/core.async) channels that
won't melt in your hands.

To construct a channel simply use *chan*

```clojure
(def talk-to-otters-chan (chan))
```

Channels by default are unbuffered, which keeps them at the
mini-marshmallow size.  It requires a rendezvous of someone to talk to
the otters and the otters to listen. In fact if we try to talk to
an otter - it would block the main thread until the otter got
around to listening.  This would be very boring for the talker if the
otter was busy, so one approach would be to use a
[future](http://clojuredocs.org/clojure_core/clojure.core/future) to
talk to the otter with a blocking put *>!!*.

```clojure
(future (>!! talk-to-otters-chan "Hello otters.")) ;=>#<Future@3c371c41: :pending>
(<!! talk-to-otters-chan) ;=> "Hello otters."
```

One could also use a buffered channel, but that increases the size of
the marshmallow.

```clojure
(def talk-to-otters-chan (chan 10)) ;;create channel with buffer size 10
(>!! talk-to-otters-chan "Hello otters.") ;=> nil
(>!! talk-to-otters-chan "Do you know anything about the world ending?") ;=> nil

(<!! talk-to-otters-chan) ;=> "Hello otters."
(<!! talk-to-otters-chan) ;=> "Do you know anything about the world ending?"
```

The best way to conserve space and time is to use asynchronous
communication with *go* blocks that wont' block our threads. Inside
these go blocks we can use regular non-blocking puts *>!* and gets
*<!*.

```clojure
(def talk-to-otters-chan (chan))
(go (while true
      (println (<! talk-to-otters-chan))))
(>!! talk-to-otters-chan "Hello otters")
(>!! talk-to-otters-chan "Do you know anything about the world ending?")
(>!! talk-to-otters-chan "Also, you are really fuzzy and cute.")
 
;; (This prints out in the REPL as you talk to the otters)
Hello otters
Do you know anything about the world ending?
Also, you are really fuzzy and cute.
```

This compact, lightweight, and asynchronus method of communication is
well suited to conversations and messaging of all sorts, including
conversing with otters.

```clojure
(def talk-chan (chan))
(def listen-chan (chan))
(go (while true
      (println (<! listen-chan))))
(go (while true
      (>! listen-chan
          (str "You said: "(<! talk-chan)
                " " "Do you have any Abalone?" ))))
(>!! talk-to-otters-chan "Hello otters")
(>!! talk-to-otters-chan "Do you know anything about the world ending?")
(>!! talk-to-otters-chan "Also, you are really fuzzy and cute.")
 
;; (This prints out in the REPL as you talk to the otters)
You said: Hello otters Do you have any Abalone?
You said: Do you know anything about the world ending? Do you have any Abalone?
You said: Also, you are really fuzzy and cute. Do you have any Abalone?
```

Amy put one of the mini-marshmallows in her ear.  She immediately
began to hear the conversation that Frank was having with the otters.

"But who would want to destroy the entire world?  That is really kinda
over-board."

"I don't really know, but there was someone on Galactic Hacker News
the other day that was quite tiffed over the idea that Clojure was considered
a Lisp."

Amy reached to put the other marshmallow in her mouth to ask a very
important question.  But unfortunately, as she moved her hand, she
accidentally pushed the big red *Source* button on the evaluator.
Suddenly, she and Frank were swept up in a vortex that spun them
around and sucked them down into the ground.






