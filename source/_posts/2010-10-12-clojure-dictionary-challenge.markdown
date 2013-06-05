---
author: gigasquid
comments: false
date: 2010-10-12 03:11:52+00:00
layout: post
slug: clojure-dictionary-challenge
title: Clojure Dictionary Challenge
wordpress_id: 95
categories:
- All
- Clojure
- Development
tags:
- Clojure
- Development
---

There was a question today on Twitter about how to go about finding the word with the most consecutive consonants in the dictionary file.  Of course, being a typical developer, when presented with a problem – I am usually not satisfied until I find a solution.  Since I am interested in learning Clojure, I thought I would try to solve this problem functionally.

Armed with Stuart Halloway's “Programming Clojure” and trusty Google by my side, I embarked on my first Clojure mission.

Starting small – I decided to tackle the issue of finding consecutive consonants in a word.  I found that re-seq handles regex very nicely

    
    
    user=>  (re-seq #"[^aeiou]{2,}" "batty") 
    ("tty")
    



Building on … let's find the number of letters in this word.  Since we have a sequence – we need to get the first element off of it, convert it to a string and find the length of it

    
    
    user=>  (.length (str (first (re-seq #"[^aeiou]{2,}" "batty"))))
    3
    



Not bad – but let's turn this into a function now

    
    
    user=> (defn count-cons [s]
       (.length (str (first  (re-seq #"[^aeiou]{2,}" s))))
     )
    #'user/count-cons
    



Now we can call the function directly

    
    
    user=> (count-cons "batty")
    3
    



Alright – we are making progress.  Next step, we need to be able to compare two words and see which has the bigger consonant count and return that.  For this, we will need a little “if” magic.

    
    
    user=> (defn compare-words [s1,s2]
    (if (> (count-cons s1) (count-cons s2))
      s1 s2))
    #'user/compare-words
    



Let's test it out

    
    
    #'user/compare-words
    user=> (compare-words "batty" "bat")
    "batty"
    user=> (compare-words "bat" "batty")
    "batty"
    



Oh, yes, we are getting to the good part now.  Since we have a function that we can call on two arguments and give us one back that we can work with – we are ready to pull out the big guns …. reduce!

    
    
    user=> (reduce compare-words ["vat", "batty", "cars"])
    "batty"
    



Yeah!  Next we just need to feed it a file.  For this, after doing some research, I used the duck-streams library – you need to load it in using

    
    
    user=> (use '[clojure.contrib.duck-streams :only (spit read-lines)])
    
    nil
    
    



We open the file and read the lines and feed it to our function 

    
    
    user=> (reduce compare-words (read-lines "/usr/share/dict/words"))
    
    "Ångström"
    
    


Yes, my regex needs some tweaking - but for this exercise, I am content.

When you just have the working code.  It is actually quite concise:

    
    
    ;Counting consecutive consonants
    
    (use '[clojure.contrib.duck-streams :only (spit read-lines)])
    
    (defn count-cons [s]
       (.length (str (first  (re-seq #"[^aeiou]{2,}" s))))
     )
    
    (defn compare-words [s1,s2]
    (if (> (count-cons s1) (count-cons s2))
      s1 s2))
    
    (reduce compare-words (read-lines "/usr/share/dict/words"))
    



All in all, a fun evening trying to think functionally.

