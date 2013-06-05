---
author: gigasquid
comments: false
date: 2010-05-27 02:09:14+00:00
layout: post
slug: feature-vs-bug-does-it-matter
title: Feature vs Bug - Does it Matter?
wordpress_id: 3
categories:
- All
- Development
---

How many minutes and hours have been wasted trying to decide if a ticket is a feature or a bug?  Yes, I have been there, entering a new item ticket, the dropdown in the tracker glares at me.  Decide!  Is is a bug or a feature.  Some are clear-cut, of course.  The ever popular null-pointer on unvalidated input for example.  But others are not so clear.   What about the field that you thought was supposed to viewable employees in the supervisor's location, but really ended up needing to be viewable to the employee's in the supervisor's location and the direct reports in another location?   The question then turns on whether or not this information was in the "spec" or whether the business user didn't let the developer know about it.  Now the question has created an ugly situation of "blame".  Whose fault is it?

While I am all for development responsibility and testing, I think this line of thinking can only lead to trouble and harm the close relationship sought by the business user and the developer.  How can you truly have agile, collaborative development, if the two parties are at odds, even in the small sense of categorizing work tickets.  In the end, the same work needs to be done to get to the end result of having the application serve the business needs.  So let's lay off the blame game and just say no to bug vs feature.
