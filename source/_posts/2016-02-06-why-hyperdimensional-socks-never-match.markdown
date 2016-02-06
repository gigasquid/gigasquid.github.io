---
layout: post
title: "Why Hyperdimensional Socks Never Match"
date: 2016-02-06 14:26
comments: true
categories:
- Clojure
- All
---

{% img http://c2.staticflickr.com/8/7238/7188420611_a99f936971_n.jpg %}

The nature of computing in hyperdimensions is a strange and wonderful place.   I have only started to scratch the surface by reading a paper by [Kanerva](http://redwood.berkeley.edu/pkanerva/papers/kanerva09-hyperdimensional.pdf). Not only is it interesting from a computer science standpoint, it's also interesting from a cognitive science point of view.  In fact, it could hold the key to better model AI and general reasoning.  This blog is a casual stroll through the main points of Kanerva's paper along with examples in Clojure to make it tangible.  First things first, what is a hyperdimension?

### What is a Hyperdimension and Where Are My Socks?

When we are talking about hyperdimensions, we are really talking about _lots_ of dimensions.  You can have a vector with dimensions as well.  A regular vector could have three dimensions `[0 1 1]`, but a hyperdimensional vector has tons more, like 10,000 or 100,000.  We call these big vectors _hypervectors_ for short, which makes them sound really cool. Although the vectors could be make up of anything, we are going to use vectors made up of zeros and ones.  To handle big computing with big vectors in a reasonable amount of time, we are also going to use _sparse_ vectors.  What makes them sparse is that most of the space is empty, (zeros).  In fact, Clojure has a nice library to handle these sparse vectors.  The [core.matrix](https://github.com/mikera/core.matrix) project from Mike Anderson is what we will use in our examples.  Let's go ahead and make some random hypervectors.

First we import the core.matrix libraries and set the implementation to vectorz which provides fast double precision vector math.

```clojure
(ns hyperdimensional-playground.core
  (:require [clojure.core.matrix :as m]
            [clojure.core.matrix.linear :as ml]))

(m/set-current-implementation :vectorz)
```

Next we set the sz of our hypervectors to be 100,000.  We also create a function to generate a random sparse hypervector, by choosing to put ones in about 10% of the space.

```clojure
(def sz 100000)

(defn rand-hv []
  (let [hv (m/new-sparse-array [sz])
        n (* 0.1 sz)]
    (dotimes [i n]
      (m/mset! hv (rand-int sz) 1))
    hv))
```

Now we can generate some.

```clojure
(def a (rand-hv))
(def b (rand-hv))
(def c (rand-hv))
(def d (rand-hv))

a ;=> #vectorz/vector Large vector with shape: [100000]
```

You can think of each of this hypervectors as random hyperdimensional sock, or hypersock, because that sounds cooler.  These hypersocks, have curious properties.  One of which, is that they will ~never match.

### Hypersocks never match

Because we are dealing with huge amount of dimensions, a mathematically peculiar probability distribution occurs.  We can take a random hypervector to represent something, then take another one and they will different from each by about 100 STD. We can take another one and it too, will be 100 STD from the other ones.  For practical purpose, we will run out of time before we will run of vectors that are unrelated.  Because of this, any two hypersocks will never match each other.

How can we tell how similar two hypersocks are?  You can use the cosine to tell the similarity between two vectors.  This is determined by the dot product.  We can construct a [cosine similarity](https://en.wikipedia.org/wiki/Cosine_similarity) function to give us a value from -1 to 1 to measure how alike they are with 1 being the same and -1 being the complete opposite.

```clojure
defn cosine-sim [v1 v2]
  (/ (m/dot v1 v2)
     (* (ml/norm v1) (ml/norm v2))))
```

If we looks at the similarity of a hypervector with itself, the result is ~1.  We the other random hypervectors, it is ~0.

```clojure
(cosine-sim a a) ;=>  1.0
(cosine-sim d d) ;=> 1.0

(cosine-sim a b) ;=>  0.0859992468320239
(cosine-sim b c) ;=> 0.09329186588790261
(cosine-sim a c) ;=> 0.08782018973001954
```

There are other cool things we can do with hypervectors, like do math with them.

### The Hamming Distance of Two Hypersocks

We can add hypervectors together with a sum mean vector. We add the vector of 1s and 0s together then we divide the resulting vector by the number of total vectors.  Finally, to get back to our 1s and 0s, we round the result.

```clojure
(defn mean-add [& hvs]
  (m/emap #(Math/round (double %))
   (m/div (apply m/add hvs) (count hvs))))
```

The interesting thing about addition is that the result is similar to all the vectors in it.  For example, if we add a and b together to make x, `x = a + b`, then x will be similar to a and similar to b.

```clojure
;; x = a + b
(def x (mean-add a b))
(cosine-sim x a) ;=> 0.7234734658023224
(cosine-sim x b) ;=> 0.7252586504505658
```

You can also do a very simple for of multiplication on vectors with 1s and 0s with using _XOR_.  We can do this by add the two vectors together and then mapping `mod 2` on each of the elements.

```clojure
(defn xor-mul [v1 v2]
  (->> (m/add v1 v2)
      (m/emap #(mod % 2))))
```

We can actually use this `xor-mul` to calculate the [Hamming distance](https://en.wikipedia.org/wiki/Hamming_distance), which is an important measure of error detection.  The Hamming distance is simply the sum of all of the xor multiplied elements.

```clojure
(defn hamming-dist [v1 v2]
  (m/esum (xor-mul v1 v2)))

(hamming-dist [1 0 1] [1 0 1]) ;=> 0
(hamming-dist [1 0 1 1 1 0 1] [1 0 0 1 0 0 1]) ;=> 2
(hamming-dist a a) ;=> 0
```

This illustrates a point that xor multiplication randomizes the hypervector, but preserves the distance.  In the following example, we xor multiply two random hypervectors by another and the hamming distance stays the same.

```clojure
; xa = x * a
; ya = y * a
; hamming distance of xa is the same as ya


;; multiplication randomizes but preserves the distance
(def x (rand-hv))
(def y (rand-hv))
(def xa (xor-mul x a))
(def ya (xor-mul y a))
(hamming-dist xa ya) ;=> 1740.0
(hamming-dist x y) ;=> 1740.0
```

So you can xor multiply your two hypersocks and move them to a different point in hyperspace, but they will still be the same distance apart.

Another great party trick in hyperspace, is the ability to bind and unbind hypervectors for use as map like pairs.

### Using Hypervectors to Represent Maps

A map of pairs is a very important data structure.  It gives the ability to bind symbols to values and then retrieve those values.  We can do this with hypervectors too.  Consider the following structure:

```clojure
{:name "Gigasquid'
 :cute-animal "duck"
 :favorite-sock "red plaid"}
```

We can now create hypervectors to represent each of these values.  Then we can xor the hypervector symbol to the hypervector value and sum them up.

```clojure
;; data records with bound pairs
(def x (rand-hv)) ;; favorite-sock
(def y (rand-hv)) ;; cute-animal
(def z (rand-hv)) ;; name
(def a (rand-hv)) ;; red-plaid
(def b (rand-hv)) ;; duck
(def c (rand-hv)) ;; gigasquid

;H = X * A + Y * B + Z * C
(def h (mean-add (xor-mul x a) (xor-mul y b) (xor-mul z c)))
```

Now, we have a sum of all these things and we want to find the value of the _favorite sock_.  We can _unbind_ it from the sum by xor multiplying the favorite-sock hypervector `x`.  Because of the property that xor multiplication both distributes and cancels itself out.

```clojure
(hamming-dist (xor-mul x (xor-mul x a)) a) ;=> 0
```

We can compare the result with the known values and find the closest match.

```clojure
(hamming-dist a (xor-mul x h)) ;=> 1462.0  ;; closest to "red-plaid"
(hamming-dist b (xor-mul x h)) ;=> 1721.0
(hamming-dist c (xor-mul x h)) ;=> 1736.0

(cosine-sim a (xor-mul x h)) ;=> 0.3195059768353112 ;; closest to "red-plaid"
(cosine-sim b (xor-mul x h)) ;=> 0.1989075567830733
(cosine-sim c (xor-mul x h)) ;=> 0.18705233578983288
```

### Conclusion

We have seen that the nature of higher dimensional representation leads to some very interesting properties with both representing data and computing with it.  These properties and others form the foundation of exciting advancements in Cognitive Computing like word vectors.  Future posts will delve further into these interesting areas.  In the meantime, I encourage you to read Kanerva's paper on your own and to find comfort in that when you can't find one of your socks, it's not your fault. It most likely has something to do with curious nature of hyperspace.


_Thanks to [Ross Gaylor](https://twitter.com/ross_gayler) for bringing the paper to my attention and to [Joe Smith](https://twitter.com/solussd) for the great conversations on SDM_
