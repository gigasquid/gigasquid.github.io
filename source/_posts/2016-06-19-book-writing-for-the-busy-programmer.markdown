---
layout: post
title: "Book Writing for the Busy Programmer"
date: 2016-06-19 09:22
comments: true
categories:
- All
---

{%img http://c5.staticflickr.com/8/7302/27492453220_eecdf6dee1.jpg %}

So you want to write a book?  Awesome.  I've been working on one too for the last year.

No, it's not really a programming book, but does have code in it.  It's a sci-fi/fantasy book written for my ten year daughter, but this post isn't about that.  It's about the tools and setup that I've found work best for me.

## Tools for Writing

If the first thing you think of when you want to write a book is creating some really cool tools to help you, I can totally relate.  It's a programmer thing.

Hold on though, there's another way.

Starting out with only my book idea, I spent some time looking at the best authoring tools out there.  I knew that I wanted to able to write in an editor that I was comfortable in and in a terse format like Markdown.  I also wanted to be able to use git for revision management.  After searching, I settled on [Leanpub](https://leanpub.com/)


Leanpub is a free service for authoring that has [Git integration](https://leanpub.com/help/getting_started_sync_github) in [Markdown format](https://leanpub.com/help).  With it, I was able to write in my favorite text editor, (Emacs of course), commit and push my changes to my git repo, and then generate PDF and e-book formats.  The multiple formats were important to me because it allowed me to share my chapters and get feedback.

## Tools for Feedback

Since I was writing a book with my daughter in mind, the most important feedback was from her.  After every chapter was done.  I would either print her out a copy or download it to her kindle for review.  She actually really enjoyed reading it on her Kindle because it made it for more _real_ to her.  My son also got interested in the story and before long, I had them both getting in heated debates about which direction the story should go.

After my kids reviewed the chapters, I also sought some professional writing advice from a free-lance editor.  I highly recommend getting this sort of feedback from either an editor, writing group, or trusted friend to help you grow and improve. The one catch is that most of the writing world works with Microsoft Word, so I needed to convert my chapters to that format.

From my experience, all PDF to Word converters are full of fail.  The formatting goes all over the place and your writing ends up looking like some horrible abstract text art experiment gone wrong.  So far, the best converter I've found is [pandoc](http://pandoc.org/).  It allows you to take your Markdown files and turn them into quite presentable Word documents.

If you have a Mac, it's as simple as `brew install pandoc`.  Then, you can create a simple script to convert all your chapters,(or a selection) into a properly formatted Word Doc.

```
#!/bin/bash
rm ./all.md
for i in `cat ./Book.txt`; do  cat $i >> all.md; echo "  " >> all.md ; done
pandoc -o all.docx -f markdown -t docx ./all.md
```

Once you write your manuscript, (what the publishing world calls your book text), revise it, copy edit it, and walk backwards in a circle three times, you're ready to publish.

## Tools for Publishing

I don't have any real firm advice in this area yet since I'm still at the copy editing and walking backwards stage, but I'll share the two options that I'm looking at - traditional publishing and self publishing.

Self publishing is more easily understood to the two.  You can put your book up for sale at any time through Leanpub or Amazon.  For better or worse, you have complete control of the content, display, marketing, and revenue of your book.

Traditional publishing involves finding an literary agent and/or publisher to work with.  This route involves pitching your manuscript to someone to represent it through a [query](http://nybookeditors.com/2015/12/how-to-write-a-darn-good-query-letter/).  The advantages of this are that, (if you find a good match), you will have a team of people helping you make your book the best it can be and have the possibility of getting it on the shelf in a bookstore.  The downsides are that the traditional publishing world takes a lot longer than pushing the self publish button.


With any luck, I'll have a clearer picture of this all in a bit and be able to share my experiences.  In the meantime, I encourage you to grab your keyboard and bring your book ideas to life.

No matter the outcome, it's a rewarding journey.






