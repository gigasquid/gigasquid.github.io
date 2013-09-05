---
author: gigasquid
comments: true
date: 2013-02-05 03:45:19+00:00
layout: post
slug: the-joy-of-flying-ar-drones-with-clojure
title: The Joy of Flying AR Drones with Clojure
wordpress_id: 645
categories:
- All
- Clojure
---

Clojure is fun.  Flying [AR Parrot Drones](http://ardrone2.parrot.com/usa/) are fun.  Put them together and there is pure joy.

Ever since I found out that you could program and control your[![](http://gigasquidsoftware.com/wordpress/wp-content/uploads/2013/02/drone-e1360035448767-225x300.jpg)](http://gigasquidsoftware.com/wordpress/wp-content/uploads/2013/02/drone.jpg) drone over UDP, I couldn't wait to try it out in Clojure.  I had dreams of controlling it with my Emacs REPL.  That dream came true and it has been a true joy to fly in a function language. This blog post shows some of the features that the [clj-drone project](https://github.com/gigasquid) has so far.  There is still a bit of work to go to make it complete.  But, I wanted to share and hopefully encourage others to start playing with it too.


## The Simple Take-off and Landing



```clojure    
    (ns clj-drone.example.simple
      (:require [clj-drone.core :refer :all]))
    
    (drone-initialize)
    ;Use ip and port for non-standard drone ip/port
    ;(initialize ip port)
    (drone :take-off)
    (Thread/sleep 10000)
    (drone :land)
````

Here is a video of executing the entire program in nrepl/ emacs

{% youtube IjKDZVUk1M8 %}



## Controlling the Drone with Emacs/ Clojure REPL


Running the program all at once to control the drone is fun. But, I prefer to have more control over it in flight. I find being able to execute commands with keystrokes in emacs, the best way to do it. Here is a short video demonstrating control via the REPL. (Note: I am just doing simple take off / up and landings because of the constraints of flying indoors in my kitchen. There are many more moves you can do if you have more space.)

```clojure    
    (ns clj-drone.example.moves
      (:require [clj-drone.core :refer :all]))
    
    (drone-initialize)
    ;Use ip and port for non-standard drone ip/port
    ;(initialize ip port)
    (drone-do-for 4 :take-off)
    (drone-do-for 2 :up 0.3)
    (drone-do-for 3.75 :fly 0.2 0 0 0.5) ; sprial
    (drone :hover)
    (drone :land)
````


{% youtube kNLx5X49Lig %}



## Looking at the Navigation Data


You can also hook into the navigation feed. There are many drone states and properties to look at. There is a list of all the ones currently available on the [github project site](https://github.com/gigasquid/clj-drone). There are also many more, including targeting information, that have yet to be added. There is a logging function that will pair down the navigation properties that you are interested in. The navigation data map as an atom, so it can be de-referenced anywhere in your program. Here is a short video of what the navigation logging data looks like when it is turned on.

```clojure    
    (ns clj-drone.example.nav-test
      (:require [clj-drone.core :refer :all]
                [clj-drone.navdata :refer :all]))
    
    ;; logging is configured to go to the logs/drone.log file
    
    (set-log-data [:seq-num :flying :battery-percent :control-state :roll :pitch :yaw
                    :velocity-x :velocity-y :velocity-z])
    (drone-initialize)
    (drone-init-navdata)
    (drone :take-off)
    (drone :land)
    (end-navstream)
````


{% youtube peQTVvsayrA %}



## Auto-piloting with goals and beliefs


Inspired by reading John McCarthy's paper on [Ascribing Mental Qualities to Machines](http://www-formal.stanford.edu/jmc/ascribing/ascribing.html), the drone can also auto-pilot itself based on goals and beliefs about its streaming navigation data. You define belief-actions and then goals. Finally, you set a vector of the current goals for the drone to process. You can see an example here of the AR drone having three goals: Take off, Get to a cruising altitude, and then land. It does it solely by inspecting and acting on the streaming navigation data.
Code for the program is here: [https://github.com/gigasquid/clj-drone/blob/master/examples/nav_goals.clj](https://github.com/gigasquid/clj-drone/blob/master/examples/nav_goals.clj)

{% youtube ujqeKFT8HdQ %}



## Go Fly!


I have had a lot of fun so far working on this project. I hope that you get a chance to play with it too. The project is still very young, so stay tuned for updates and, of course, pull requests are always welcome :)
