---
author: gigasquid
comments: false
date: 2011-05-01 14:02:39+00:00
layout: post
slug: hacking-javascript-for-the-love-of-clojure
title: Hacking JavaScript for the Love of Clojure
wordpress_id: 190
categories:
- All
- Clojure
- JavaScript
tags:
- Clojure
- JavaScript
---

Lately, I have been working on the awesome open source project [4Clojure.com](http://www.4clojure.com/). The site helps you to learn Clojure by solving “koan” type problems in an interactive format. One of the enhancements that I was looking at putting in was a way to enter code in a text box and have it color highlight as type. I found the [ACE project](http://ace.ajax.org/), which looked like exactly what I wanted. However, sad panda, they didn't have a Clojure mode. Not deterred, I decided that I would try to take a crack at it. I ported most of the rules from the Clojure brush in Syntax Highlighter over and implemented some basic auto-indent.

The Github source has been added to the main project at Ace [https://github.com/ajaxorg/ace](https://github.com/ajaxorg/ace)
You can see it in action on the 4Clojure.com site here: [http://www.4clojure.com/problem/14](http://www.4clojure.com/problem/14)

