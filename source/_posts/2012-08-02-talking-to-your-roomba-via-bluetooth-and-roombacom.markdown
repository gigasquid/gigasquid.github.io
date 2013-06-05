---
author: gigasquid
comments: true
date: 2012-08-02 18:29:37+00:00
layout: post
slug: talking-to-your-roomba-via-bluetooth-and-roombacom
title: Talking to your Roomba via Bluetooth and RoombaComm
wordpress_id: 441
categories:
- All
---

I love Roomba. It cleans our floors and it can be [hacked](http://www.irobot.com/images/consumer/hacker/roomba_sci_spec_manual.pdf) to help teach my kids programming. Win!

Here are the setup steps that I used to get going talking to Roomba:



	
  * Ordered a [Rootooth](https://www.sparkfun.com/products/10980?) bluetooth connection for Roomba.  I could have build one from [scratch](http://hackingroomba.com/projects/build-a-roomba-bluetooth-adapter/), but I am a busy mom and hacker.

	
  * Removed the cover from Roomba to expose the ROI port ([Video](http://www.youtube.com/watch?v=EaZibdOIeD0)).

	
  * Setup the Bluetooth adapter on my Mac

	
    * Start Bluetooth network assistant

	
    * Have the firefly adapter deteted

	
    * Enter the passkey: 1234

	
    * Click edit serial ports to see what port it assigned.  Mine was FireFly-943A-SPP.  Alternatively, you can look at /dev directory

	
    * Next, you need to configure the baud rate for your Roomba. I found these [instructions](http://www.robotappstore.com/Knowledge-Base/3-Serial-Port-Baud-Rate-Configuration/17.html) helpful

	
    * Install zterm on your mac  - set the serial port to your roomba and the baud rate to the correct baud rate

	
    * On zterm you now should be able to echo any key you type




	
  * Download[ RoombaComm](http://hackingroomba.com/code/roombacomm/) java package

	
  * Look at the README.  You will need to run makeit.sh to build and ./rxtxlib/macosx_setup.command (for Macs)

	
  * Finally run RoombaCommTest.sh to connect up and control your Roomba!


