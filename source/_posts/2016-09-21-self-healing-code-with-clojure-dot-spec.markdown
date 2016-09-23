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

This is a text[^footnote] for an example1
Some more text

[^footnote]: Footnote text

