---
author: gigasquid
comments: false
date: 2011-01-18 03:01:47+00:00
layout: post
slug: vampire-slaying-in-clojure-with-stm-part-2
title: Vampire Slaying in Clojure with STM - Part 2
wordpress_id: 143
categories:
- Clojure
---

In Part 1, we used defrecords to create a vampire slayer named “Buffy” and a few vampires for her to kick around.  Today we are going to use Buffy and her vampires to explore STM (Software Transactional Memory) in Clojure for managing state.

Recap


    
    
    (defrecord Vampire [name, health])
    (def vampire1 (Vampire. "Stu" 50))
    (def vampire2 (Vampire. "Vance" 100))
    (def vampire3 (Vampire. "Izzy" 75))
    
    (defrecord Slayer [name, weapon])
    (def kungfu 25)
    (def buffy (Slayer. "Buffy" kungfu))
    
    (defn hit [vampire, hitpoints]
      (- (:health vampire) hitpoints))
    
    ;vampires don't fight back but it takes time to kill them
    (def combat-time 20)
    
    (defn hit-vampire [vampire, slayer]
      (Thread/sleep (* combat-time 10))
      (assoc vampire :health (hit vampire (:weapon slayer))))
    
    (defn kill-vampire [vampire, slayer]
      (if (> (:health vampire) 1)
        (recur (hit-vampire vampire slayer) slayer)
        (assoc vampire :health 0)))
    




Let's take our vampires and stand them up in a line for Buffy to fight.  We are also going to create a function that just has Buffy killing a vampire, rather then a generic slayer.

    
    
    (def vampire-line [vampire1 vampire2 vampire3])
    
    (defn buffy-kill-vampire [vampire]
      (kill-vampire vampire buffy))
    
    



Test Buffy killing vampire1

    
    
    (buffy-kill-vampire vampire1)
    #:user.Vampire{:name "Stu", :health 0}
    



Now we can use the map function to apply the buffy-kill-vampire function to every vampire in our vampire line.


    
    
    (map buffy-kill-vampire vampire-line)
    (#:user.Vampire{:name "Stu", :health 0} #:user.Vampire{:name "Vance", :health 0} #:user.Vampire{:name "Izzy", :health 0})
    



This is also a good time to bring up pmap (pmap f coll).  The pmap is the same as the map execpt that it applys the function to the collection in parallel.  It is useful when the time to process each function is computationally intensive.  To show the difference between map and pmap let's change the combat-time to be 200ms instead of 20ms and time each way.  We need a dorun to force the function to not be lazy.


    
    
    (def combat-time 200)
    
    (time (dorun (map buffy-kill-vampire vampire-line)))
    "Elapsed time: 18002.67764 msecs"
    
    (time (dorun (pmap buffy-kill-vampire vampire-line)))
    "Elapsed time: 8001.808821 msecs
    
    



Now if you notice, even though we have be killing the vampire line over and over again.  They don't stay dead

    
    
    vampire-line
    [#:user.Vampire{:name "Stu", :health 50} #:user.Vampire{:name "Vance", :health 100} #:user.Vampire{:name "Izzy", :health 75}]
    



We need to involve some state so that our vampire-line will reflect the health of zero for all of the vampires once Buffy slays them.  In Clojure, state is handled by Software Transactional Memory (STM).  You can use Refs for coordinated and synchronous updates, Atoms for Uncoordinated and Synchronous updates, or Agents for asynchronous updates.  In our example, we are going to use the Atom, since it is lighter weight and we just want to maintain the state of the vampire-line.  

Let's refine the vampire-line as an atom.  We 

    
    
    (def vampire-line (atom [vampire1 vampire2 vampire3]))
    



We need to deference it now to know it's value

    
    
    @vampire-line
    [#:user.Vampire{:name "Stu", :health 50} #:user.Vampire{:name "Vance", :health 100} #:user.Vampire{:name "Izzy", :health 75}]
    



Now we are going to redefine the buffy-destroy-all-vampires function to use the reset! function to update its value.  We also need to convert the result to a vector before calling reset!  Also note that we need to deference the vampire-line value when call using map.


    
    
    (defn buffy-destroy-all-vampires []
      (reset! vampire-line (vec (map buffy-kill-vampire @vampire-line))))
    



Now let's see what happens when Buffy kills them

    
    
     @vampire-line
    [#:user.Vampire{:name "Stu", :health 0} #:user.Vampire{:name "Vance", :health 0} #:user.Vampire{:name "Izzy", :health 0}]
    
    (buffy-destroy-all-vampires)
    [#:user.Vampire{:name "Stu", :health 0} #:user.Vampire{:name "Vance", :health 0} #:user.Vampire{:name "Izzy", :health 0}]
    
     @vampire-line
    [#:user.Vampire{:name "Stu", :health 0} #:user.Vampire{:name "Vance", :health 0} #:user.Vampire{:name "Izzy", :health 0}]
    
    



The vampires are finally dead and staying dead!  Score one for the good guys!



 







