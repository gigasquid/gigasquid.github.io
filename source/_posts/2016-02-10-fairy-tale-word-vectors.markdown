---
layout: post
title: "Fairy Tale Word Vectors"
date: 2016-02-10 21:27
comments: true
categories:
- All
- Clojure
---

{% img http://c2.staticflickr.com/2/1558/24654386380_bda44419a8_n.jpg %}

This post continues our exploration from the last blog post [Why Hyperdimensional Socks Never Match](http://gigasquidsoftware.com/blog/2016/02/06/why-hyperdimensional-socks-never-match/).  We are still working our way through [Kanerva's paper](http://redwood.berkeley.edu/pkanerva/papers/kanerva09-hyperdimensional.pdf).  This time, with the basics of hypervectors under our belts, we're ready to explore how words can be expressed as context vectors.  Once in a high dimensional form, you can compare two words to see how similar they are and even perform reasoning.

To kick off our word vector adventure, we need some words.  Preferring whimsy over the Google news, our text will be taken from ten freely available fairy tale books on [http://www.gutenberg.org/](http://www.gutenberg.org/).

### Gather ye nouns

Our goal is to assemble a frequency matrix, with all the different nouns as the rows and the columns will be the counts of if the word appears or not in the document.  Our matrix will be binary with just 1s and 0s.  The _document_ will be a sentence or fragment of words.  A small visualization is below.

| Noun          | Doc1| Doc2
| ------------- |:---:| ---
| flower        | 1   |0
| king          | 0   |1
| fairy         | 1   |0
| gold          | 1   |1

The size of the matrix will be big enough to support hypervector behavior, but not so big as to make computation too annoyingly slow.  It will be nouns x 10,000.

The first task is to get a set of nouns to fill out the rows.  Although, there are numerous online sources for linguistic nouns.  They unfortunately do not cover the same language spectrum as old fairy tale books.  So we are going to collect our own.  Using [Stanford CoreNLP](http://stanfordnlp.github.io/CoreNLP/), we can collect a set of nouns using Grimm's Book as a guide.  There are about 2500 nouns there to give us a nice sample to play with.  This makes our total matrix size ~ 2500 x 10,000.

Now that we have our nouns, let's get down to business.  We want to create an index to row to make a `noun-idx` and then create a sparse matrix for our word frequency matrix.

```clojure
(ns hyperdimensional-playground.context-vectors
  (:require [clojure.core.matrix :as m]
            [clojure.core.matrix.linear :as ml]
            [clojure.string :as string]
            [hyperdimensional-playground.core :refer [rand-hv cosine-sim mean-add inverse xor-mul]]
            [hyperdimensional-playground.fairytale-nouns :refer [fairy-tales-nouns book-list]]))

(m/set-current-implementation :vectorz)
;; size of the hypervectors and freq matrix columns
(def sz 10000)
;; The nouns come from a sampling of Grimm's fairy tale nouns these will
;; make up the rows in the frequency matrix
(def noun-idx (zipmap fairy-tales-nouns (range)))
(def freq-matrix (m/new-sparse-array [(count fairy-tales-nouns) sz]))
```


The next thing we need to do is to have some functions to take a book, read it in, split it into documents and then update the frequency matrix.


### Random indexing for the win

The interesting thing about the update method is that we can use _random indexing_.  We don't need to worry about having a column for each document.  Because of the nature of hyperdimensions, we can randomly assign 10 columns for each document.


```clojure
(defn update-doc!
  "Given a document - upate the frequency matrix using random indexing"
  [doc]
  (let [known-nouns (clojure.set/intersection fairy-tales-nouns (set doc))]
    ; use positive random indexing
    (doall (repeatedly 10 #(doseq [noun known-nouns]
                       (m/mset! freq-matrix (get noun-idx noun) (rand-int sz) 1))))))
```

The whole book is processed by slurping in the contents and using a regex to split it up into docs to update the matrix.

```clojure
(defn process-book
  "Load a book and break it into sentence like documents and update the frequency matrix"
  [book-str]
  (let [book-text (slurp book-str)
        docs (partition 25 (map string/lower-case
                                (string/split book-text #"\s|\.|\,|\;|\!|\?")))
        doc-count (count docs)]
    (println "processing:" book-str "(with" doc-count "docs)")
    (doall (map-indexed (fn [idx doc]
                          (when (zero? (mod idx 1000)) (println "doc:" idx))
                          (update-doc! doc))
                        docs))
    (println "DONE with " book-str)))
```

We can now run the whole processing with:

```clojure
(doseq [book book-list]
    (process-book book))
```

On my system, it only takes about 3 seconds.

Great!  Now we have hypervectors associated with word frequencies.  They are now _context word vectors_.  What can we do with them.

### How close is a king to a goat?

One of the things that we can do with them is find out a measure of how closely related the context of two words are by a measure of their cosine similarity.  First, we need a handy function to turn a string word into a word vector by getting it out of our frequency matrix.

```clojure
(defn wv [word]
  "Get a hypervector for the word from the frequency matrix"
  (let [i (get noun-idx word)]
    (assert (not (nil? i)) (str word " not found"))
    (m/slice freq-matrix i)))
```

Then we can make another nice function to compare two words and give a informational map back.

```clojure
(defn compare-wvs
  "Compare two words and give the cosine distance info map"
  [word1 word2]
  (let [wv1 (wv word1)
        wv2 (wv word2)]
    (when (not= word1 word2)
      {:word1 word1
       :word2 word2
       :cosine (cosine-sim wv1 wv2)})))
```

Let's take a look at the similarities of some words to _king_.

```clojure
(sort-by :cosine[(compare-wvs "king" "queen")
                 (compare-wvs "king" "prince")
                 (compare-wvs "king" "princess")
                 (compare-wvs "king" "guard")
                 (compare-wvs "king" "goat")])
  ;; ({:word1 "king", :word2 "goat", :cosine 0.1509151478896664}
  ;;  {:word1 "king", :word2 "guard", :cosine 0.16098893367403827}
  ;;  {:word1 "king", :word2 "queen", :cosine 0.49470535530616655}
  ;;  {:word1 "king", :word2 "prince", :cosine 0.5832521795716931}
  ;;  {:word1 "king", :word2 "princess", :cosine 0.5836922474743367})
```

As expected, the royal family is closer to the king then a guard or goat is.

One of the interesting things is that now we can do addition and subtraction with these word vectors and see how it affects the relation with other words.

### Boy + Gold = King, Boy + Giant = Jack

We can take a look at how close _boy_ and _king_ are together by themselves.

```clojure
(cosine-sim (wv "boy") (wv "king")) ;=> 0.42996397142253145
```

Now we can add some gold to the boy and that new word vector will be closer to king than boy was alone.

```clojure
(cosine-sim (mean-add (wv "boy") (wv "gold"))
              (wv "king")) ;=> 0.5876251031366048
```

Doing the same for _boy_ and _jack_, we find that adding a giant moves the context closer.

```clojure
(cosine-sim (wv "boy") (wv "jack")) ;=> 0.33102858702785953
;; boy + giant = jack
(cosine-sim (mean-add (wv "giant") (wv "boy"))
              (wv "jack")) ;=>0.4491473187787431
```

Amusingly, a frog and a princess make a prince.

```clojure
;;; frog + princess = prince
  (cosine-sim (wv-add "frog" "princess") (wv "prince")) ;=> 0.5231641991974249
```

We can take this even farther by subtracting words and adding others.  For example a similarity to the word queen can be obtained by subtracting man from king and adding woman.

```clojure
;;; queen= (king-man) + woman
  (cosine-sim (wv "queen")
              (mean-add (wv "woman") (wv-subtract "king" "man"))) ;=>0.5659832204544486
```

Similarly, a contextual closeness to father can be gotten from subtracting woman from mother and adding man.

```clojure
(cosine-sim (wv "father")
              (mean-add (wv "man") (wv-subtract "mother" "woman"))) ;=>0.5959841177719538
```

But wait, that's not all.  We can also do express facts with these word vectors and _reason_ about them.

### Reasoning with word vector with the database as a hyperdimensional value

The curious nature of hypervectors allows the storage of multiple entity, attributes in it and allow the retrieval of the likeness of them later by simple linear math - using only xor multiplication and addition.  This gives us the _database as a value_ in the form of a high dimensional vector.

For an example, say we want to express the fact that Hansel is a brother of Gretel.  We can do this by adding the xor product of brother with hansel and the product of brother with Gretel.

```clojure
;; hansel is the brother of gretel
;; B*H + B*G
(def hansel-brother-of-gretel
   (mean-add
    (xor-mul (wv "brother") (wv "hansel"))
    (xor-mul (wv "brother") (wv "gretel"))))
```

Also we can express that Jack is a bother of Hansel.

```clojure
(def jack-brother-of-hansel
  (mean-add
     (xor-mul (wv "brother") (wv "jack"))
     (xor-mul (wv "brother") (wv "hansel"))))
```

We can add these two facts together to make a new hypervector value.

```clojure
(def facts (mean-add hansel-brother-of-gretel
                       jack-brother-of-hansel))
```

Now we can actually _reason_ about them and ask questions.  Is Jack a brother of Hansel?  With a high cosine similarity, we can assume the answer is likely.

```clojure
 ;; is jack the brother of hansel?
  (cosine-sim
   (wv "jack")
   (xor-mul (mean-add (wv "brother") (wv "gretel"))
            facts)) ;=>0.8095270629815969

```

What about someone unrelated.  Is Cinderella the brother of Gretel? - No

```clojure
 ;; is cinderella the brother of gretel ?
  (cosine-sim
   (wv "cinderella")
   (xor-mul (mean-add (wv "brother") (wv "gretel"))
            facts)) ;=>0.1451799916656951
```

Is Jack the brother of Gretel - Yes

```clojure
 ;; is jack the brother of gretel ?
  (cosine-sim
   (wv "jack")
   (xor-mul (mean-add (wv "brother") (wv "gretel"))
            facts)) ;=> 0.8095270629815969
```

We can take this further by adding more facts and inventing a relation of our own.

###  Siblings in Hyperspace

Let's invent a new word vector that is not in our nouns - _siblings_.  We are going to create new random hypervector to represent it.

```clojure
(def siblings (rand-hv))
```

We will define it in terms of word vectors that we already have.  That is, siblings will be a the sum of brother + sister.  We XOR multiply it by siblings to associate it with the hypervector.

```clojure
(def siblings-brother-sister
    (mean-add (xor-mul siblings (wv "brother")) (xor-mul siblings (wv "sister"))))
```

Now we can add some more facts.  Gretel is a sister of Hansel.

```clojure
 ;; gretel is the sister of hansel
  ;; S*G + S*H
  (def gretel-sister-of-hansel
    (mean-add
     (xor-mul (wv "sister") (wv "gretel"))
     (xor-mul (wv "sister") (wv "hansel"))))
```

Gretel is also a sister of Jack.

```clojure
  ;; gretel is the sister of jack
  ; S*G + S*H
  (def gretel-sister-of-jack
    (mean-add
     (xor-mul (wv "sister") (wv "gretel"))
     (xor-mul (wv "sister") (wv "jack"))))
```

Collecting all of our facts into one hypervector (as a database).

```clojure
 (def facts (mean-add hansel-brother-of-gretel
                       jack-brother-of-hansel
                       gretel-sister-of-jack
                       gretel-sister-of-hansel
                       siblings-brother-sister))
```

Now we can ask some for questions.

Are Hansel and Gretel siblings? - Yes

```clojure
;; are hansel and gretel siblings?
  (cosine-sim
   (mean-add (wv "hansel") (wv "gretel"))
   (xor-mul siblings facts)) ;=>0.627015379034067
```

Are John and Roland siblings - No

```clojure
;; are john and roland siblings?
  (cosine-sim
   (mean-add (wv "roland") (wv "john"))
   (xor-mul siblings facts)) ;=> 0.1984017637065277
```

Are Jack and Hansel siblings? - Yes

```clojure
  (cosine-sim
    (mean-add (wv "jack") (wv "hansel"))
    (xor-mul siblings facts)) ;=>0.48003572523507465
```



### Conclusions

In this fun, but casual exploration of word vector we have seen the potential for reasoning about language in a way that uses nothing more complicated than addition and multiplication.  The ability to store dense information in hypervectors, extract it with simple methods, and flexibly collect it randomly, shows its versatility and power.  Hyperdimensional vectors  might hold the key to unlocking a deeper understanding of cognitive computing or perhaps even true artificial intelligence.

If you are interested in exploring further, feel free to use my github [hyperdimensional-playground](https://github.com/gigasquid/hyperdimensional-playground) as a starting point.
