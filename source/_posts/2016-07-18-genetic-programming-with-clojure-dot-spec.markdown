---
layout: post
title: "Genetic Programming with clojure.spec"
date: 2016-07-18 09:40
comments: true
categories:
- All
- Clojure
---

{% img http://c1.staticflickr.com/9/8815/28320682816_44780d1b75.jpg %}


[Clojure.spec](http://blog.cognitect.com/blog/2016/5/23/introducing-clojurespec) is a new library for Clojure that enables you to write specifications for your program.  In an earlier [post](http://gigasquidsoftware.com/blog/2016/05/29/one-fish-spec-fish/), I showed off some of it's power to generate test data from your specifications.  It's a pretty cool feature.  Given some clojure.spec code, you can generate sample data for you based off of the specifications.  But what if you could write a program that would _generate_ your clojure.spec program based off of data so that you could generate more test data?



## Genetic programming

Here is where we embark for fun.  We are going to use genetic programming to generate clojure.spec _creatures_ that contain a program.  Through successive generations, those creatures will breed, mutate, and evolve to fit the data that we are going to give it.  Going with our creature theme, we can say that it _eats_ a sequence of data like this

```clojure
["hi" true 5 10 "boo"]
```

Each creature will be represented by a map that has information about two key pieces, its program and the _fitness_ score.  Each program is going to start with a [clojure.spec/cat](https://clojure.github.io/clojure/branch-master/clojure.spec-api.html#clojure.spec/cat), (which is the spec to describe a sequence).  From here on out, I'm going to refer to the clojure.spec namespace as `s/`.  So, a simple creature would look like this.

```clojure
{:program (s/cat :0 int? :1 string?)
 :score 0}
```

How do we figure out a score from the creature's spec?  We run the spec and see how much of the data that it can successfully consume.

### Scoring a creature

To score a creature, we're going to use the clojure.spec `explain-data` function. It enables us to run a spec against some data and get back the problems in a data format that we can inspect.  If there are no problems and the spec passes, the result is nil.

```clojure
(s/explain-data (s/cat :0 int? :1 string?)  [1 "hi"])
;=> nil
```

However, if there is a problem, we can get information about what went wrong.  In particular, we can see _where_ it went wrong in the sequence.

```clojure
(s/explain-data (s/cat :0 int? :1 string?)  [1 true])
;=> #:clojure.spec{:problems [{:path [:1], :pred string?, :val true, :via [], :in [1]}]}
```

In the above example, the `:in` key tells us that it fails at index 1. This gives us all the information we need to write a score function for our creature.

```clojure
(defn score [creature test-data]
  (try
   (let [problems (:clojure.spec/problems (s/explain-data (eval (:program creature)) test-data))]
     (if problems
       (assoc creature :score (get-in problems [0 :in 0]))
       (assoc creature :score 100)))
   (catch Throwable e (assoc creature :score 0))))
```

This function tries to run the spec against the data.  If there are no problems, the creature gets a 100 score.  Otherwise, it records the farthest point in the sequence that it got.  Creatures with a higher score are considered more _fit_.

```clojure
(score {:program '(s/cat :0 int? :1 string?)} [1 true])
;=> {:program (s/cat :0 int? :1 string?), :score 1}
```

Now that we have a fitness function to evaluate our creatures, we need a way to generate a random clojure.spec creature.

{% img http:////c1.staticflickr.com/9/8781/28071856800_0477b25fcc.jpg %}


### Create a random creature

This is where I really love Clojure.  Code is data, so we can create the programs as lists and they are just themselves.  To run the programs, we just need to call `eval` on them.  We are going to constrain the creatures somewhat.  They are all going to start out with `s/cat` and have a certain length of items in the sequence.  Also, we are going to allow the parts of the spec to be created with certain predicates.

```clojure
(def preds ['integer? 'string? 'boolean? '(s/and integer? even?) '(s/and integer? odd?)])
```

Also allowing, composition with ands and ors and other sequences.

```clojure
(def seqs ['s/+ 's/*])
(def and-ors ['s/and 's/or])
```

We are also going to have some probability knobs to control how the random creature is constructed.

```clojure
(def seq-prob 0.3)
(def nest-prob 0.00)
(def max-depth 4)
(def and-or-prob 0.85)
```

The `seq-prob` is the probability that a new spec sub sequence will be constructed.  The `nest-prob` is set to zero right now, to keep things simple, but if turned up with increase the chance that a nested spec sequence would occur.  We are going to be writing a recursive function for generation, so we'll keep things to a limited depth with `max-depth`.  Finally, we have the chance that when constructing a spec sub sequence, that it will be an and/or with `and-or-prob`.  Putting it all together with code to construct a random arg.


```clojure
(defn make-random-arg [n]
  (if (and (pos? n) (< (rand) seq-prob))
    (make-random-seq n)
    (rand-nth preds)))
```

Also creating a random sub sequence.

```clojure
(defn make-random-seq [n]
  (cond

    (< (rand) nest-prob)
    `(s/spec (~(rand-nth seqs) ~(make-random-arg (dec n))))

    (< (rand) and-or-prob)
    `(~(rand-nth and-ors) ~(make-random-arg (dec n)) ~(make-random-arg (dec n)))

    :else
    `(~(rand-nth seqs) ~(make-random-arg (dec n)))))
```

Finally, we can create a random `s/cat` spec with

```clojure
(defn make-random-cat [len]
  (let [args (reduce (fn [r i]
                       (conj r (keyword (str i))
                             (make-random-arg max-depth)))
                     []
                     (range len))]
    `(s/cat ~@args)))
```

Let's see it in action.

```clojure
(make-random-cat 3)
;=> (clojure.spec/cat :0 (s/and integer? odd?) :1 integer? :2 boolean?)
```

We can make a batch of new creatures for our initial population using this function.

```clojure
(defn initial-population [popsize max-cat-length]
  (for [i (range popsize)]
    {:program (make-random-cat (inc (rand-int max-cat-length)))}))
```

Great! Now we have a way to make new random spec creatures.  But, we need a way to alter them and let them evolve.  The first way to do this is with _mutation_.

{% img http://c2.staticflickr.com/9/8807/28275661121_94361d2fc4.jpg %}

### Mutating a creature

Mutation in our case, means changing part of the code tree of the creature's program.  To keep the program runnable, we don't want to be able to mutate every node, only specific ones.  We're going to control this by defining a `mutable` function that will only change nodes that start with our sequences or predicates.

```clojure
(defn mutable? [node]
  (or (when (seq? node)
        (contains? (set/union (set seqs) #{'clojure.spec/spec}) (first node)))
      (contains? (set preds) node)))
```

Then, we can use `postwalk` to walk the code tree and alter a node by a mutation probability factor

```clojure
(def mutate-prob 0.1)

(defn mutate [creature]
  (let [program (:program creature)
        mutated-program (walk/postwalk
                         (fn [x] (if (and (mutable? x) (< (rand) mutate-prob))
                                  (make-random-arg max-depth)
                                  x)) program)]
    (assoc creature :program mutated-program)))
```

Trying it on one of our creatures.

```clojure
(mutate {:program '(clojure.spec/cat :0 (s/and integer? odd?) :1 integer?)})
;=> {:program (clojure.spec/cat :0 (s/or (s/and integer? even?)) :1 integer?)}
```

We can change our creatures via mutation, but what about breeding it with other creatures?

{% img http://c8.staticflickr.com/9/8670/28354279095_25661401c0_z.jpg %}

### Crossovers with creatures


Crossover is another way to modify programs.  It takes two creatures and swaps a node from one creature to another. To accomplish this, we're going to use the `walk` function to select at a random probability the crossover node from the first node, then insert it into the second's creatures program at another random spot.

```clojure
(def crossover-prob 0.7)

(defn crossover [creature1 creature2]
  (let [program1 (:program creature1)
        program2 (:program creature2)
        chosen-node (first (walk/walk
                            #(when
                                 (and (< (rand) crossover-prob)
                                      (mutable? %))
                               %)
                            #(remove nil? %) program1))
        crossed-over? (atom false)
        crossover-program (if chosen-node
                             (walk/postwalk
                              (fn [x]
                                (if (and (mutable? x)
                                         (< (rand) crossover-prob)
                                         (not @crossed-over?))
                                  (do (reset! crossed-over? true) chosen-node)
                                  x))
                              program2)
                             program2)]
    {:program crossover-program}))
```

Taking two creatures and putting them together.


```clojure
(crossover {:program '(clojure.spec/cat :0 (s/and integer? odd?) :1 integer?)}
           {:program '(clojure.spec/cat :0 string? :1 boolean?)})
;=> {:program (clojure.spec/cat :0 (s/and integer? odd?) :1 boolean?)}
```


We have our ways to change our creatures to let them evolve and we have a way to rank them.  What we need now is to put it together in a way that will let them evolve to the solution.


{% img http://c5.staticflickr.com/9/8570/28320682956_2a301eea70_z.jpg %}

### Evolving creatures

The process will be in general terms:

* Create initial population
* Rank them
* Take the top two best ones and carry them over (this is known as _elitism_)
* Create the next generation from by _selecting_ creatures for crossover and mutation
* Repeat!

So how do we select the best creatures for our next population?  This is an interesting question, there are many approaches.  The one that we're going to use is called [tournament selection](https://en.wikipedia.org/wiki/Tournament_selection).  It involves picking n creatures from the whole population and then, among those, picking the best scored one.  This will allow diversity in our population that is needed for proper evolution.

```clojure
(defn select-best [creatures tournament-size]
  (let [selected (repeatedly tournament-size #(rand-nth creatures))]
    (-> (sort-by :score selected) reverse first)))
```

We're now ready to write our evolve function.  In it, we pass in the population size, how many generations we want, the tournament size, and of course, our test data that our creatures are going to feed on.  The loop ends when it reaches a perfect fitting solution, (a creature with a score of 100), or the max generations.

Note that we have a chance for a completely random creature to appear in the generations, to further encourage diversity.

```clojure
(defn perfect-fit [creatures]
  (first (filter #(= 100 (:score %)) creatures)))

(defn evolve [pop-size max-gen tournament-size test-data]
  (loop [n max-gen
         creatures (initial-population pop-size (count test-data))]
    (println "generation " (- max-gen n))
    (let [scored-creatures (map (fn [creature] (score creature test-data)) creatures)]
     (if (or (zero? n) (perfect-fit scored-creatures))
       scored-creatures
       (let [elites (take 2 (reverse (sort-by :score scored-creatures)))
             new-creatures (for [i (range (- (count creatures) 2))]
                             ;; add a random node to improve diversity
                             (if (< (rand) new-node-prob)
                               {:program (make-random-cat (count test-data))}
                               (let [creature1 (select-best scored-creatures tournament-size)
                                     creature2 (select-best scored-creatures tournament-size)]
                                 (mutate (crossover creature1 creature2)))))]
         (println "best-scores" (map :score elites))
         (recur (dec n) (into new-creatures elites)))))))
```

Trying it out. We get a perfect clojure.spec creature!

```clojure
(def creature-specs (evolve 100 100 7 ["hi" true 5 10 "boo"]))
  (perfect-fit creature-specs)
  ;=>{:program (clojure.spec/cat :0 string? :1 boolean? :2 (s/and integer? odd?) :3 integer? :4 string?)
      :score 100}
```

Of course, our clojure.spec creature can generate data on its own with the `exercise` function.  Let's have it generate 5 more examples of data that conform to its spec.

```clojure
  (s/exercise (eval (:program (perfect-fit creature-specs))) 5)
;; ([("" true -1 -1 "") {:0 "", :1 true, :2 -1, :3 -1, :4 ""}]
;;  [("D" false -1 -1 "G") {:0 "D", :1 false, :2 -1, :3 -1, :4 "G"}]
;;  [("12" false -1 0 "l0") {:0 "12", :1 false, :2 -1, :3 0, :4 "l0"}]
;;  [("" false -1 -2 "") {:0 "", :1 false, :2 -1, :3 -2, :4 ""}]
;;  [("2" false 1 0 "Jro") {:0 "2", :1 false, :2 1, :3 0, :4 "Jro"}])
```


If we wanted to, we could adjust our evolve function and let it continue to evolve creatures and lots of different solutions to choose from. We could even take the generated data from the `exercise function` and let it generate more creatures who generate more data......

The mind boggles.

We'll leave with a quick summary of Genetic Programming.

* Start with a way to generate random creatures
* Have a way to evaluate their fitness
* Create a way to change them for the next generations using
  * Mutation
  * Crossover
* Have an evolution process
  * Create an initial population
  * Rank them
  * Create the next generation using selection techniques and mutation/ crossovers
  * Don't forget about diversity

Most importantly, have fun!


If you want to play with the code, it's on github here [https://github.com/gigasquid/genetic-programming-spec](https://github.com/gigasquid/genetic-programming-spec)

If you want to learn more about clojure.spec this [video](https://www.youtube.com/watch?v=nqY4nUMfus8) is a great place to start.  The [guide](http://clojure.org/guides/spec) is also a great reference with examples.

If you want to learn more about genetic programming, there are a couple of books I would recommend: [Collective Intelligence](https://www.amazon.com/Programming-Collective-Intelligence-Building-Applications/dp/0596529325) and [Genetic Algorithms + Data Structures = Evolution Programs](https://www.amazon.com/Genetic-Algorithms-Structures-Evolution-Programs/dp/3540606769/ref=sr_1_1?s=books&ie=UTF8&qid=1468862704&sr=1-1&keywords=genetic+algorithms+data+structures)
