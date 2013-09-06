---
layout: post
title: "Controlling Multiple Drones with Clojure and Goals and Beliefs"
date: 2013-09-05 15:35
comments: true
categories:
- All
- Clojure
- AR Drones
- Development
---

## How to Control Multiple Drones with Clojure

The [clj-drone](https://github.com/gigasquid/clj-drone) library now
has multi-drone support!  You can now send multiple drones commands,
receive their navigation data, and even have them perform their
actions autonomously with goals and beliefs.

It takes a bit of extra setup to control more than one drone. We need to assign them each an
ip and get them talking as an adhoc network.
[Jim Weirich](https://twitter.com/jimweirich) creating a neat little
script to run on the drone to do just this.  Here are the
instructions:

### Change first drone to adhoc network
Connect your computer to the first drone's network.

```clojure
telnet 192.68.1.1
````

Create the following file as adhoc.sh.  This shell script will
temporarily change the network to an adhoc network named
"multidrone_ah" and assign it a static ip of 192.168.1.100.
The next time you reboot your drone, things will be back to normal.

```clojure
; This script should be run on the drone.
; Change the IP address to be difference
; for each drone on the same ad-hoc network
;
killall udhcpd
ifconfig ath0 down
iwconfig ath0 mode ad-hoc essid multidrone_ah channel auto commit
ifconfig ath0 192.168.1.100 netmask 255.255.255.0 up
````

Run the script.

### Change the second drone to the adhoc network

Connect your computer to the second drone's network.

```clojure
telnet 192.68.1.1
````

```clojure
; This script should be run on the drone.
; Change the IP address to be difference
; for each drone on the same ad-hoc network
;
killall udhcpd
ifconfig ath0 down
iwconfig ath0 mode ad-hoc essid multidrone_ah channel auto commit
ifconfig ath0 192.168.1.200 netmask 255.255.255.0 up
````

Run the script.

### On your laptop

- Connect to the adhoc network that the drones are on "multidrone_ah"
- Change your computer to a static ip on the network (from network
  preferences on mac) something like 192.168.1.101


Now you are ready to run the program.  Here is a small example of
sending simple commands:

```clojure
(drone-initialize :drone1 "192.168.1.100" default-at-port default-navdata-port)
(mdrone :drone1 :take-off)
(mdrone :drone1 :land)

(drone-initialize :drone2 "192.168.1.200" default-at-port default-navdata-port)
(mdrone :drone2 :take-off)
(mdrone :drone2 :land)
````
## Bring on Multiple Drones interacting with Goals and Beliefs

The clj-drone library implements goals and beliefs from [John
McCarthy's work](http://localhost:4000/blog/2012/09/20/7-john-mccarthy-papers-in-7-weeks-1/).
The way this works is that the navigation data being constantly sent
to our computer for processing.  Everytime we get a navigation packet
that ends up looking something like this, (but with lots more data):

```clojure
 {:altitude 0.0, :yaw -0.215, :pitch -1.075, :roll -2.904, :control-state :landed, :communication :ok, :com-watchdog :ok, :seq-num 870}
````

We then define a belief-action using this data.

```clojure
(def-belief-action ba-landed1
  "I (Drone1) am landed"
  (fn [{:keys [control-state]}] (= control-state :landed))
  (fn [navdata] (mdrone :drone1 :take-off)))
````

The def-belief-action macro takes:

* Name of the belief action
* A readable sentence that expresses the belief.  (This is later
  logged, so that we know what the drone believes at all times.)
* A predicate that takes in the navigation data as a parameter.  When
  it evaluates to true, then the belief is said to be "held".
* A function to execute when the belief is held

The beliefs are then combined to form goals.

```clojure
(def-goal g-take-off1
  "I (Drone1) want to fly."
  (fn [{:keys [control-state]}] (= control-state :hovering))
  [ba-landed1 ba-taking-off1])
````

The def-goal macro takes:

* The name of the goal
* A readable sentence that expresses the goal. (This is later logged,
  so that we can know when it achieves a goal.)
* A predicate that takes in the navigation data as a parameter.  When
  it evaluates to true, the goal is said to be achieved.  It will no
  longer evaluate or hold any of the belief actions associated with
  that goal.

Finally, we can set a list of goals for a drone to achieve:

```clojure
 (set-current-goal-list drones :drone1
 [g-take-off1 g-find-other-drone-and-wave1 g-land1])
```

This sets the goal list for a drone.  It will take-off, look around
for the other drone and wave, (do a dance), once it sees it.  Finally,
after both drones have spotted each other and waved, they will both
land.

## Video or It Didn't Happen

Here is a video of both drones.  They will take off, look around for
each other and wave when they spot each other.  They will land when
the have both waved.  They are operating solely on goals and beliefs
with their navigation data.

{% youtube J65rvPdJQ0c %}


The code running the video above can be found in the examples of the
[clj-drone](https://github.com/gigasquid/clj-drone/tree/master/examples).

Happy Hacking!

