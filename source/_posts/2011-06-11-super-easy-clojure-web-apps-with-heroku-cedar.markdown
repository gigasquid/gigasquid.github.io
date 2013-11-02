---
author: gigasquid
comments: false
date: 2011-06-11 23:57:52+00:00
layout: post
slug: super-easy-clojure-web-apps-with-heroku-cedar
title: Super Easy Clojure Web Apps with Heroku Cedar
wordpress_id: 218
categories:
- All
- Clojure
- Development
---

Deploying Clojure apps with a single command to the cloud is now possible with Heroku Cedar and let me tell you, it is pure joy.

I experimented with this the other day by creating a Compojure web application that compares the followers that two twitter users have in common.

Here is the secret sauce you need to push your apps to Heroku:

1) **Procfile: **
You need to create a file in the root of your directory that contains the way to start up your application:

    
     web: lein run -m ring-twitter-common.core


2) The application must have the project.clj setup correctly so that you can just run:

    
    lein deps


3) You need to install the [Heroku gem](https://github.com/heroku/heroku)

Once you have this setup you simply do:

    
    heroku create --stack cedar



    
    git push heroku master


That's it. Your webapp will auto-magically be created, and deployed and be available for your viewing pleasure.

You can check out  my sample Twitter Heroku app here:
[http://ring-twitter-common.herokuapp.com/](http://ring-twitter-common.herokuapp.com/)

But wait, you say... wouldn't it be awesome if you could just write your Clojure app and say lein deploy and have it all work? Wouldn't it be super awesome if there was some command to generate a skeleton for your Compojure app? The solution is actually in the planning stages by James Reeves (weavejester)!  Hooray!











[Leiningen Google Group Text](http://groups.google.com/group/leiningen/browse_thread/thread/1f3fbb808542adc6)

In summary:  Developing Clojure Web Apps just got easier and the future is only looking up :)


