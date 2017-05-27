---
layout: post
title: "Self Publishing for the Creative Coder"
date: 2017-05-27 14:11
comments: true
categories:
- all
- self-publising
---

So, you have an idea for a fiction book. First, let me tell you that it's a good idea and it's a great thing that you are a coder. Quite a few successful authors have a background in software development. [Arrival](http://www.imdb.com/title/tt2543164/), (which is a fabulous movie), comes from the book, [Stories of your Life](https://www.amazon.com/Stories-Your-Life-Others-Chiang/dp/1101972122),  written by a fellow programmer [Ted Chiang](https://en.wikipedia.org/wiki/Ted_Chiang). [Charlie Stross](https://en.wikipedia.org/wiki/Charles_Stross) is another fine example. One of my favorites is [Daniel Suarez](https://en.wikipedia.org/wiki/Daniel_Suarez_(author), the author of the[ Daemon](https://www.amazon.com/DAEMON-Daniel-Suarez/dp/0451228731) and more recently [Change Agent](https://www.amazon.com/Change-Agent-Novel-Daniel-Suarez/dp/110198466X/). So yes, you can write a fiction book and you're in good company. This post is dedicated to help make it happen.

## So how do you know about self publishing?

Two years ago, I had a semi-crazy idea for a tween/teen scifi book. At the time, my daughter was into all the popular books of time like _Hunger Games_ and _Divergent_. The thing that I really liked about them was the strong female protagonist. The only thing that I thought was missing was a story that focused on a girl who could code. It would make it even better if she _coding super powers_. The idea for [Code Shifter](http://www.codeshifterbook.com/) was born. One of the things that I wanted to explore in writing the book was to have real programming code in the book but not have it be a _learning how to code_ book. The code would exist as part of the story and if the reader picked up concepts along the way, great. Even if they didn't, it would lay the positive groundwork to have them be more open to it later.

Books, like software, always take longer than you plan. My daughter and I enjoyed working on it together and over time it grew into a book that we could share with others. Along the way, I learned quite a bit about writing books, publishing, and other things that I wish I had known beforehand.

## What did you use to write the book?

In the book world, your story is referred to as your _manuscript_. As a tool to produce it, I cannot speak highly enough of [Leanpub](https://leanpub.com/). I found it easy and productive to work in as a programmer. For example,  my setup was pretty painless.

In the repo, I had a `manuscript` directory, in which there was a `Book.txt` file that listed the chapter files.

```
chapter2.txt
chapter3.txt
chapter4.txt
chapter5.txt
```

Each chapter file in turn was written in markdown. For example, `chapter2.txt` looked like this:

```
# 1

## Flicker


Twelve-year-old Eliza knew that the next words were the result of computer program far more intelligent than any one of them. Standing next to her parents, she held her breath and watched as her brother touched his finger to the message on the wall screen.
```

From there, my process looked like:

* Write a bit in my favorite editor, (Emacs of course), and make a commit.
* Push the commit to github, which is registered with the Leanpub project
* Log onto the Leanpub project and hit the _preview_ button. This would generate a pdf and ebook that I could share with my daughter for feedback.

{% img http://c1.staticflickr.com/5/4274/34768029762_3bbae300f0.jpg %}


### Advantages of Leanpub for development.

As I said earlier, I'm a fan. Using git for revisions is incredibly useful. I shudder to think of people writing in Word without version control. The ability to easily create PDF and ebook formats was also very convenient. The markdown format has excellent code support. There is also the option as publishing your work as you go. However, I think that this is more useful with a technical book than with fiction.

### Disadvantages of Leanpub for development

If you are going to work with an freelance editor or share your work with someone in the mainstream book world, they are not going to want pdf. They usually want a doc version. It took me a bit of research to find a good converter, [pandoc](http://pandoc.org/). With it, you can convert from markdown to Word with things looking pretty good. Don't try to do pdf to Word. I found it a big recipe for fail.


Finally, the book was considered done enough to think about publishing.

There was much rejoicing.

## Didn't you want to get the book into bookstores?

Of course. That would be incredibly cool. However, that requires getting into what they call _traditional publishing_ and it is a lot more work, time, and luck. If you go this route, you will need to budget at least six months to send out form letters to agencies to have them represent your work. Also, beware of predatory services that take advantage of unsuspecting and wide eyed authors. If you are interested in this, you'll want to start looking for agents that are interested in your type of book. [Query Tracker](https://querytracker.net/) is a great place to start.

## Traditional publishing sounds hard. What about self publishing?

Self publishing is certainly an easier more direct way to bring your book to life. For me, it was the best way forward. Luckily, Leanpub made it pretty painless.


### Publishing the book with Leanpub

Actually publishing the finished copy was really easy with Leanpub. All I had to do was fill in some fields on the project page and push _Publish!_ The book was immediately ready to share with the world. Putting out an updated edition was as easy as pushing the button again. Leanpub provides online reading as well as all the ebook versions.

That was nice, but I really wanted a print copy too.

### Publishing with CreateSpace

Amazon's [CreateSpace](https://www.createspace.com/) provides and excellent platform for on-demand print copies of books. This is where Leanpub comes in handy again. There is an `Export Option` that provides and unbranded pdf copy of your manuscript with all the correct formatting and margins required for CreateSpace. I simply exported the file and then uploaded it up to the project.

{% img http://c1.staticflickr.com/5/4203/34121511063_b63d283086_b.jpg %}

The other thing that you will want is a nice cover. There are services through CreateSpace for cover creation that you can buy or you can upload your own file. I was lucky enough to have a talented graphic designer as sister, Kristin Allmyer,  who made me an awesome cover.

One of the confusing things was picking an ISBN for the print copy. You don't need to worry about this for ebook versions but you do for a physical copy. Your choices through CreateSpace are using a provided one for free or buying your own for $99. I chose my own so I could have flexibility of working with another publisher other than Amazon if I want. If you choose that option, you can also make up your own publisher name. Mine is _Gigasquid Books_.

{% img http://c1.staticflickr.com/5/4244/34121511083_15027c4571.jpg %}

Once you have completed all the setup, they will send you a physical copy in the mail to approve. The moment you get to hold it in your hands is really magical.

{% img https://pbs.twimg.com/media/C8xBM-nXYAAOmK0.jpg:large %}

If it looks alright, you hit the approve button and voilà - it's for sale on Amazon!

### Publishing with Direct Kindle Publishing

With CreateSpace, you have the option of porting your book to a Kindle format as well. It will do most of the heavy lifting of converting the files for you and a few button clicks later you have both an Kindle and print version available for your readers.

If you need to update the text of the Kindle version, Leanpub also has an export option available to produce unbranded ebook files. Just take this and upload it to your KDP account and you are good to go.

## Did you run into any problems?

Of course I did. I was totally new to self publishing and I underestimated how hard copy editing is. Some errors unfortunately made it into the first version. Luckily, I had some really nice people that helped my fix it for later versions. Many thanks to Martin Plumb, Michael Daines, Paul Henrich, and S. Le Callonnec for editing help.

This brings me to my next point. If I had to do it all over again, I would publish the book in a different order. Books are really no different than software. There are going to be bugs when you first release it in the wild. It is best to embrace this. In the future, I would publish the ebook versions first, which are much easier to update and then the print versions after that.

## Did you make lots of money from the book sales?

Hahaha ...  that's funny. If you are interested in making money, books are not the best way to go. The margins on Leanpub are definitely better than Amazon, but if I really was interested in making money, I would have been much better off using deep learning to make a stock market predictor or code up a startup that I could sell off.

Authors in general, are much harder pressed to make livings than software developers. We should count our blessings.

## Any last words of advice?

There is an great joy from creating a story and sharing it with others. Take your book idea, nurture it, and bring it to life. Then publish it and we can celebrate together.



