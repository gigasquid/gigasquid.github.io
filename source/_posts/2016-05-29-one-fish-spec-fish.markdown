---
layout: post
title: "One Fish Spec Fish"
date: 2016-05-29 16:29
comments: true
categories:
- Clojure
- All
---

{% img https://upload.wikimedia.org/wikipedia/en/9/9a/One_Fish_Two_Fish_Red_Fish_Blue_Fish_%28cover_art%29.jpg %}

[Clojure.spec](http://blog.cognitect.com/blog/2016/5/23/introducing-clojurespec) is an exciting, new core library for Clojure.  It enables pragmatic specifications for functions and brings a new level of robustness to building software in Clojure, along with unexpected side benefits.  One of which is the ability to write specifications that generate Dr. Seuss inspired rhymes.

In this blog post, we'll take a tour of writing specifications for a clojure function, as well as the power of data generation.  First, some inspirational words:

```
One fish
Two fish
Red fish
Blue fish
```

The mere shape of these words brings a function to mind.  One that would take in a vector:

```clojure
[1 2 "Red" "Blue"]
```

and give us back a string of transformed items with the word _fish_ added, of course.

But, let us turn our attention the parameters of this function and see how we can further specify them.  Before we get started, make sure you use the latest version of clojure, currently `[org.clojure/clojure "1.9.0-alpha3"]`,  test.check `[org.clojure/test.check "0.9.0"]`, and add clojure.spec to your namespace.

```clojure
(ns one-fish.core
  (:require [clojure.spec :as s]))
```

### Specifying the values of the parameters

Back to the parameters. The first two are integers, that's pretty easy, but we want to say more about them.  For example, we don't want them to be very big.  Having a child's poem with the _One Hundred Thousand and Thirty Three fish_ really won't do.  In fact, what we really want is to say is there is finite notion of _fish-numbers_ and it's a map of integer to string representation.

```clojure
(def fish-numbers {0 "Zero"
                   1 "One"
                   2 "Two"})
```

Then, we can use the `s/def` to register the spec we are going to define for global reuse.  We'll use a namespaced keyword `::fish-number` to express that our specification for a valid number is the keys of the `fish-numbers` map.

```clojure
(s/def ::fish-number (set (keys fish-numbers)))
```

Now that we have the specification, we can ask it if it's valid for a given value.

```clojure
(s/valid? ::fish-number 1) ;=> true
(s/valid? ::fish-number 5) ;=> false
```

So `5` is not a valid number for us.  We can ask it to explain why not.

```clojure
(s/explain ::fish-number 5)
;; val: 5 fails predicate: (set (keys fish-numbers))
```

Which, of course,  totally makes sense because `5` is not in our `fish-numbers` map.  Now that we've covered the numbers, let's look at the colors.  We'll use a finite set of colors for our specification.  In addition to the classic red and blue, we'll also add the color _dun_.

```clojure
(s/def ::color #{"Red" "Blue" "Dun"})
```

_You may be asking yourself, "Is dun really a color?".  The author can assure you that it is in fact a real color, like a [dun colored horse](http://www.dictionary.com/browse/dun).  Furthermore, the word has the very important characteristic of rhyming with number one, which the author spent way too much time trying to think of._


### Specifying the sequences of the values

We're at the point where we can start specifying things about the sequence of values in the parameter vector.  We'll have two numbers followed by two colors.  Using the `s/cat`, which is a concatentation of predicates/patterns, we can specify it as the `::first-line`

```clojure
(s/def ::first-line (s/cat :n1 ::fish-number :n2 ::fish-number :c1 ::color :c2 ::color))
```

What the spec is doing here is associating each _part_ with a _tag_, to identify what was matched or not, and its predicate/pattern.  So, if we try to explain a failing spec, it will tell us where it went wrong.

```clojure
(s/explain ::first-line  [1 2 "Red" "Black"])
;; In: [3] val: "Black" fails spec: :one-fish.core/color
;;   at: [:c2] predicate: #{"Blue" "Dun" "Red"}
```

That's great, but there's more we can express about the sequence of values.  For example, the second number should be one bigger than the first number.  The input to the function is going to be the map of the destructured tag keys from the `::first-line`

```
(defn one-bigger? [{:keys [n1 n2]}]
  (= n2 (inc n1)))
```

Also, the colors should not be the same value.  We can add these additional specifications with `s/and`.

```clojure
(s/def ::first-line (s/and (s/cat :n1 ::fish-number :n2 ::fish-number :c1 ::color :c2 ::color)
                           one-bigger?
                           #(not= (:c1 %) (:c2 %))))
```

We can test if our data is valid.

```clojure
(s/valid? ::first-line [1 2 "Red" "Blue"]) ;=> true
```

If we want to get the destructured, conformed values, we can use `s/conform`.  It will return the tags along with the values.

```clojure
(s/conform ::first-line [1 2 "Red" "Blue"])
;=> {:n1 1, :n2 2, :c1 "Red", :c2 "Blue"}
```

Failing values, for the specification can be easily identified.

```clojure
(s/valid? ::first-line [2 1 "Red" "Blue"]) ;=> false
(s/explain ::first-line [2 1 "Red" "Blue"])
;; val: {:n1 2, :n2 1, :c1 "Red", :c2 "Blue"}
   fails predicate: one-bigger?

```

With our specifications for both the values and the sequences of values in hand, we can now use the power of data generation to actually create data.

### Generating test data - and poetry with specification

The `s/exercise` function will generate data for your specifications.  It does 10 items by default, but we can tell it to do only 5.  Let's see what it comes up with.

```clojure
(s/exercise ::first-line 5)
;; ([(0 1 "Dun" "Red") {:n1 0, :n2 1, :c1 "Dun", :c2 "Red"}]
;;  [(0 1 "Blue" "Red") {:n1 0, :n2 1, :c1 "Blue", :c2 "Red"}]
;;  [(0 1 "Blue" "Dun") {:n1 0, :n2 1, :c1 "Blue", :c2 "Dun"}]
;;  [(1 2 "Blue" "Dun") {:n1 1, :n2 2, :c1 "Blue", :c2 "Dun"}]
;;  [(1 2 "Dun" "Red") {:n1 1, :n2 2, :c1 "Dun", :c2 "Red"}])
```

Hmmm... something's not quite right.  Looking at the first result `[0 1 "Dun" Red"]`, it would result in:

```
Zero fish
One fish
Dun fish
Red fish
```

Although, it meets our criteria, it's missing one essential ingredient - rhyming!

Let's fix this by adding an extra predicate `number-rhymes-with-color?`.

```clojure
(defn fish-number-rhymes-with-color? [{n :n2 c :c2}]
  (or
   (= [n c] [2 "Blue"])
   (= [n c] [1 "Dun"])))
```

We'll add this to our definition of `::first-line`, stating that the second number parameter should rhyme with the second color parameter.

```clojure
(s/def ::first-line (s/and (s/cat :n1 ::fish-number :n2 ::fish-number :c1 ::color :c2 ::color)
                           one-bigger?
                           #(not= (:c1 %) (:c2 %))
                           fish-number-rhymes-with-color?))

(s/valid? ::first-line [1 2 "Red" "Blue"]) ;=> true
(s/explain ::first-line [1 2 "Red" "Dun"])
;; val: {:n1 1, :n2 2, :c1 "Red", :c2 "Dun"}
;;   fails predicate: fish-number-rhymes-with-color?
```

Now, let's try the data generation again.

```clojure
(s/exercise ::first-line)
;; ([(1 2 "Red" "Blue") {:n1 1, :n2 2, :c1 "Red", :c2 "Blue"}]
;;  [(1 2 "Red" "Blue") {:n1 1, :n2 2, :c1 "Red", :c2 "Blue"}]
;;  [(0 1 "Blue" "Dun") {:n1 0, :n2 1, :c1 "Blue", :c2 "Dun"}]
;;  [(1 2 "Dun" "Blue") {:n1 1, :n2 2, :c1 "Dun", :c2 "Blue"}]
;;  [(1 2 "Dun" "Blue") {:n1 1, :n2 2, :c1 "Dun", :c2 "Blue"}]
;;  [(0 1 "Blue" "Dun") {:n1 0, :n2 1, :c1 "Blue", :c2 "Dun"}]
;;  [(1 2 "Red" "Blue") {:n1 1, :n2 2, :c1 "Red", :c2 "Blue"}]
;;  [(0 1 "Red" "Dun") {:n1 0, :n2 1, :c1 "Red", :c2 "Dun"}]
;;  [(0 1 "Red" "Dun") {:n1 0, :n2 1, :c1 "Red", :c2 "Dun"}]
;;  [(0 1 "Blue" "Dun") {:n1 0, :n2 1, :c1 "Blue", :c2 "Dun"}])
```

Much better.  To finish things off, let's finally create a function to create a string for our mini-poem from our data.  While  we're at it, we can use our spec with `s/fdef`, to validate that the parameters are indeed in the form of `::first-line`.

### Using spec with functions


Here's our function `fish-line` that takes in our values as a parameters.

```clojure
(defn fish-line [n1 n2 c1 c2]
  (clojure.string/join " "
    (map #(str % " fish.")
      [(get fish-numbers n1)
       (get fish-numbers n2)
       c1
       c2])))
```

We can specify that the args for this function be validated with `::first-line` and the return value is a string.

```clojure
(s/fdef fish-line
        :args ::first-line
        :ret  string?)
```

Now, we turn on the instrumentation of the validation for functions and see what happens.

```clojure
(s/instrument #'fish-line)

(fish-line 1 2 "Red" "Blue")
;-> "One fish. Two fish. Red fish. Blue fish."

```

But what about with bad data?

```clojure
(fish-line 2 1 "Red" "Blue")

 ;; Call to #'one-fish.core/fish-line did not conform to spec: val:
 ;;   {:n1 2, :n2 1, :c1 "Red", :c2 "Blue"} fails at: [:args] predicate:
 ;;   one-bigger? :clojure.spec/args (2 1 "Red" "Blue")

 ;;   {:clojure.spec/problems
 ;;    {[:args]
 ;;     {:pred one-bigger?,
 ;;      :val {:n1 2, :n2 1, :c1 "Red", :c2 "Blue"},
 ;;      :via [],
 ;;      :in []}},
 ;;    :clojure.spec/args (2 1 "Red" "Blue")}

```

Ah, yes - the first number must be one smaller than the second number.


### Wrap up

I hope you've enjoyed this brief tour of clojure.spec.  If you're interested in learning more, you should check out the [spec.guide](http://clojure.org/guides/spec).  It really is an exciting, new feature to Clojure.

In the meantime, I'll leave you with one of our generated lines, sure to be a big hit with future generations.

```
Zero fish
One fish
Red fish
Dun fish
```
