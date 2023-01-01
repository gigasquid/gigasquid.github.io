---
layout: post
title: "Vector Symbolic Architectures in Clojure"
date: 2022-12-31 15:41
comments: true
categories:
- All
- Clojure
- AI
---

![](https://live.staticflickr.com/65535/52596142860_c4cf8642b0_z.jpg)

_generated with Stable Diffusion_

Before diving into the details of what Vector Symbolic Architectures are and what it means to implement Clojure data structures in them, I'd like to start with some of my motivation in this space.

## Small AI for More Personal Enjoyment

Over the last few years, I've spent time learning, exploring, and contributing to open source deep learning. It continues to amaze me with its rapid movement and achievements at scale. However, the scale is really too big and too slow for me to enjoy it anymore.

Between work and family, I don't have a lot of free time. When I do get a few precious hours to do some coding _just for me_, I want it it to be small enough for me to fire up and play with it in a REPL on my local laptop and get a result back in under two minutes.

I also believe that the current state of AI is not likely to produce any more  meaningful *revolutionary* innovations in the current mainstream deep learning space. This is not to say that there won't be advances. Just as commercial airlines transformed the original first flight, I'm sure we are going to continue to see the transformation of society with current big models at scale - I just think the next leap forward is going to come from somewhere else. And that somewhere else is going to be *small* AI.

## Vector Symbolic Architures aka Hyperdimensional Computing

Although I'm  talking about small AI,  VSA or Hyperdimensional computing is based on really big vectors - like 1,000,000 dimensions. The beauty and simplicity in it is that everything is a hypervector - symbols, maps, lists. Through the [blessing of high dimensionality](http://rctn.org/vs265/kanerva09-hyperdimensional.pdf), any random hypervector is mathematically guaranteed to be orthogonal to any other one. This all enables some cool things:

- Random hypervectors can be used to represent symbols (like numbers, strings, keywords, etc..)
- We can use an algebra to operate on hypervectors: _bundling_ and _binding_ operations create new hypervectors that are compositions of each other and can store and retrieve key value pairs. These operations furthermore are _fuzzy_ due to the nature of working with vectors. In the following code examples, I will be using the concrete model of [MAP (Multiply, Add, Permute)](https://redwood.berkeley.edu/wp-content/uploads/2021/08/Module2_VSA_models_slides.pdf) by [R. Gayler](https://www.rossgayler.com/).
- We can represent Clojure data structures such as maps and vectors in them and perform operations such as `get` with probabilistic outcomes.
- Everything is a hypervector! I mean you have a keyword that is a symbol that is a hypervector, then you bundle that with other keywords to be a map. The result is a single hypervector. You then create a sequence structure and add some more in. The result is a single hypervector. The simplicity in the algebra and form of the VSA is beautiful - not unlike LISP itself. Actually, [P. Kanerva thought that a LISP could be made from it](https://redwood.berkeley.edu/wp-content/uploads/2021/08/Neubert2019_Article_AnIntroductionToHyperdimension.pdf). In my exploration, I only got as far as making some Clojure data structures, but I'm sure it's possible.

## Start with an Intro and a Paper

A good place to start with Vector Symbolic Architectures is actually the paper referenced above - [An Introduction to Hyperdimensional Computing for Robots](https://redwood.berkeley.edu/wp-content/uploads/2021/08/Neubert2019_Article_AnIntroductionToHyperdimension.pdf). In general, I find the practice of taking a paper and then trying to implement it a great way to learn.

To work with VSAs in Clojure, I needed a high performing Clojure library with tensors and data types. I reached for [https://github.com/techascent/tech.datatype](https://github.com/techascent/tech.datatype). It could handle a million dimensions pretty easily on my laptop.

To create a new hypervector - simply chose random values between -1 and 1. This gives us a direction in space which is enough.

```clojure
;; Uses Gaylor Method for HDV Operations

(def size 1e6)  ; big enough for the "Blessing of Dimensionality"

(defn binary-rand
  "Choose a random binary magnitude for the vector +1 or -1"
  []
  (if (> (rand) 0.5) -1 1))


(defn hdv
  "Create a random hyperdimensional vector of default size"
  []
  (dtt/->tensor (repeatedly size #(binary-rand)) :datatype :int8))
```

The only main operations to create key value pairs is addition and matrix multiplication.

Adding two hyperdimensional vectors, (hdvs), together is calling bundling. Note we clip the values to 1 or -1. At high dimensions, only the direction really matters not the magnitude.

```
(defn clip
  "Clips the hyperdimensional vector magnitude to 1 or -1.
   We can discard these because of the nature of the large vectors
   that the mangitudes do not matter"
  [v]
  (-> v
      (dtype-fn/min 1)
      (dtype-fn/max -1)))


(defn bundle
  "Adds two hyperdimensional vectors together into a single bundle"
  [v1 v2]
  (-> (bundle-op v1 v2)
      (clip)))
```

We can assign key values using `bind` which is matrix multiplication.

```clojure
(defn bind
  "Binds two HDVs using the multiplication operator. This binding is akin to assigning a symbol to a value. "
  [v1 v2]
  (dtype-fn/* v1 v2))
```

One cool thing is that the binding of a key value pair is also the inverse of itself. So to unbind is just to bind again.

The final thing we need is a cleanup memory. The purpose of this is to store the hdv somewhere without any noise. As the hdv gets bundled with other operations there is noise associated with it. It helps to use the cleaned up version by comparing the result to the memory version for future operations. For Clojure, this can be a simple atom.


Following along the example in the paper, we reset the cleanup memory and add some symbols.

```clojure
(vb/reset-hdv-mem!)

(vb/add-hdv! :name)
(vb/add-hdv! "Alice")
(vb/add-hdv! :yob)
(vb/add-hdv! 1980)
(vb/add-hdv! :high-score)
(vb/add-hdv! 1000)
```

Next we create the key value map with combinations of `bind` and `bundle`.

```clojure
(def H
  (-> (vb/bind (vb/get-hdv :name) (vb/get-hdv "Alice"))
      (vb/bundle
        (vb/bind (vb/get-hdv :yob) (vb/get-hdv 1980)))
      (vb/bundle
        (vb/bind (vb/get-hdv :high-score) (vb/get-hdv 1000)))))
```

So `H` is just one hypervector as a result of this. We can then query it. `unbind-get` is using the `bind` operation as inverse. So if we want to query for the `:name` value, we get the `:name` hdv from memory and do the `bind` operation on the `H` data structure which is the inverse.

```clojure
(vb/unbind-get H :name)


;; ["Alice" #tech.v3.tensor<int8>[1000000]
;;  [-1 1 1 ... 1 -1 -1]]
```

We can find other values like `:high-score`.

```clojure
(vb/unbind-get H :high-score)


;;  [1000 #tech.v3.tensor<int8>[1000000]
;; [-1 -1 1 ... -1 1 1]]
```

Or go the other way and look for `Alice`.

```clojure
(vb/unbind-get H "Alice")


;; [:name #tech.v3.tensor<int8>[1000000]
;; [-1 1 -1 ... -1 -1 -1]]
```

Now that we have the fundamentals from the paper, we can try to implement some Clojure data structures.


## Clojure Data Structures in VSAs

First things first, let's clear our cleanup memory.

```clojure
(vb/reset-hdv-mem!)
```

Let's start off with a map, (keeping to non-nested versions to keep things simple).

```clojure
(def our-first-vsa-map (vd/clj->vsa {:x 1 :y 2}))
```

The result is a 1,000,000 dimension hypervector - but remember all the parts are also hypervectors as well. Let's take a look at what is in the cleanup memory so far.

```clojure

@vb/cleanup-mem


;; {:x #tech.v3.tensor<int8>[1000000][1 -1 1 ... 1 -1 -1],
;;  1 #tech.v3.tensor<int8>[1000000][1 1 -1 ... -1 -1 -1],
;;  :y #tech.v3.tensor<int8>[1000000][1 1 -1 ... 1 1 1],
;;  2 #tech.v3.tensor<int8>[1000000][-1 -1 -1 ... -1 -1 1]}
```

We can write a `vsa-get` function that takes the composite hypervector of the map and get the value from it by finding the closest match with cosine similarity to the cleanup memory.


```clojure
(vd/vsa-get our-first-vsa-map :x)


;; =>  [1 #tech.v3.tensor<int8>[1000000][1 1 -1 ... -1 -1 -1]
```

In the example above, the symbolic value is the first item in the vector, in this case the number 1, and the actual hypervector is the second value.

We can add onto the map with a new key value pair.

```clojure
(def our-second-vsa-map (vd/vsa-assoc our-first-vsa-map :z 3))

(vd/vsa-get our-second-vsa-map :z)


;; =>  [3 #tech.v3.tensor<int8>[1000000][1 -1 1 ... -1 -1 1]]
```

We can represent Clojure vectors as VSA data structures as well by using the permute (or rotate) and adding them like a stack.


```clojure
(def our-first-vsa-vector-of-maps (vd/clj->vsa [{:x 1} {:x 2 :y 3}]))


;; We can get the value of x in the 2nd map by
(vd/vsa-get our-first-vsa-vector-of-maps :x {:idx 1})


;; [2 #tech.v3.tensor<int8>[1000000][-1 1 1 ... 1 -1 1]]

;; Or the first map
(vd/vsa-get our-first-vsa-vector-of-maps :x {:idx 0})


;; =>  [1 #tech.v3.tensor<int8>[1000000][-1 -1 1 ... 1 1 1]]
```

We can also add onto the Clojure vector with a conj.


```clojure
(def our-second-vsa-vector-of-maps
  (vd/vsa-conj our-first-vsa-vector-of-maps (vd/clj->vsa {:z 5})))


(vd/vsa-get our-second-vsa-vector-of-maps :z {:idx 2})


;; =>  [5 #tech.v3.tensor<int8>[1000000][-1 1 1 ... -1 -1 -1]]

```

What is really cool about this is that we have built in fuzziness or similarity matching. For example, with this map, we have more than one possibility of matching.

```clojure
(def vsa-simple-map (vd/clj->vsa {:x 1 :y 1 :z 3}))
```
We can see all the possible matches and scores 


```clojure
(vd/vsa-get vsa-simple-map :x {:threshold -1 :verbose? true})


;; =>  [{1 #tech.v3.tensor<int8>[1000000]
;;      [1 -1 1 ... -1 -1 -1], :dot 125165.0, :cos-sim 0.1582533568106879}  {:x #tech.v3.tensor<int8>[1000000]
;;      [1 -1 -1 ... -1 -1 1], :dot 2493.0, :cos-sim 0.0031520442498225933} {:z #tech.v3.tensor<int8>[1000000]
;;      [-1 -1 1 ... 1 1 -1], :dot 439.0, :cos-sim 5.550531190020531E-4}    {3 #tech.v3.tensor<int8>[1000000]
;;      [-1 -1 1 ... -1 -1 1], :dot -443.0, :cos-sim -5.601105506102723E-4}  {:y #tech.v3.tensor<int8>[1000000]
;;      [-1 -1 1 ... 1 1 1], :dot -751.0, :cos-sim -9.495327844431478E-4}]
```

This opens up the possibility of defining compound symbolic values and doing fuzzy matching. For example with colors.

```clojure
(vb/reset-hdv-mem!)

(def primary-color-vsa-map (vd/clj->vsa {:x :red :y :yellow :z :blue}))
```

Let's add a new compound value to the cleanup memory that is green based on yellow and blue.

```clojure
(vb/add-hdv! :green (vb/bundle
                      (vb/get-hdv :yellow)
                      (vb/get-hdv :blue)))

```

Now we can query the hdv color map for things that are close to green.

```clojure
(vd/vsa-get primary-color-vsa-map :green {:threshold 0.1})


;; =>  [{:z #tech.v3.tensor<int8>[1000000][1 -1 1 ... -1 1 1]}
;;     {:y #tech.v3.tensor<int8>[1000000] [-1 1 1 ... 1 1 1]}]
```

We can also define an `inspect` function for a hdv by comparing the similarity of all the values of the cleanup memory in it.

```clojure
(vd/vsa-inspect primary-color-vsa-map)


;; Note that it includes green in it since it is a compound value
;; =>  #{:y :yellow :green :z :red :blue :x}

(vd/vsa-inspect (vd/clj->vsa {:x :red}))


;; =>  #{:red :x}

```

Finally, we can implement clojure `map` and `filter` functions on the vector data structures that can also include fuzziness.


```clojure
(def color-vsa-vector-map (vd/clj->vsa [{:x :yellow} {:x :green} {:z :red}]))


(vd/vsa-map #(->> (vd/vsa-get % :yellow {:threshold 0.01})
                  (mapv ffirst))
            color-vsa-vector-map)


;; =>  ([:x] [:x] [])


(->> color-vsa-vector-map
     (vd/vsa-filter #(vd/vsa-get % :yellow {:threshold 0.01}))
     count)


;; =>  2
```


## Wrap Up

VSAs and hyperdimensional computing seem like a natural fit for LISP and Clojure. I've only scratched the surface here in how the two can fit together. I hope that more people are inspired to look into it and _small AI with big dimensions_.

Full code and examples here [https://github.com/gigasquid/vsa-clj](https://github.com/gigasquid/vsa-clj).


_Special thanks to Ross Gayler in helping me to implement VSAs and understanding their coolness._






