---
layout: post
title: "Green Eggs and Transducers"
date: 2014-09-06 15:47
comments: true
categories:
- All
- Clojure
---

{% img http://upload.wikimedia.org/wikipedia/en/c/c2/Greenegg.gif %}

A quick tour of Clojure Transducers with core.async with Dr. Seuss as a guide.

Follow along at home by:

* `lein new green-eggs`
* modify your project.clj to include the following:
```clojure
(defproject green-eggs "0.1.0-SNAPSHOT"
  :description "try them"
  :url "http://en.wikipedia.org/wiki/Green_Eggs_and_Ham"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.7.0-alpha1"]
                 [org.clojure/core.async "0.1.338.0-5c5012-alpha"]])
```
* Start up a repl and hack in!


## Green Eggs and Ham

Transducers are a new feature of Clojure 1.7.  Instead of trying to explain them with words, let's take a look of them in action.  First we need some data.  Let's def a vector of all the places you could try green eggs and ham.

```clojure
(ns green-eggs.core
  (:require [clojure.core.async :as async]))

(def green-eggs-n-ham
  ["in the rain"
   "on a train"
   "in a box"
   "with a fox"
   "in a house"
   "with a mouse"
   "here or there"
   "anywhere"])
```

Next, let's create a function that will transform the places into a "I would not eat them ..." sentence.

```clojure
(defn i-do-not-like-them [s]
  (format "I would not eat them %s." s))

(i-do-not-like-them "in the rain")
;; -> "I would not eat them in the rain."
```

We also need a function to take this result and actually try the green eggs and ham.

```clojure
(defn try-them [s]
  (clojure.string/replace s  #" not" ""))

(try-them "I would not eat them in the rain.")
;; -> "I would eat them in the rain."
```

Now we have two transformations that we can apply to the vector of green-eggs-n-ham strings.
One of the really nice things about transducers is that you can describe and compose this transformation without a data structure present.


```clojure
(def sam-i-am-xform
  (comp
   (map i-do-not-like-them)
   (map try-them)))
```

We can run the transformation of the transducers against the data in a few ways.


* _into_: Non-lazy turn the transformation into a collection
* _sequence_: Same thing but lazy
* _transduce_: Acts like reduce on the all the transformed elements
* With _core.async_ channels doing the transformations.

Let's look at the green eggs and ham example for each one of these ways:

### Into

Into takes a transducer and collection to work on and returns the vector we asked for:

```clojure
(into [] sam-i-am-xform green-eggs-n-ham)
;; -> ["I would eat them in the rain."
;;     "I would eat them on a train."
;;     "I would eat them in a box."
;;     "I would eat them with a fox."
;;     "I would eat them in a house."
;;     "I would eat them with a mouse."
;;     "I would eat them here or there."
;;     "I would eat them anywhere."]
```

### Sequence

Sequence takes similar arguments, but as promised, returns a lazy sequence that we can interact with.

```clojure
(class (sequence sam-i-am-xform green-eggs-n-ham))
;; -> clojure.lang.LazyTransformer

(take 1 (sequence sam-i-am-xform green-eggs-n-ham))
;; -> ("I would eat them in the rain.")

```

### Transduce
If we want to finally arrange all our sentences in the vectors into one string, we would use reduce.  The way to do this with transducers is to use _transduce_.  It takes a function of two arguments to perform the reduce, as well as an initial data input.

```clojure
(transduce sam-i-am-xform #(str %1 %2 " ") "" green-eggs-n-ham)
;; -> "I would eat them in the rain.
;;     I would eat them on a train.
;;     I would eat them in a box.
;;     I would eat them with a fox.
;;     I would eat them in a house.
;;     I would eat them with a mouse.
;;     I would eat them here or there.
;;     I would eat them anywhere."
```

### Core.async

Core.async has a really nice way to define channels with a transducer that will transform each element on the channel.
 
```clojure
(def sam-i-am-chan (async/chan 1 sam-i-am-xform))
```

Let's define another channel to reduce the results of the sam-i-am-chan to a string.

```clojure
(def result-chan (async/reduce #(str %1 %2 " ") "" sam-i-am-chan))
```

Finally, let's actually put the green-eggs-n-ham data onto the sam-i-am-chan and let the data transformations flow....

```clojure
(async/onto-chan sam-i-am-chan green-eggs-n-ham)
```

At last,
we can get our result off the result channel and revel in the beauty of asynchronous data transducers.

```clojure
(def i-like-them (async/<!! result-chan))

i-like-them
;; -> "I would eat them in the rain.
;;     I would eat them on a train.
;;     I would eat them in a box.
;;     I would eat them with a fox.
;;     I would eat them in a house.
;;     I would eat them with a mouse.
;;     I would eat them here or there.
;;     I would eat them anywhere."

```

Transducers are elegant and powerful, just like the rest of Clojure.  Try them, you will like them :)

{% img http://ecx.images-amazon.com/images/I/51JqhoQCtgL.jpg %}

