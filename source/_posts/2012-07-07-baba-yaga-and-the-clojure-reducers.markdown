---
author: gigasquid
comments: true
date: 2012-07-07 23:56:36+00:00
layout: post
slug: baba-yaga-and-the-clojure-reducers
title: Baba Yaga and the Clojure Reducers
wordpress_id: 409
categories:
- All
- Clojure
---

![Baba Yaga's House](http://www.thebells.net/Halloween/BabaYaga/BabaYaga3.GIF)

Once upon a time, a young girl decided to take a break from her code and stroll in the forest.  It was quite a pleasant day, she packed her lunch in her bag and set off.  While she was walking, she started thinking about a concurrency bug that her OO project was having.  As she pondered the complexities of mutablilty, state, and threads, she must of strayed from the trail and lost track of time.  By the time she looked around, she realized that she was totally lost.

It was then she spotted a very strange hut on chicken legs in the middle of the forest.  The door was open, and there was a ladder leading up to it.  She yelled "Hello", but there was no response.  She climbed up the ladder and entered the hut to see if she could find anyone inside.  The hut was empty except for a pile of old books, a large kettle, and very skinny, malnourished black cat. Her heart went out to the poor cat.  She took her sandwich from her bag and watched as the cat greedily ate it.  The cat looked up at her and said, "Thank you for your kindness.  Now, you should really get out of her before Baba Yaga ..."

A large gust of wind came at the door and Baba Yaga appeared.  She smiled an iron tooth grin at the girl and said, "What do we have here? An intruder!".  

The girl stammered out, "I am sorry, it is just a mistake.  I am lost .."

"Too late!" Baba Yaga grinned larger.  "You are now my slave and if you don't complete my tasks, I will eat you for my supper." She thought for a moment and then pulled a book titled _The Odyssey_ from the pile.  "Your first task is to calculate the hash code of every character this book. Then sum of the values of only the even ones.  Make sure you have it done before I return.  And do it fast, I will be timing you."  Baba Yaga turned and disappeared in a gust of wind, with the door slamming and locking firmly in place behind her.   

The girl sunk to the floor and started to weep.  How could she complete the task?  The cat rubbed up against her and purred, "You showed kindess to me where Baba Yaga never has. I will help you. It seems like this task would be best suited to a Clojure map, filter, and reduce, don't you think?"

The girl wiped her eyes. "Cat, I think you are right."  She picked up the book.  "The first thing we need is to get the content of this book into a vector."


    
    
    (def odyssey-text (vec (slurp "odyssey.txt")))
    (class odyssey-text) ;=> java.lang.PersistentVector
    



"The vector contains all the characters.  See, we can grab the first one and find its hash code this way."

    
    
    (first odyssey-text) ;=> \P
    (class (first odyssey-text)) ;=> java.lang.Character
    (.hashCode (first odyssey-text)) ;=> 80
    



"Now, all we need to do is to make a function to find the hash code and map it to the entire string."

    
    
    (defn hashcode [c] (.hashCode c))
    (map hashcode odyssey-text) ;=> (80 114 ..... )
    



"Next, we need to filter only the even ones out."

    
    
    (defn hashcode [c] (.hashCode c))
    (map hashcode odyssey-text) ;=> (80 114 111..... )
    (filter even? (map hashcode odyssey-text)) ;=> (80 114 ... )
    



"Finally, we just need to sum all these values up with reduce."

    
    
    (reduce + (filter even? (map hashcode odyssey-text))) ;=> 33702446
    



As soon as she had gotten her answer, Baba Yaga appeared back through the door.  "Well, you seemed to have found the answer.  But, let's see how long it took you."


    
    
    (dotimes [n 5]
      (println (str "map - filter - reduce - ( run " n " ):"))
      (time (reduce + (filter even? (map hashcode odyssey-text)))))
           ;=> map - filter - reduce - ( run 0 ):
           ;   "Elapsed time: 6932.227 msecs"
           ;   map - filter - reduce - ( run 1 ):
           ;   "Elapsed time: 5433.219 msecs"
           ;   map - filter - reduce - ( run 2 ):
           ;   "Elapsed time: 5157.45 msecs"
           ;   map - filter - reduce - ( run 3 ):
           ;   "Elapsed time: 5397.058 msecs"
           ;   map - filter - reduce - ( run 4 ):
           ;   "Elapsed time: 5224.334 msecs"
    



Baba Yaga chuckled "Have it done again in under 5 seconds by the time I return.  I am getting hungry."

The girl starting sobbing again. "How am I supposed to make it faster?"

The cat calmly cleaned himself and said "I have heard that Clojure has a new Reducers library that allows you to do composable, parallel, reducible functions like mapping and filtering.  Try this in the namespace."

    
    
    (ns reducers.core
      (:require [clojure.core.reducers :as r]))
    



"The new parallel versions of map and filter have the exact same shape as the regular versions.  So all we need to do is use the new reducer versions."


    
    
    (r/fold + (r/filter even? (r/map hashcode odyssey-text))) ;=> 33702446
    



"But, is it faster?  The girl hoped."

    
    
            ;=>   r/map - r/filter - r/fold - ( run 0 ):
            ;     "Elapsed time: 4702.766 msecs"
            ;     r/map - r/filter - r/fold - ( run 1 ):
            ;     "Elapsed time: 4617.575 msecs"
            ;     r/map - r/filter - r/fold - ( run 2 ):
            ;     "Elapsed time: 4596.329 msecs"
            ;     r/map - r/filter - r/fold - ( run 3 ):
            ;     "Elapsed time: 4636.259 msecs"
            ;     r/map - r/filter - r/fold - ( run 4 ):
            ;     "Elapsed time: 4572.804 msecs"
    



"No!" Baba Yaga stormed in the room.  "Cat!  You helped her!  You mangy thing. Get out of here!"  She shoved the cat out the door.  "Let me look at that.  I don't believe it. I want to see the all the filtered hash values for myself."

The cat peeked around the corner and spoke softly to the girl. "Luckily, _into_ uses reduce."


    
    
    (into [] (r/filter even? (r/map hashcode odyssey-text))) ;=> [80 114 ... ]
    



While Baba Yaga was intently inspecting all the values in the vector, the cat motioned to the girl to slip out the door.  Once outside, she grabbed the cat in her arms and ran as fast and as far away as she could.  She was relieved to finally reach her home safely.  Where she and cat lived happily for ever after writing Clojure code.

**The End**

For more information about [Clojure Reducers](http://clojure.com/blog/2012/05/08/reducers-a-library-and-model-for-collection-processing.html)
For the code on [github](https://github.com/gigasquid/baba-yaga-reducers) if you want to explore yourself.
More about [Baba Yaga Russian Fairy Tales](http://en.wikipedia.org/wiki/Baba_Yaga).





