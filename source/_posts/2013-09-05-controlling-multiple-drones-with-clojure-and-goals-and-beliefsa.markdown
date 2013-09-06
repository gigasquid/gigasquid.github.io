---
layout: post
title: "Controlling Multiple Drones with Clojure and Goals and Beliefsa"
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

It takes a bit of extra setup to control more than one drone.  To be
able to talk to more than one drone, you need to assign them each an
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
(mdrone :drone2 :take-off)
(mdrone :drone2 :land)

(drone-initialize :drone2 "192.168.1.200" default-at-port default-navdata-port)
(mdrone :drone1 :take-off)
(mdrone :drone1 :land)
````
## Bring on Multiple Drones interacting with Goals and Beliefs

