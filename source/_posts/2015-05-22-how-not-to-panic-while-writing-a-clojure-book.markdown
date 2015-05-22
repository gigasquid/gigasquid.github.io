---
layout: post
title: "How Not to Panic While Writing a Clojure Book"
date: 2015-05-22 09:11
comments: true
categories:
- All
- Clojure
---

I made it to that magical moment when the Clojure book I had been working on so long was published and I could actually hold it in my hand.

{% img https://pbs.twimg.com/media/CDWsQPCUgAERViK.jpg %}

It was an immense project and I am very happy that it is finally done.  Since then, I met some people that are interested in writing books as well.
They asked if I had any insights or tips having gone through the process as a first time author.  I have collected them in this post in hopes that they will be helpful to those going through the process themselves.

The very first thing to do is to get an outline for your book.


### Start with an Outline

Ideas are soft and squishy.  They drift into different shapes like clouds, and can melt away just as quickly.  One of the hardest things to do was trying to arrange all those ideas in my head into an initial form that would serve as the structure for the entire book.  I would pick up a pen and paper, start feeling overwhelmed, and suddenly remember I had something else very pressing to do.  I successfully avoided starting a book for quite a while, until one day I cornered myself.  I decided that I write my book outline on a long plane flight.  With salted peanuts as fuel, and nowhere to escape, I finally wrote an outline.  It wasn't perfect but it was a start and looking back and it was not too far off.  Here it is in all of its original roughness.

```
Title: Living Clojure

From beginning steps to thriving in a functional world


(Each Chapter will follow quotes from Alice in Wonderland and very use ideas from some examples)


Book 1 - Beginner steps

Chapter 1 - Are you comfortable?  Talk about how OO is comfortable but there is another world out there and new way of thinking functionally.
            White Rabbit goes by
Chapter 2 - Forms & Functions - Falling down the rabbit hole
Chapter 3 - Functional Transformations - Growing bigger and smaller - Key to thinking functionally is about transforming data from one shape to another shape.
            Map & Reduce
Chapter 4 - Embracing side effects  - Clojure is impure functional language (The rabbit's glove)  - Cover do and io stuff. Also basic stuff about 
            STM atoms and agents/ Protocols
Chapter 5 - Libraries, Libraries  - - how to use Leiningen
            build system. Where to find clojure libraries, how to use
            Serpents - camel-snake-kebab
Chapter 6 - core.asyc - Tea Party introduction to the core.async library
Chapter 7 - Clojure web - Chesire cat  - introduction to Ring, Cheshire library, ClojureScript and OM 

Book 2 - From here to there - thriving in a functional world

Training plan for thriving in a functional world.

Chapter 8 - Join the community - Surround yourself with other Clojure enthusiats
  - Twitter clojure
  - Github account
  - Clojure mailing list
  - Prismatic clojure news
  - Meetup for local community group.  If there is not one in your area. start one!
  - Attend a Clojure conj


Chatpter 9 - Practice and build up 
Like Couch to 5K 7 week training program to work up to
practicing Clojure

```

Now that I had an outline.  I just needed to figure out how long it would take me to write the book.

### However Long You Think It Will Take - You Are Wrong

Having never written a book before, I had _no idea_ how much work it would be.  The closest thing I had to compare it to was writing a blog post.  I figured writing a chapter would be roughly equivalent to writing a blog post.  If I could go back in time, this is the moment where my future self would pour a glass of ice water on my past self.  Writing a book is nothing like that.  It is a lot of time and work.  If I _had_ to compare it now to writing blog posts, the process would be this.

    - You write a blog post.
    - You rewrite the blog post.
    - You write a second blog post.
    - You rewrite that blog post and the first one too.
    - You write another blog post.
    - You rewrite all three post .....


So, if you have to commit to deadlines, make sure you remember how hard it will be, and then double the number.

Speaking of deadlines, they suck, but you should have them.

### Make Deadlines

Deadlines are not fun.  In fact, deadlines might even be a source of potential panic.  But for me, they were necessary evil.  There were a few beautiful times when inspiration came knocking at my door and I couldn't wait to start writing.  But most of the time, inspiration was off somewhere else eating biscuits.  The only thing that actually moved the book along was me knowing that I needed to get the next chunk done by a certain date.

I found the best thing to do was to set aside a small bit of time on a daily basis to write something.

### Routine, Routine, Routine

A daily routine was the most crucial thing for me.  Life is really busy with work and family.  It is so easy to get overwhelmed with daily life.  I decided that mornings would work best for me.  So I would stumble in to my computer an hour before work, with a hot cup of tea in hand, and write something.  Some days I actually did quite a bit.  Other days, I would write one sentence and declare it done.  But, I would always do _something_.  Even though those small slices of time didn't seem like a lot, they added up over the course of a week.

Another curious thing happens when you do something, even a little bit, day after day.  You start to get better at it.

###  Writing is a Different Skill from Coding

I was used to writing code all day.  I found that the code writing skills are not the same as writing about code.  In fact, I found it really hard to do at the start.  But, just like writing code, you get better with practice.  To get better at anything, feedback is really important.

### Get and Trust Feedback

After each chapter, I would get feedback from my editor.  She was awesome and provided ways for me to improve the experience for the reader.  I lost track of how many times I rewrote that first chapter, but each time it would get a bit better and I would improve as well.  After the book was about half done it was sent out to others for technical review.  They provided feedback not only on the writing style but also the technical content, making sure that it all made sense.

The feedback loop is much slower for writing a book than writing code, but it is just as vital.  The great people providing feedback are you closest partners in this.  You need to trust them.  Especially during the roughest time, the middle of the book.


### The Middle Bit is the Hardest

I found the hardest time was about halfway through the book.  The initial excitement of the new endeavor had long since worn off.  It seemed like such a mountain of a task, with no end in sight.  I questioned my decision to continue with it daily.  My routine and deadlines kept me moving forward.  But my circle of friends and family kept me sane.  It was great to have an outlet, not only to vent my frustration with my slow progress, but to get kind encouragement to keep my spirits up.

During these dark days, I also ate cheese.

### Celebrate Your Small Victories

At the end of every chapter or deadline I would fix myself a nice plate of cheese and crackers.  You have to celebrate the small wins.  Cheese is also very tasty.

When the book was finally done.  I had a really tasty plate, complete with Stilton, Brie, and a dependable Cheddar.  I was incredibly happy to be finished. But I knew that I definitely could have not done it without the help of others.

### Thank Everyone that Supported You

Writing a book is a huge undertaking that is utterly impossible to do alone.  I could have not done it without the help and support of my editor, reviewers, family, friends, as well as the entire Clojure Community.  I am so thankful to all of you that helped my in this project.  You are great.

So, should you go ahead and write that book?

### Do It

Yes, you should write that book and share your knowledge.  Don't panic, remember to breathe, get some cheese and tea, and go for it!  It will be awesome.

