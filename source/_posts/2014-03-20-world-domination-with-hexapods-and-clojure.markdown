---
layout: post
title: "World Domination with Hexapods and Clojure"
date: 2014-03-20 21:00
comments: true
categories:
- Robots
- Clojure
- World Domination
---

Once you have your [hexapod assembled and running using the hand held
controller](http://gigasquidsoftware.com/blog/2014/03/19/walking-with-hexapods/),
of course, your thoughts naturally turn to world domination.

## The most powerful tool in the world is the Clojure REPL

World domination requires the most powerful tools available.  That of
course calls for Clojure and the Clojure REPL.  I recommend Emacs
as the editor of choice of such an endeavor.  However, it if you are
content with city, state, or single country domination, other editors
that support Clojure are also fine.


## Connect the XBee to your computer

First, we need to get the computer to talk to the hexapod wirelessly.
We can do this with a [USB to Serial adapter](http://www.trossenrobotics.com/uartsbee)
that uses the paired XBee from the handheld commander.


Take the XBee from the handheld commander

{% img http://farm4.staticflickr.com/3698/13278059985_f5b5c01819_n.jpg %}

and move it to the USB to serial adapter

{% img http://farm8.staticflickr.com/7067/13298779543_f69a14b42c_n.jpg %}

Now plug the usb into your computer.


## Get your Clojure ready

In your clojure project, the only magic you need is the [Serial Port library](https://github.com/samaaron/serial-port). Import the library and list your serial ports.  Then open the one that shows up for you.


```clojure
(ns clj-hexapod.core
  (require [serial-port :as serial]))
 
;; Use this command to see what port your serial port
;; is assinged to
(serial/list-ports)
 
;; replace the USB0 with whater it shows
(def port (serial/open "/dev/ttyUSB0" 38400))
```

Since we are going to be talking to the hexapod.  We need to send the commands in the same format that it is expecting. Basically, a packet of where the postions of the joystick are, as well as what buttons are pushed.


```clojure
(defn checksum [v]
  (mod (- 255 (reduce + v)) 256))
 
(defn vec->bytes [v]
  (byte-array (map #(-> % (Integer.) (.byteValue) (byte)) v)))
 
(defn build-packet [r-vert r-horz l-vert l-horz buttons]
  [255 ;header
   r-vert
   r-horz
   l-vert
   l-horz
   buttons
   0
   (checksum [r-vert r-horz l-vert l-horz buttons])])
 
(defn send [packet]
  (serial/write port (vec->bytes packet)))
```

From here, we can simply make functions for the joystick controls to go up and down

```clojure
;;values between 129-254
(defn up [speed]
  "joystick up for speed between 1-100"
  (if (good-range? speed)
    (int (+ 129 (* 125 (/ speed 100.0))))
    CENTER))
 
;;values between 0 and 125
(defn down [speed]
  "joystick down speed between 1-100"
  (if (good-range? speed)
    (int (- 125 (* 125 (/ speed 100.0))))
    CENTER))
```

Then we can do things like walk, turn, and change the gait

```clojure
(defn walk-forward [speed]
  "walk forward speed between 1-100"
  (send (build-packet CENTER CENTER (up speed) CENTER 0)))
 
(defn walk-backwards [speed]
  "walk backwards speed between 1-100"
  (send (build-packet CENTER CENTER (down speed) CENTER 0)))
 
(defn walk-right [speed]
  "walk right speed between 1-100"
  (send (build-packet CENTER CENTER CENTER (up speed) 0)))
 
(defn walk-left [speed]
  "walk right speed between 1-100"
  (send (build-packet CENTER CENTER CENTER (down speed) 0)))
 
(defn turn-right [speed]
  "turn right speed between 1-100"
  (send (build-packet CENTER (up speed) CENTER CENTER 0)))
 
(defn turn-left [speed]
  "turn left speed between 1-100"
  (send (build-packet CENTER (down speed) CENTER CENTER 0)))
 
(defn change-gait [gait-key]
  (let [gait-num (gait-key gaits)]
    (send (build-packet CENTER CENTER CENTER CENTER gait-num))))
 
(defn stop []
  "stop hexapod"
  (send (build-packet CENTER CENTER CENTER CENTER 0)))
```

You can control it from the REPL with some simple commands

```clojure
(walk-forward 20)
(walk-backwards 10)
(walk-right 10)
(walk-left 10)
(turn-right 10)
(turn-left 10)
(change-gait :ripple-smooth)
(change-gait :tripod-normal)
(change-gait :ripple)
(change-gait :amble)
(stop)
```

If you want to see the code, it is out on github as [clj-hexapod](https://github.com/gigasquid/clj-hexapod).  Please keep in mind that it is early days still, and I am still just exploring.


## Phoneix Code Firmware

It is worth noting the the above code was meant to run with the default hexapod firmware.  That is the "Nuke" firmware.  There is another firmware, the [Phoenix code](https://github.com/KurtE/Arduino_Phoenix_Parts), that gives the hexapod more lifelike moves and allows it to twist and shift is rather creepy ways.

I just loaded it on the hexapod yesterday.  The commander software changed too, so I will of course need to revisit the code, to add in the new moves.  But here is a sneak preview of what it can do:

{% youtube PmBGt9T-yvI %}

*That is my daughter singing in the background*

## That's all for now

I hope I have given you pointers for getting started on your own world domination with Clojure and Hexapods. Remember to practice your laugh .... Muhahaha :)








