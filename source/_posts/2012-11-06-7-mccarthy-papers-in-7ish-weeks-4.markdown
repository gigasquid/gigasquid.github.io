---
author: gigasquid
comments: true
date: 2012-11-06 13:32:04+00:00
layout: post
slug: 7-mccarthy-papers-in-7ish-weeks-4
title: '7 McCarthy Papers in 7ish Weeks - #4'
wordpress_id: 543
categories:
- All
- John McCarthy Papers
---

Reading [Artificial Intelligence, Logic, and Formalizing Common Sense](http://www-formal.stanford.edu/jmc/ailogic/ailogic.html), led me surprisingly to reflect on, not only logic and philosophy, but also the history and present state of AI.

Fist let's look at the kind of AI that McCarthy is describing in paper. He talks of a program that can use common sense knowledge about the world around it and have this knowledge structured well enough that it can be reasoned about mathematically. In fact, he describes four levels of logic:





  1. The computer program has its "beliefs" completely defined by its internal state.  If you are confused by the term "beliefs", it refers to [ascribing mental qualities to machines](http://gigasquidsoftware.com/blog/2012/09/20/7-john-mccarthy-papers-in-7-weeks-1/).  In his famous example, a thermostat has three beliefs: the room is too hot, the room is too cold, and the room is just right. 


  2. The programs express their beliefs in sentences in machine memory.  However, they do not use ordinary logic.  They use other methods like rules and procedures.


  3. In addition to expresses their beliefs in sentences, they also use first order logic and logical deduction to reach their conclusions.


  4. The fourth level is still a goal today.  It is to have the program represent general facts about the world as logical sentences.  Furthermore, to have a database of these commonsense facts that programs can share.


Let's step back now for a moment, to a excerpt from the very beginning of the paper:



> 
One path to human-level AI uses mathematical logic to formalize common-sense knowledge in such a way that common-sense problems can be solved by logical reasoning. This methodology requires understanding the common-sense world well enough to formalize facts about it and ways of achieving goals in it. Basing AI on understanding the common-sense world is different from basing it on understanding human psychology or neurophysiology.



This approach to AI is just one approach. It is commonly referred to as a "top down" approach.  In the early years of AI it was the dominant way of thinking about things. Looking back at the history of AI, the [golden years](http://en.wikipedia.org/wiki/History_of_artificial_intelligence#The_golden_years_1956.E2.88.921974) were full of optimism, (and funding), that this was the path to achieving fully intelligent machines.  Disenchantment with unfulfilled promises, led to the first [AI winter](http://en.wikipedia.org/wiki/AI_winter).  There was a rise of expert systems later on that limited their scope to small domains and avoided the common sense problem, but eventually ended in a second AI winter and ushered in our current world.  This basic approach is an opposite ground-up view of AI.  It uses neural networks and statistics from a physical inspiration.  Some of this inspiration is from human neurophysiology, some of it is from insect and animal world, but simplicity behavior of a "body" is emphasized.  With the advances in hardware and computing power today, the innovations and accomplishments have been breath taking.

A good example of the two approaches can be seen in my Roomba.  A top down approach, would require my Roomba to have a complete room model in its program.  It would have to understand what my couch was, where the doors where and have logically reasoning to direct it to which areas to clean and when to stop cleaning and recharge itself.  The creators of the Roomba were from the opposite camp of thinking.  They took the simpler behavior approach of having the Roomba just take a random walk in the room and turn around when it ran into an obstacle.  It took a bit longer to get the room clean in such a random fashion, but not having to deal with the overhead of a mental model was well worth the trade off.

Noam Chomsky recently argued that the[ pendulum has swung too far in favor of this simplified behaviorist approach](http://www.theatlantic.com/technology/archive/2012/11/noam-chomsky-on-where-artificial-intelligence-went-wrong/261637/). Even in the light of [Norvig's response](http://norvig.com/chomsky.html), I think Chomsky has a point.  We would do well to search for gems of true intelligent systems in the historical landscape of the AI Winter.  Some of the breakthroughs of current sheer computing power and new modeling techniques, might yield great fruits.

One of the comments by nagelonce, on the Chomsky article,  puts this very well:




> AI has a hole in the middle. There's top-down AI, which focuses on abstractions and reductionism. There's bottom-up AI, which focuses on reactive systems and the front end of visual processing. They have yet to meet in the middle. They are, however, much closer to doing so than they were twenty years ago.




If you are interested in checking out a top-down open source AI project, take a look at [OpenCyc](http://www.opencyc.org/doc).  After a brief look at it the other night, it suffers from the lack of love and documentation.  But, I can also see the promise of McCarthy's common sense knowledge and logic system, covered in a thin layer of snow.







