---
layout: post
title: "Self Healing Code with clojure.spec"
date: 2016-09-21 20:11
comments: true
categories:
- Clojure
- All
---

I have an interest in AI and ways that we can make code _smarter_.  One of the ways that code can be smarter is to be more resilient to errors.  Wouldn't it be great if a program could recover from an error and _heal_ itself? This code would be able to rise above the mistakes of its humble programmer and make itself better.

The prospect of self-healing code has been heavily researched and long sought after.  In this post, we will take a look at some of the key ingredients and inspiration drawn from academic papers and then attempt an experiment in Clojure using clojure.spec.

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

Clojure itself has the fundamental ability with macros to let the code modify itself.  The programs can make programs!  That is a key building block.  But clojure.spec is something new and has many other advantages that we can use.

* Clojure.spec gives code the ability to _describe_ itself.  With it we can describe the data the functions take as input and output in a concise and composable way.
* Clojure.spec gives us the ability to _share_ these specifications with other code in the global _registry_.
* Clojure.spec gives us the ability to _generate_ data from the specifications, so we can make example data that fits the function's description.

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

If we call spec's `excercise` on it, it will return the custom sample data from the generator.

```clojure
(s/exercise ::cleaned-earnings 1)
;=> ([[[1 2 3 4 5]] {:clean-elements [1 2 3 4 5]}])
```

Now we can spec the function itself with `s/def`.  It takes the `earnings` spec for the args and the `cleaned-earnings` spec for the return value.

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

### The Self Healing

Our process is going to go like this:

* Try the `report` function and catch any exceptions.
* If we get an exception, look through the stack trace and find the failing function name.
* Retrieve the failing function's spec from the spec registry
* Look for potential replacement matches in the 







[^1]: The reason for this is that if the programmer in our made up example didn't have the custom generator and ran spec's [check](http://clojure.org/guides/spec#_testing) function, it would have reported the divide by zero function and we would have found the problem.  Just like in the movies, where if the protagonist had just done x there would be no crisis that would require them to do something heroic.

