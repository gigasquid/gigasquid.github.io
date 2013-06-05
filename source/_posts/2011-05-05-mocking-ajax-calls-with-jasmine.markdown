---
author: gigasquid
comments: false
date: 2011-05-05 16:42:13+00:00
layout: post
slug: mocking-ajax-calls-with-jasmine
title: Mocking Ajax Calls with Jasmine
wordpress_id: 201
categories:
- All
- JavaScript
---

I have been happily using [Jasmine](https://github.com/pivotal/jasmine/) and [Jasmine-JQuery](https://github.com/velesin/jasmine-jquery) on a project with great success. However, I was still unsure about how to handle mocking the ajax calls back to the server. It turns out the answer is already in Jasmine. Time to call out the spies!

There is a wiki page on spies [https://github.com/pivotal/jasmine/wiki/Spies](https://github.com/pivotal/jasmine/wiki/Spies), but I always enjoy a nice code sample.

In my source file I have an ajax call that I would like to mock that looks like this:
[gist id=957387]

Now in my spec file - I setup a spy on the ajax call and use andCallFake to mock the call. When the method is tested, the ajax call will be mocked and return through the success handler. You can pass data back through the fakeData var.
[gist id=957389]
