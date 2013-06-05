---
author: gigasquid
comments: false
date: 2011-01-12 03:33:43+00:00
layout: post
slug: vampire-slaying-with-clojure-part-1-defrecord
title: Vampire Slaying with Clojure  - Part 1 defrecord
wordpress_id: 133
categories:
- All
- Clojure
---

It's time to learn more Clojure.  This time, Buffy the Vampire Slayer* is going to help us.  

First things first, of course we need vampires!

Let's create a vampire data type with defrecord.  Our vampires are going to have two attributes, their name and the number of health points that they have.  This is of course, how Buffy is going to slay them.  If a vampire's health points goes to zero, then they are dead.  Well, they already are undead... so let's say they are slayed at that point and turn into dust.

Our first vampire's name is Stu and he has a health of 50.

    
    
    (defrecord Vampire [name, health]) 
    (def vampire1 (Vampire. "Stu" 50))
    
    



When we type in the vampire1 value into the REPL we can see its values in a map format 

    
    
     vampire1
    #:user.Vampire{:name "Stu", :health 50}
    



Now we can access vampire1's name by using the keys defined in the defrecord.  Let's get his name.

    
    
    (:name vampire1)
    "Stu"
    



And his health


    
    
    (:health vampire1)
    50
    



Lovely.  But we are going to need more than one vampire for Buffy to fight.  Let's create some more.

    
    
    (def vampire1 (Vampire. "Stu" 50))
    (def vampire2 (Vampire. "Vance" 100))
    (def vampire3 (Vampire. "Izzy" 75))
    



Alright.  Our evil doers are ready for a fight.  Where is our hero?  We need to create a slayer structure using defrecord like before.  Our vampire slayer is going to have a name and a weapon that is worth a certain number of hit points.  Buffy is such a hard case that she is just going to use her bare hands.  We'll define her kungfu to be worth 25 hit points.


    
    
    (defrecord Slayer [name, weapon])
    (def kungfu 25)
    (def buffy (Slayer. "Buffy" kungfu))
    



Let's check to make sure Buffy is ready to go

    
    
    (:name buffy)
    "Buffy"
    (:weapon buffy)
    25
    



We have our main characters.  Now we need a way for Buffy to hit the vampires.  A simple function will do.  We define a function that takes the vampire and the number of hitpoints and subtracts it from the vampire's health.  This gives us the new health of the vampire


    
    
    (defn hit [vampire, hitpoints]
      (- (:health vampire) hitpoints))
    
    (hit vampire1 20)
    30
    



Now let's take that one step further and create another function that allows the slayer to hit the vampire with his/her weapon.  We use out hit function and pass it the weapon of the slayer.  Then we change the value of the vampire's health to the new value with assoc.  The function returns a new vampire structure with the new decremented health.

    
    
    (defn hit-vampire [vampire, slayer]
      (assoc vampire :health (hit vampire (:weapon slayer))))
    
     (hit-vampire vampire1 buffy)
    #:user.Vampire{:name "Stu", :health 25}
    



Our vampires are totally lame, they don't fight back, (at least in this code example), but it does take time for Buffy to kill them.  Let's define a time that it take for her to hit a vampire.

    
    
    (def combat-time 20)
    



We'll go back and redefine the hit-vampire function to include a sleep


    
    
    (defn hit-vampire [vampire, slayer]
      (Thread/sleep (* combat-time 10))
      (assoc vampire :health (hit vampire (:weapon slayer))))
    



Now we can see how much time it takes Buffy to hit vampire1


    
    
     (time (hit-vampire vampire1 buffy))
    "Elapsed time: 200.454173 msecs"
    #:user.Vampire{:name "Stu", :health 25}
    



This is nice, but we really want a way to define a function to recursively have the slayer keep hitting the vampire until it is dead.  If the health of the vampire is less than 1, then then we will set the vampire's health to 0 and return the vampire.  Note that we use recur in the function to denote the recursive call.

    
    
    (defn kill-vampire [vampire, slayer]
      (if (> (:health vampire) 1)
        (recur (hit-vampire vampire slayer) slayer)
        (assoc vampire :health 0)))
    



Testing it out with Buffy killing Stu the vampire1

    
    
    (kill-vampire vampire1 buffy)
    #:user.Vampire{:name "Stu", :health 0}
    



How long does it take Buffy to kill Stu? Not long.

    
    
    (time (kill-vampire vampire1 buffy))
    "Elapsed time: 400.542595 msecs"
    #:user.Vampire{:name "Stu", :health 0}
    



What about a tougher vampire like vampire2?

    
    
    vampire2
    #:user.Vampire{:name "Vance", :health 100}
    
    (time (kill-vampire vampire2 buffy))
    "Elapsed time: 801.318529 msecs"
    #:user.Vampire{:name "Vance", :health 0}
    



For fun, let's redefine Buffy and give her some Holy Water as a weapon and see what happens.


    
    
    (def holy-water 100)
    (def buffy (Slayer. "Buffy" holy-water))
    
    (time (kill-vampire vampire2 buffy))
    "Elapsed time: 200.247375 msecs"
    #:user.Vampire{:name "Vance", :health 0}
    




So there you have it.  We have explored defrecord and created some vampires for the express purpose of hitting.  Not a bad way to blow off steam at the end of the day.  

Stay tuned for part 2, where Buffy will line up the vampires and kill them using Clojure's STM (Software Transaction Memory System) so they stay dead (or undead).
















* If you are a lawyer and object to Buffy the Vampire Slayer appearing in an code snippets as a Clojure var, please contact me and I will change the name to Biffy or Tiffy.

_Lego Vampire: http://www.flickr.com/photos/pasukaru76/4274684369_
