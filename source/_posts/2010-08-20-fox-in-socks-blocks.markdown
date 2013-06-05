---
author: gigasquid
comments: false
date: 2010-08-20 02:43:34+00:00
layout: post
slug: fox-in-socks-blocks
title: Fox In Socks Blocks
wordpress_id: 60
categories:
- All
- Ruby
---

In honor of the Ruby [Why Day](http://www.globalnerdy.com/2010/08/19/whyday-today-august-19th/), I was inspired to dabble in Ruby Blocks after being reading "Fox In Socks" multiple times to my children before bed.  For all of you parents out there that have read the book many, many times while your children are giggling at your pronunciation difficulties, I am sure this bit will be familiar:

    
    def fox_in_socks_blocks
      chicks_bricks = ["Chicks","bricks","blocks","clocks"]
      yield chicks_bricks[0..1]
      yield [chicks_bricks[0],chicks_bricks[2]]
      yield chicks_bricks
    end
    
    fox_in_socks_blocks do |sillywords|
      puts "#{sillywords[0]} with #{sillywords[1]} come." if sillywords.size < 3
      puts "#{sillywords[0]} with #{sillywords[1]} and #{sillywords[2]} and #{sillywords[3]} come." if sillywords.size >= 3
    end
    


That's right - the output is:
`
Chicks with bricks come.
Chicks with blocks come.
Chicks with bricks and blocks and clocks come.
`

Is your tongue numb?

Happy Why Day!
