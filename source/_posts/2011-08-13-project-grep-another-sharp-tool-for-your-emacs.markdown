---
author: gigasquid
comments: false
date: 2011-08-13 18:31:20+00:00
layout: post
slug: project-grep-another-sharp-tool-for-your-emacs
title: 'Project-Grep : Another Sharp Tool for your Emacs'
wordpress_id: 248
categories:
- All
- Development
---

Since joining EdgeCase, I have shelved my heavy Intellij and Eclipse IDEs in favor of Emacs. Overall, I have enjoyed moving to the light-weight but powerful editor. There is one thing that I did miss from my IDEs – that was the ability to search projects for string occurrences and being able to click navigate to them through the editor. Fortunately, one of the strengths of Emacs is it's infinite configurability and extensibility. Even more fortunate, one of the guys in our shared office, [Doug Alcorn](http://twitter.com/#!/dougalcorn) of Gaslight Software, had already written just this feature for his Emacs. I installed it and was so pleased with it, that I thought I would share …

[https://github.com/dougalcorn/emacs.d/blob/master/site-lisp/misc/project-grep.el](https://github.com/dougalcorn/emacs.d/blob/master/site-lisp/misc/project-grep.el)

**To install:**
Download [project-local-variables.el](https://github.com/dougalcorn/emacs.d/blob/master/site-lisp/misc/project-local-variables.el) and [project-grep.el](https://github.com/dougalcorn/emacs.d/blob/master/site-lisp/misc/project-grep.el)
In your init.el file: (require 'project-grep)
Create an empty .emacs-project file in your directory

**To use:** meta-x project-grep

[caption id="attachment_251" align="alignleft" width="300" caption="Project-grep"][![Project-grep](http://gigasquidsoftware.com/wordpress/wp-content/uploads/2011/08/Screen-Shot-2011-08-13-at-2.03.31-PM1-300x168.png)](http://gigasquidsoftware.com/wordpress/wp-content/uploads/2011/08/Screen-Shot-2011-08-13-at-2.03.31-PM1.png)[/caption]
