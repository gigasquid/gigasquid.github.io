    ---
layout: post
title: "Self Healing Code with clojure.spec"
date: 2016-09-21 20:11
comments: true
categories:
- Clojure
- All
---

How can we can make code _smarter_?  One of the ways is to be more resilient to errors.  Wouldn't it be great if a program could recover from an error and _heal_ itself? This code would be able to rise above the mistakes of its humble programmer and make itself better.

The prospect of self-healing code has been heavily researched and long sought after.  In this post, we will take a look at some of the key ingredients from research papers. Then, drawing inspiration for one of them, attempt an experiment in Clojure using clojure.spec.

## Self Healing Code Ingredients

The paper [Towards Design for Self-healing](http://software.imdea.org/~alessandra.gorla/papers/Gorla-DesignSH-SoQua07.pdf) outlines a few main ingredients that we will need.

* Failure Detection - This one is pretty straight forward.  We need to detect the problem in order to fix it.
* Fault Diagnosis - Once the failure has been detected, we need to be able to figure out exactly what the problem was so that we can find a solution.
* Fault Healing - This involves the act of finding a solution and fixing the problem.
* Validation - Some sort of testing that the solution does indeed solve the problem.

With our general requirements in hand, let's turn to another paper for some inspiration for a process to actually achieve our self healing goal.

## Self Healing with Horizontal Donor Code Transfer

MIT developed a system called [CodePhage](http://people.csail.mit.edu/stelios/papers/codephage_pldi15.pdf) which is a system inspired from the biological world with horizontal gene transfer of genetic material between different organisms. In it they use a "horizontal code transfer system" that fixes software errors by transferring correct code from a set of donor applications.

This is super cool.  Could we do something like this in Clojure?

Clojure itself has the fundamental ability with macros to let the code modify itself.  The programs can make programs!  That is a key building block but clojure.spec is something new and has many other advantages that we can use.

* clojure.spec gives code the ability to _describe_ itself.  With it we can describe the data the functions take as input and output in a concise and composable way.
* clojure.spec gives us the ability to _share_ these specifications with other code in the global _registry_.
* clojure.spec gives us the ability to _generate_ data from the specifications, so we can make example data that fits the function's description.

With the help of clojure.spec, we have all that we need to design and implement a self-healing code experiment.

## Self Healing Clojure Experiment

We'll start with a simple problem.

Imagine a programmer has to write a small report program.  It will be a function called `report` that is made up of three helper functions.  It takes in a list of earnings and outputs a string summary of the average.

```clojure
(defn report [earnings]
  (-> earnings
      (clean-bad-data)
      (calc-average)
      (display-report)))
```
The problem is that our programmer has made an error in the `calc-average` function.  A _divide by zero_ error will be triggered on a specific input.

Our goal will be to use clojure.spec to find a matching replacement function from a set of donor candidates.

{% img http://c7.staticflickr.com/6/5659/29249314334_9853230992_b.jpg %}

Then replace the bad `calc-average` function with a better one, and heal the `report` function for future calls.

{% img http://c7.staticflickr.com/9/8721/29249314494_2690703e3a_b.jpg %}


### The Setup

Let's start with the report code.  Throughout the code examples I will be using clojure.spec to describe the function and its data.  If you haven't yet looked at it, I encourage you to check out the [spec Guide](http://clojure.org/guides/spec).

The first helper function is called `clean-bad-data`.  It takes in a vector of anything and filters out only those elements that are numbers.

```clojure
(defn clean-bad-data [earnings]
  (filter number? earnings))
```
Let's create a couple of specs to help us describe it.  The first, `earnings` will be a vector, (for the params) with another vector of anything.

```clojure
(s/def ::earnings (s/cat :elements (s/coll-of any?)))
```
The next spec for the output of the function we will call `cleaned-earnings`. It is going to have a custom generator for the purposes of this experiment, which will constrain the generator to just returning the value `[[1 2 3 4 5]]` as its example data[^1].

```clojure
(s/def ::cleaned-earnings (s/with-gen
                            (s/cat :clean-elements (s/coll-of number?))
                            #(gen/return [[1 2 3 4 5]]))
```

An example of running the function is:

```clojure
(clean-bad-data [1 2 "cat" 3])
;=>(1 2 3)
```

If we call spec's `exercise` on it, it will return the custom sample data from the generator.

```clojure
(s/exercise ::cleaned-earnings 1)
;=> ([[[1 2 3 4 5]] {:clean-elements [1 2 3 4 5]}])
```

Now we can spec the function itself with `s/fdef`.  It takes the `earnings` spec for the args and the `cleaned-earnings` spec for the return value.

```clojure
(s/fdef clean-bad-data
        :args ::earnings
        :ret ::cleaned-earnings)
```

We will do the same for the `calc-average` function, which has the flaw vital to our experiment - if we pass it an empty vector for the earnings, the count will be zero and result in a run time divide by zero error.

```clojure
(defn calc-average [earnings]
  (/ (apply + earnings) (count earnings)))

(s/def ::average number?)

(s/fdef calc-average
    :args ::cleaned-earnings
    :ret ::average)
```

Finally, we will create the rest of the `display-report` function and finish specing the function for `report`.

```clojure
(s/def ::report-format string?)

(defn display-report [avg]
  (str "The average is " avg))

(s/fdef display-report
        :args ::average
        :ret ::report-format)

(defn report [earnings]
  (-> earnings
      (clean-bad-data)
      (calc-average)
      (display-report)))

(s/fdef report
        :args ::earnings
        :ret string?)
```

Giving a test drive:

```clojure
(report [1 2 3 4 5])
;=> "The average is 3"
```
And the fatal flaw:

```clojure
(report [])
;=>  EXCEPTION! Divide by zero
```

Now we have our problem setup.  We need to have our donor candidates.

### The Donor Candidates

We are going to have a separate namespace with them.  They will be a number of them, all function speced out.  Some of them will not be a match for our spec at all.  Those bad ones include:

* `bad-calc-average` It returns the first number in the list and doesn't calc the average at all.
* `bad-calc-average2` It returns a good average function but the result is a string.It wont' match the spec of our `calc-average` function.
* `adder` It takes a number and adds 5 to it.  It also won't match the spec of `calc-average`.

There is a matching function called `better-calc-average` that matches the spec of our `calc-average` function and has the additional check for divide by zero.

```clojure
(s/def ::numbers (s/cat :elements (s/coll-of number?)))
(s/def ::result number?)

(defn better-calc-average [earnings]
  (if (empty? earnings)
    0
    (/ (apply + earnings) (count earnings))))
```
This is the one that we will want to use to replace our broken one.

We have the problem, we have the donor candidates.  All we need is the self-healing code to detect the problem, select and validate the right replacement function, and replace it.

### The Self Healing Process

Our process is going to go like this:

* Try the `report` function and catch any exceptions.
* If we get an exception, look through the stack trace and find the failing function name.
* Retrieve the failing function's spec from the spec registry
* Look for potential replacement matches in the donor candidates
  * Check the orig function's and the donor's `:args` spec and make sure that they are both valid for the failing input
  * Check the orig function's and the donor's `:ret` spec and make sure that they are both valid for the failing input
  * Call spec `exercise` for the original function and get a seed value.  Check that the candidate function's result when called with the seed value is the same result when called with the original function.
* If a donor match is found, then redefine the failing function as new function.  Then call the top level `report` form again, this time using the healed good function.
* Return the result!

```clojure
(ns self-healing.healing
  (:require [clojure.spec :as s]
            [clojure.string :as string]))

(defn get-spec-data [spec-symb]
  (let [[_ _ args _ ret _ fn] (s/form spec-symb)]
       {:args args
        :ret ret
        :fn fn}))

(defn failing-function-name [e]
  (as-> (.getStackTrace e) ?
    (map #(.getClassName %) ?)
    (filter #(string/starts-with? % "self_healing.core") ?)
    (first ?)
    (string/split ? #"\$")
    (last ?)
    (string/replace ? #"_" "-")
    (str *ns* "/" ?)))

(defn spec-inputs-match? [args1 args2 input]
  (println "****Comparing args" args1 args2 "with input" input)
  (and (s/valid? args1 input)
       (s/valid? args2 input)))

(defn- try-fn [f input]
  (try (apply f input) (catch Exception e :failed)))

(defn spec-return-match? [fname c-fspec orig-fspec failing-input candidate]
  (let [rcandidate (resolve candidate)
        orig-fn (resolve (symbol fname))
        result-new (try-fn rcandidate failing-input)
        [[seed]] (s/exercise (:args orig-fspec) 1)
        result-old-seed (try-fn rcandidate seed)
        result-new-seed (try-fn orig-fn seed)]
    (println "****Comparing seed " seed "with new function")
    (println "****Result: old" result-old-seed "new" result-new-seed)
    (and (not= :failed result-new)
         (s/valid? (:ret c-fspec) result-new)
         (s/valid? (:ret orig-fspec) result-new)
         (= result-old-seed result-new-seed))))

(defn spec-matching? [fname orig-fspec failing-input candidate]
  (println "----------")
  (println "**Looking at candidate " candidate)
  (let [c-fspec (get-spec-data candidate)]
    (and (spec-inputs-match? (:args c-fspec) (:args orig-fspec) failing-input)
         (spec-return-match? fname c-fspec orig-fspec  failing-input candidate))))

(defn find-spec-candidate-match [fname fspec-data failing-input]
  (let [candidates (->> (s/registry)
                        keys
                        (filter #(string/starts-with? (namespace %) "self-healing.candidates"))
                        (filter symbol?))]
    (println "Checking candidates " candidates)
    (some #(if (spec-matching? fname fspec-data failing-input %) %) (shuffle candidates))))


(defn self-heal [e input orig-form]
  (let [fname (failing-function-name e)
        _ (println "ERROR in function" fname (.getMessage e) "-- looking for replacement")
        fspec-data (get-spec-data (symbol fname))
        _ (println "Retriving spec information for function " fspec-data)
        match (find-spec-candidate-match fname fspec-data [input])]
    (if match
      (do
        (println "Found a matching candidate replacement for failing function" fname " for input" input)
        (println "Replacing with candidate match" match)
        (println "----------")
        (eval `(def ~(symbol fname) ~match))
        (println "Calling function again")
        (let [new-result (eval orig-form)]
          (println "Healed function result is:" new-result)
          new-result))
      (println "No suitable replacment for failing function "  fname " with input " input ":("))))

