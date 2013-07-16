---
author: gigasquid
comments: false
date: 2013-06-04 18:57:52+00:00
layout: post
slug: babar-a-little-language-with-speech-acts-for-machines
title: Babar - A Little Language with Speech Acts for Machines
wordpress_id: 702
categories:
- All
- Clojure
- Development
- John McCarthy Papers
---

[![Babar Books](http://gigasquidsoftware.com/wordpress/wp-content/uploads/2013/06/babarbooks2-237x300.jpeg)](http://gigasquidsoftware.com/wordpress/wp-content/uploads/2013/06/babarbooks2.jpeg)


## Preface: A Gentle Obsession


About a year ago, I picked up John McCarthy's paper on [Elephant 2000](http://www-formal.stanford.edu/jmc/elephant/elephant.html). I have to admit that I only understood about 10% of it. But I was so intrigued by the ideas that it sent me on a quest. I re-read it numerous times, slept with it under my pillow, and finally decided that I needed to read his other papers to get an insight into his thoughts. I began a considered effort with [Seven McCarthy Papers in Seven Weeks](http://gigasquidsoftware.com/wordpress/?p=466). It ended up taking about three months, rather than seven 7 weeks. Again I came back to Elephant 2000. I began to understand more as other ideas and concepts sunk in, like [ascribing beliefs and goals to machines](http://www-formal.stanford.edu/jmc/ascribing/ascribing.html). But to really explore the ideas, I really wanted to try to implement parts of Elephant in my own programming language. The problem was, having no formal training in computer science, (my background is Physics), I had never created a programming language before. The stars aligned and I found the [Instaparse](https://github.com/Engelberg/instaparse) Clojure library. The result is [Babar](https://github.com/gigasquid/babar), a language designed to explore communication with machines via [Speech Acts](http://en.wikipedia.org/wiki/Speech_act).


## What are the Speech Acts?





When I say say "Pass the salt.", the meaning behind the utterance is that I would like someone to reach out and move the salt shaker to me. I am requesting an action be performed. It doesn't really matter if the utterance is in English, French, or Spanish. The intention is the same. Furthermore, if you accept my request to pass the salt. It creates a commitment on your part to actually perform the action. There are two types of speech acts that Babar is concerned with. The first is called an [Illocutionary Act](http://en.wikipedia.org/wiki/Illocutionary_act). Some of the english verbs denoting these acts are "assert", "command", "request", and "query". The second is a [Perlocutionary Act](http://en.wikipedia.org/wiki/Perlocutionary_act). These are acts that are concerned with the effects of hearing them on future actions. Some of english verbs denoting these acts are "convince", "persuade", and "warn".



## Hello Babar





Babar is an experimental language that uses these Speech Acts to communicate. It also combines one of the other ideas of McCarthy, that is of beliefs and goals. The ultimate aim in the language is discover ways of thinking about computers and communicating with them based on the way that we communicate with each other. The state of a computer at any given point in time can be very complex and hard to understand. If we ascribe this state to be a "belief", it becomes easier to understand and thus easier to program. The Babar REPL has internal commitments and internal beliefs. The goal of the Babar REPL is to keep all of its commitments. Speech acts are used to "convince" Babar of beliefs and to make "requests" that form commitments. The Babar REPL continually checks to see if it needs to fulfill a commitments. It fulfills them based on its beliefs. As an optional configuration, the REPL will speak aloud its beliefs as the become true - or as it "holds" the belief.


## Syntax and Basics





The language uses basic Clojure datatypes and makes the parens optional in most cases to make the expressions look more like syntactically sugared speech acts.

    
    1     ;=> 1
    2.3   ;=> 2.3
    -3.4  ;=> 3.4
    "cat" ;=> cat
    :bird ;=> bird
    true  ;=> true
    {:cat :meow :dog :bark} ;=> {:cat :meow :dog :bark}
    [1 2 true :bird] ;=> [1 2 true bird]
    atom 1 ;=> #
    
    (def dog 16)
    dog ;=> 16
    def cat 18
    cat ;=> 18





Vectors are a bit interesting in the respect that you don't need to input the square brackets. If you just put in space delimited items, it will automatically construct a vector for you.

    
    1 2 3 4 ;=> [1 2 3 4]





You can create anonymous functions with the fn [x] syntax from clojure. And call them with surrounding parens. You can call regular functions by the () notation or the shorthand :.

    
    fn [x] + x 1 ;=> fn
    (fn [x] + x 1) ;=> fn
    ((fn [x] + x 1) 3) ;=> 4
    ((fn [x y z] + x y z) 1 2 3) ;=> 6
    ((fn [] [4 5 6])) ;=> [4 5 6]
    
    defn dog [] "woof"
    dog: ;=> "woof"





To see the complete documentation - please visit the [Github repo](https://github.com/gigasquid/babar).


## Show Me Babar Speech Acts


Now that we have the basics. Let's look at example of running a program with speech acts.
This one speaks its beliefs and has assertions, a request, and queries.

    
    speak-config true.
    assert sunny false.
    convince #nice-day "It is a nice day." fn [] = sunny true.
    request *open-window when #nice-day fn [] println "Opened the window".
    query request-is-done *open-window?
    assert sunny true.
    query request-is-done *open-window?



[video](http://www.youtube.com/watch?v=bt2iYsVyCOM)




Here is another one that shows using a request until a belief is held.

    
    speak-config true.
    
    assert counter atom 1.
    convince #done "I am done counting" fn [] > @counter 3.
    request *count-up until #done fn [] swap! counter inc.
    sleep 25.
    query request-value *count-up?


[video](http://www.youtube.com/watch?v=aT8MK0w71LM)




Here the REPL asks you a question if you give it an undeclared var

    
    speak-config true.
    ask-config true.
    
    request *task1 fn [] + 10 x.
    query request-is-done *task1?
    assert x 3.
    sleep 10.
    query request-is-done *task1?
    query request-value *task1?


[video](https://www.youtube.com/watch?v=nmi_fafmjsg)


## Autonomous AR Drone Flight with Babar REPL





Since the language is aimed at communincating with machines. It is only natural that I use it to talk to the AR Drone.
Here is a program that has the drone take off, get to a cruising altitude, and land - all using speech acts (and the [clj-drone library](https://github.com/gigasquid/clj-drone)).

    
    speak-config true.
    
    import "clj-drone.core".
    import "clj-drone.navdata".
    
    assert get-navdata [key] get @nav-data key.
    assert navdata-equal [key val] = (get-navdata key) val.
    assert navdata-gt [key val] > (get-navdata key) val.
    assert init-drone [] (drone-initialize).
    assert init-nav [] (drone-init-navdata).
    
    convince #landed "I am on the ground" fn [] (navdata-equal :control-state :landed).
    convince #flying "I am flying" fn [] or (navdata-equal :control-state :flying)
                                            (navdata-equal :control-state :hovering).
    convince #high-enough "I am high enough" fn [] (navdata-gt :altitude 1.5).
    
    request *take-off when #landed fn [] (drone :take-off).
    request *cruising-alt when #flying until #high-enough fn [] (drone :up 0.1).
    request *land when #high-enough fn [] (drone :land).
    
    convince #done "Whee! I am done." fn [] and (navdata-equal :control-state :landed)
                                                query request-is-done *land.
    request *end-navstream when #done fn [] (end-navstream).


[video](http://www.youtube.com/watch?v=CIzR8jD2d3c)



## Conclusion and Thanks





I can honestly say, that this has been one of the most enjoyable programming quests. I encourage you all to look at McCarthy's papers, Clojure, Instaparse, and of course, hacking robots. A special thanks to all the Cincy folks at [Neo](http://www.neo.com/) who have supported me through my gentle obsessions and have let me have the freedom to follow my curiosity.
