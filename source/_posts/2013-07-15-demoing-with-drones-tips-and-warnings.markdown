---
layout: post
title: "Demoing with Drones: Tips and Warnings"
date: 2013-07-15 15:42
comments: true
categories:
- All
- Drone
---

Lately, I have had the pleasure of speaking and sharing my experience
of programming [AR Drones](http://ardrone2.parrot.com/) with Clojure.  However, doing live hardware
demos has not always been a smooth ride.  In fact, it can be fraught
with peril.  I thought that I would share some of the tips and tricks
that have helped me, as well as help make you
aware of some potential pitfalls.


## Traveling with the AR Drone
{% img left http://farm6.staticflickr.com/5332/9301848814_1633857d6d.jpg %}

Do you need to take your drone with you on the plane to the demo?
The box that the drone comes in is a very nice carrying case, however it
is too big to take on as a carry-on.  I found that taking the hull
off, and packing it into a plastic box worked well.  It was small
enough to pack under the seat of even the smaller planes.  I took the
battery out and packed it in my checked luggage.





## Before the Demo

- **Put colored masking tape on the floor** : If the floor is
    featureless, the drone will have a hard time staying in one place
    while it is hovering.  Put down some strips of colored masking
    tape in the area that you want to demo the drone.

- **Charge the spare battery**:  Make sure that you have at least 2
    batteries charged and ready to go.  If there is an extra plug
    nearby, just plug in the battery and charger until you are ready
    to present.

- **Beware the network interference**:  In some larger venues, like
    hotels, the network traffic will make things break.  In
    particular, receiving navigation data back from the drone. There
    are possible strategies for mitigating this - the only one I have
    tried so far is to bump up the timeout on the UDP connection.
    Other things that you may want to try would be to auto-reconnect
    after timeout.  Also limiting the amount navdata you need might
    also work.

- **Backup videos** - Having backup videos of your demo actually
    working is essential.  It is safety net that will allow you to
    sleep the night before.  Like they say, "Hope for the best, but
    plan for the worst".

- **Rehearse** - If possible, go through your drone demos in the space
    sometime before the talk.  You will get a feeling for issues that
    might occur - like network troubles.

## Demo Time!

- **Front row drone catchers** - Enlist the aid of your audience.
    Show the people in the front row how to catch a drone safely and
    hold it at a 90 degree angle so the engine cuts out.  That way, if
    the drone starts going off in unplanned ways, you will have help.

- **Cross your fingers and have fun** - Good luck.  Hardware demos are
    a lot of fun.  Hopefully, everything we work as planned, but if
    not - at least it was interesting.