(defmacro with-healing [body]
  (let [params (second body)]
    `(try ~body
          (catch Exception e# (self-heal e# ~params '~body)))))

```

What are we waiting for?  Let's try it out.

### Running the Experiment

First we call the `report` function with a non-empty vector.

```clojure
(healing/with-healing (report [1 2 3 4 5 "a" "b"]))
;=>"The average is 3"
```
Now, the big test.

```clojure
(healing/with-healing (report []))
; ERROR in function self-healing.core/calc-average Divide by zero -- looking for replacement
; Retriving spec information for function  {:args :self-healing.core/cleaned-earnings, :ret :self-healing.core/average, :fn nil}
; Checking candidates  (self-healing.candidates/better-calc-average self-healing.candidates/adder self-healing.candidates/bad-calc-average self-healing.candidates/bad-calc-average2)
; ----------
; **Looking at candidate  self-healing.candidates/better-calc-average
; ****Comparing args :self-healing.candidates/numbers :self-healing.core/cleaned-earnings with input [[]]
; ****Comparing seed  [[1 2 3 4 5]] with new function
; ****Result: old 3 new 3
; Found a matching candidate replacement for failing function self-healing.core/calc-average  for input []
; Replacing with candidate match self-healing.candidates/better-calc-average
; ----------
; Calling function again
; Healed function result is: The average is 0
;=>"The average is 0"
```

Since the function is now healed we can call it again and it won't have the same issue.

```clojure
(healing/with-healing (report []))
;=>"The average is 0"
```

It worked!

Taking a step back, let's a take a look at the bigger picture.

## Summary

The self healing experiment we did was intentionally very simple.  We didn't include any validation on the `:fn` component of the spec, which gives us yet another extra layer of compatibility checking. We also only checked one seed value from the spec's `exercise` generator.  If we wanted to, we could have checked 10 or 100 values to ensure the replacement function's compatibility.  Finally, (as mentioned in the footnote), we neglected to use any of spec's built in testing `check` functionality, which would have identified the divide by zero error before it happened.

Despite being just being a simple experiment, I think that it proves that clojure.spec adds another dimension to how we can solve problems in self-healing and other AI areas. In fact, I think we have just scratched the surface on all sorts of new and exciting ways of looking at the world.


[^1]: The reason for this is that if the programmer in our made up example didn't have the custom generator and ran spec's [check](http://clojure.org/guides/spec#_testing) function, it would have reported the divide by zero function and we would have found the problem.  Just like in the movies, where if the protagonist had just done x there would be no crisis that would require them to do something heroic.

