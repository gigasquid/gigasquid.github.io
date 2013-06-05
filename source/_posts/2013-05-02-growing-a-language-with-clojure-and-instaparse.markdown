---
author: gigasquid
comments: true
date: 2013-05-02 02:08:18+00:00
layout: post
slug: growing-a-language-with-clojure-and-instaparse
title: Growing a Language with Clojure and Instaparse
wordpress_id: 689
categories:
- All
- Clojure
---

Creating your own programming language with Clojure and [Instaparse](https://github.com/Engelberg/instaparse) is like building rainbows with s-expressions.  The Instaparse library is an elegant way of building executable parsers trees with pattern matching and [_standard EBNF notation_](http://en.wikipedia.org/wiki/Extended_Backus%E2%80%93Naur_Form) for context-free grammars. Since this is my first foray into parser trees and grammars, I thought I would share my learnings in this post.


## Starting with a Single Word


Let's start with the simplest example:  a number.  When we start up our REPL in our brand new language, we want to be able to enter an integer, and have evaluate as an integer.

    
    MyCoolLang> 1
    1


Using the instaparse library, we define a number to be a regex matching an integer.

    
    (ns coollang.parser
      (:require [instaparse.core :as insta]))
    
    (def parser
      (insta/parser
       "number = #'[0-9]+'"))
    
    (parser "1") ;=>; [:number "1"]


We now have a parser tree node that is of a type number. Pretty nice so far, but more rainbows are coming. You can make elegant transformations on the parser tree, and does them in a bottom up fashion, so you can use it for evaluation as well. In our simple number example, we are applying the read-string function on the :number node to turn it into a int.

    
    (def transform-options
      {:number read-string})
    
    (defn parse [input]
      (->> (parser input) (insta/transform transform-options)))
    
    (parse "1") ;=> 1




## Adding on spaces and vectors


Let's build on a bit more. When someone enters in a sequence of numbers separated by spaces, it will be defined as a vector.

    
    MyCoolLang> 1 2 3 4
    [1 2 3 4]


We need to add the notion of spaces, spaces with numbers, and vectors into our grammar, as well as the rules
for evaluating these new nodes.  Notice that we use the <> notation to hide the definition in the parser tree.  The + means one or more times.  The * means 0 or more times, and the | means or.

    
    (def parser
      (insta/parser
       "expr = number | vector
        vector = snumber+ number
        <snumber> = (number space)*
        <space> = <#'[ ]+'>
        number = #'[0-9]+'"))
    
    (parser "1 2 3 4") ;=> [:expr [:vector [:number "1"] [:number "2"] [:number "3"] [:number "4"]]]
    
    (def transform-options
      {:number read-string
       :vector (comp vec list)
       :expr identity})
    
    (defn parse [input]
      (->> (parser input) (insta/transform transform-options)))
    
    (parse "1 2 3 4") ;=> [1 2 3 4]




## Adding in operations


Pretty cool. We have numbers and vectors. Let's see if we can do something fun like do some simple math on these vectors or numbers. We want it so when we type in + and some numbers, it adds them up.

    
    MyCoolLang> + 1 2 3 4
    10


Of course we need to further expand our grammar and rules. 

    
    (def parser
      (insta/parser
       "expr = number | vector | operation
        operation = operator space+ vector
        operator = '+' | '-' | '*' | '/'
        vector = snumber+ number
        <snumber> = (number space)*
        <space> = <#'[ ]+'>
        number = #'[0-9]+'"))
    
    (parser "+ 1 2 3 4") ;=> [:expr
     ;                        [:operation
     ;                         [:operator "+"]
     ;                           [:vector [:number "1"] [:number "2"] [:number "3"] [:number "4"]]]
    
    (defn choose-operator [op]
      (case op
        "+" +
        "-" -
        "*" *
        "/" /))
    
    (def transform-options
      {:number read-string
       :vector (comp vec list)
       :operator choose-operator
       :operation apply
       :expr identity})
    
    (defn parse [input]
      (->> (parser input) (insta/transform transform-options)))
    
    (parse "+ 1 2 3 4") ;=> 10




## Add a REPL


All we need now is a cool REPL to start working in:
We just need a main function to call our REPL, (Read - Evaluate - Print - Loop), and we are all set.

    
    (ns coollang.repl
      (:require [coollang.parser :as parser]))
    
    (defn repl []
      (do
        (print "MyCoolLang> ")
        (flush))
      (let [input (read-line)]
        (println (parser/parse input))
        (recur)))
    
    (defn -main [& args]
      (println "Hello MyCoolLang!")
      (println "===============")
      (flush)
      (repl))




## Closing and Inspiration


I have enjoyed playing around and learning about creating programming languages with Clojure and instaparse.
It truly is a beautiful library. If you need any more inspiration to start creating your own programming language, may I recommend:



	
  * [Growing a Program Language by Guy Steele ](http://www.youtube.com/watch?v=_ahvzDzKdB0)- A classic and amazing talk about designing programming languages.

	
  * [BODOL](https://github.com/bodil/BODOL) - A language experiment using Clojure and Instaparse


Now go forth and create!
