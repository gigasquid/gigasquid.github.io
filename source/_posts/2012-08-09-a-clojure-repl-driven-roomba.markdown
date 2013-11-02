---
author: gigasquid
comments: true
date: 2012-08-09 20:03:52+00:00
layout: post
slug: a-clojure-repl-driven-roomba
title: A Clojure REPL Driven Roomba
wordpress_id: 450
categories:
- All
- Clojure
---


{% img http://farm3.staticflickr.com/2826/9925780955_4a32b8dc8a_o.jpg %}
One of the things that I love about Clojure is that it can go anywhere that Java can.  That is why, when I found out that the Roomba already had a [Java library](http://hackingroomba.com/code/roombacomm/) written for it - I was excited to be able to hook it up to my Emacs / Swank and be able to control it from my editor.

It is great fun!  If you have a Roomba at home and you want to play along...



  
  1. 
    Read [Setting up and Configuring Bluetooth and Roomba part from this post](http://gigasquidsoftware.com/wordpress/?p=441).
   
  2. Checkout the sample project [clj-roomba](https://github.com/gigasquid/clj-roomba) from github.


Have fun doing this like this:

    
    
    (def roomba (RoombaCommSerial. ))
    
    ;;Find your port for your Roomba
    (map println (.listPorts roomba))
    (def portname "/dev/cu.FireFly-943A-SPP")
    (.connect roomba portname)
    (.startup roomba)  ;;puts Roomba in safe Mode
    ;; What mode is Roomba in?
    (.modeAsString roomba)
    (.control roomba)
    (.updateSensors roomba) ; returns true if you are connected
    
    
    (.pause roomba 30)
    (.playNote roomba 72 40)
    (.playNote roomba 79 40)
    (.spinLeft roomba)
    (.spinRight roomba)
    (.goBackward roomba)
    (.goForward roomba)
    (.turnLeft roomba)
    (.turnRight roomba)
    
    (.stop roomba)
    (.reset roomba)
    (.vacuum roomba true)
    (.vacuum roomba false)
    (.clean roomba)
    
    ;; Get the sensor data
    (.updateSensors roomba) 
    (.bumpLeft roomba)
    (.bumpRight roomba)
    (.wheelDropLeft roomba)
    (.wheelDropRight roomba)
    (.wheelDropCenter roomba)
    (.sensorsAsString roomba)
    
    
    (defn bark [r]
      (doto r
        (.vacuum true)
        (.playNote 50 5)
        (.pause 150)
        (.vacuum false)))
    
    (bark roomba)
    
    



[A quick video of hacking Roomba in action](http://cl.ly/Idv5)

Next up - Getting more roombas to implement Rich Hickey's [ant colony demo](http://juliangamble.com/blog/2011/12/28/clojure-gui-demo-of-ants/)...
