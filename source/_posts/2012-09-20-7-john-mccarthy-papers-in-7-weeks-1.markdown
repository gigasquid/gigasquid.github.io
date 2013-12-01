---
author: gigasquid
comments: true
date: 2012-09-20 13:03:36+00:00
layout: post
slug: 7-john-mccarthy-papers-in-7-weeks-1
title: '7 John McCarthy Papers in 7 weeks – #1 How My Thermostat has Beliefs and Goals'
wordpress_id: 477
categories:
- Development
- John McCarthy Papers
---

{% img http://farm1.staticflickr.com/199/447335691_8a933251ab_n.jpg %}


## Ascribing Mental Qualities to Machines or How My Thermostat has Beliefs and Goals


After reading John McCarthy's paper this week [Ascribing Mental Qualities to Machines](http://web.archive.org/web/20131014084908/http://www-formal.stanford.edu/jmc/), I can honestly say that it has changed the way I think about programs and most certainly thermostats. For you see, I realize now that my thermostat has beliefs and goals. No, it does not have beliefs about what the weather is going to be tomorrow, or when the next George R.R. Martin book is going to come out. But it does have beliefs. It has three of them to be exact:



	
  * The room is too hot

	
  * The room is too cold

	
  * The room is OK


It also only has one goal:

	
  * The room should be OK




### Wat?


Why should we think of a simple thermostat this way? It is not very complex. In fact, we can completely understand its state and reason about its behavior by looking at its small and complete program listing. What benefit can there possibly be to endow the humble thermostat with its own beliefs and goals?


### Start Small


Let's step back. We are talking about designing and building intelligent systems, not just programs. The example of a thermostat is indeed small, but let us try out our ideas on a easy to understand system first. Later we can consider applying it to more complex systems.


### Beliefs and Goals are Easier to Understand and Reason About


Using a higher level construct to express state can make it easier to reason and understand intelligent systems. It also is useful in describing states that are not completely known or have portions that are not easily observable. In short, defining a program's state in terms of beliefs and goals may be closer to our natural way of thinking. When I consider my co-worker sitting next to me. I cannot hope to observe the complete mental state of him at that moment. Although I could hope to describe it at a high level with beliefs and goals. I could even hope to predict future behavior with this knowledge of his beliefs and goals, (which most likely has to do with the goal of eating more bacon).


### Easier to Debug and Correct


Once we have a higher level model of a systems mental state and behavior. It would be easier to debug, communicate, and correct problems. For example, If I come home and the room is way too cold, I could look for the problem in terms of beliefs and goals. Does the thermostat have a faulty belief? Or did it have a good belief that the room was too cold? If so, then the problem was that it could not act on its belief to tell the furnace to turn on. If it could communicate and know the problem, perhaps it could message me and I could arrange a service call, or it could even self-correct. Another example, is my recent experience with my Roomba. I came home the other day to find my Roomba had not returned to its charging station after its scheduled cleaning. Instead, it was stopped under my bed. What went wrong? Did it believe that the battery was low? Or was there some other faulty belief? It would be nice if it could tell me.


### Delving Further - What is a belief?


McCarthy talks about defining a belief as a function of the system's state. For each state, there are beliefs that can be expressed as a sentences in a language. The machine does not need to understand the meaning and concepts in the English, French or any given language. That is for us to interpret. The important part is that there is a mapping of the state to this sentence. Taking our humble thermostat for an example:

    
    (defn thermo-belief [temp]
      (cond
        (> temp 70) "The room is too hot."
        (< temp 70) "The room is too cold."
        :else "The room is OK."))


We can test our thermostats beliefs with something like:

    
    (deftest thermo-beliefs-tests
      (is (= "The room is too hot." (thermo-belief 71)))
      (is (= "The room is too cold." (thermo-belief 69)))
      (is (= "The room is OK." (thermo-belief 70))))


This testing or criticizing the belief structure of the thermostat is what McCarthy called a Second Order Structural definition for mental qualities. This differs from a First Order Structural definition in that, rather than criticizing or testing an individual belief, he sought to describe them by testing/ criticizing the structure of the whole set of beliefs.

In the example of our thermostat, to have a "good" belief structure, in accordance with Second Order Structural definition, it the must have some consequences or actions of it beliefs. Furthermore, these actions most be consistent with its goals.

It might be expressed in code like this:

    
    (defn thermo-action [belief temp]
      (case belief
        "The room is too hot." (dec temp)
        "The room is too cold." (inc temp)
        "The room is ok." temp))


In this case, the action of a belief is returning a new state, the temperature. Our thermostat could issue a command to the furnace to turn on. But, let us keep it simple for the moment and just think of its action directly changing the temperature. Now, our believing thermostat program can be described as having beliefs as well as taking actions from them.

    
    (defn thermostat [temp]
      (thermo-action (thermo-belief temp) temp))
    
    (thermostat 33) ;=> 34


So now we have a thermostat that has beliefs and consequences from these beliefs. We still need to figure out how to test that its belief system is consistent with its goals. Thankfully, it only has one goal to keep it simple. The goal is that the room should be OK.

    
    (def goal 70)


Let's say that the thermostat is doing what it believes will achieve its goals, if the new temperature is closer to its goal.

    
    (defn distance-from-goal [g t]
      (Math/abs (- g t)))
    
    (distance-from-goal goal 80) ;=> 10
    
    (defn closer-to-goal [g t nt]
      (> (distance-from-goal g t)
        (distance-from-goal g nt)))
    
    (closer-to-goal goal 75 73) ;=> true
    (closer-to-goal goal 75 76) ;=> false
    (closer-to-goal goal 56 57) ;=> true
    


We can now construct a test to see if the thermostat actions are consistent with its goals.

    
    
    (deftest themo-behavior-test
      (is (closer-to-goal goal 4 (thermostat 4)))
      (is (closer-to-goal goal 74 (thermostat 74)))
      (is (closer-to-goal goal 75 (thermostat 75)))
      (is (closer-to-goal goal 56 (thermostat 56))))
    


Given this particular thermostat example, we could even recursively show that it will reach its goal:


    
    
    (defn thermo-simulation [g s]
    (if (= g s) "Woo hoo!"
    (thermo-simulation g (thermostat s))))
    
    (thermo-simulation goal 73) ;=>; "Woo hoo!"
    
    (deftest thermo-goal-achievement-test
    (is (= "Woo hoo!" (thermo-simulation goal 73)))
    (is (= "Woo hoo!" (thermo-simulation goal 100)))
    (is (= "Woo hoo!" (thermo-simulation goal 33)))
    (is (= "Woo hoo!" (thermo-simulation goal -33))) )
    



Our thermostat's beliefs are good!


### What if ....


The way that McCarthy explains the Second Order Structural definition as criticizing and testing beliefs, made me start thinking about test driven design. What if we were to start thinking and designing our programs with this testing of belief and goal structure? It could be IDD (Intelligence Driven Design) rather than TDD/ BDD. From experience, I know that TDD has changed the way that I think about coding and resulted in cleaner and more robust programs. I wonder what effect IDD could have on our program's creation and perhaps the future of AI. Could changing the way we approach our definition of state and behavior change our software to become more intelligent? Wait a minute. If we write a test system to criticize another programs beliefs and goals, wouldn't we be designing a program that would have beliefs about another program's beliefs?

...

...

My brain get exploded.
It is in fact, turtles all the way down :)
