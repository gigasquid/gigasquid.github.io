---
author: gigasquid
comments: true
date: 2012-11-25 14:08:53+00:00
layout: post
slug: 7-mccarthy-papers-in-7ish-weeks-5
title: '7 McCarthy Papers in 7ish Weeks #5 & #6 - SDFW Tic-Tac-Toe'
wordpress_id: 557
categories:
- All
- Clojure
- John McCarthy Papers
---

{% img http://farm8.staticflickr.com/7388/9925780935_9744792c36_o.png %}

This holiday edition blog post covers two McCarthy papers instead of just one.  We will be talking about [Free Will - Even for Robots](http://web.archive.org/web/20131014084908/http://www-formal.stanford.edu/jmc/freewill.pdf) and the companion paper [Simple Deterministic Free Will](http://web.archive.org/web/20131014084908/http://www-formal.stanford.edu/jmc/freewill2.pdf).


## In which we deftly sidestep the philosophers


We know that computers and programs are completely deterministic.  A philosophical question is whether we, as humans are ruled by determinism, (although complex it may be), or not.  If we take the decision that humans are deterministic, then we can argue that either there is no free will - or that free will is "compatible" with determinism.  Philosophers, of course, could discuss such questions interminably, trying to get a theory to fit for all people and all occasions.  Thankfully, McCarthy takes a very admirable and practical view on free will.  Let's try out something simple for a computer program and see how it works.  He explores a philosophy "Compatibilist's" view, which regards a person to have free will if his actions are decided by an internal process, even if this process itself is deterministic.  But by exploring this view with computer programs, he makes clear:


> ... I don't need to take a position on determinism itself.






## Simple Deterministic Free Will


So what would Free Will look like for a machine. How do we go about defining it? McCarthy proposes the idea of Simple Deterministic Free Will. The main idea is that the mechanism of free will is broken up into two parts. The first part looks at the possible actions and the consequences of those actions, and the second part decides which of those actions are preferable and does them. He gives the example of a chess program:


> People and chess programs carry thinking about choice beyond the ﬁrst level. Thus “If I make this move, my opponent (or nature regarded as an opponent) will have the following choices, each of which will give me further choices.” Examining such trees of possibilities is an aspect of free will in the world, but the simplest form of free will in a deterministic world does not involve branching more than once.


So perhaps we could find an example that is simpler than chess to work with ...


> ...it would be interesting to design the simplest possible system exhibiting deterministic free will. A program for tic-tac-toe is simpler than a chess program, but the usual program does consider choices.




## Simple Deterministic Free Will Tic Tac Toe


So to explore McCarthy's idea of Simple Deterministic Free Will, I decided to try to construct a game of Tic Tac Toe with SDFW principles. Coincidentally, my six year old daughter, just learned how to play Tic Tac Toe as well. I wanted to construct a program that would "reason" about the game as would a child. Even though the game of Tic Tac Toe is simple enough to have all the possibility trees of moves completely solved, this is not how a my daughter approaches the game. Each time it is her move, she only looks one move ahead to see if she can win three in a row, or if she needs to block her opponent from winning the next move.


## My Tic Tac Toe Program has Beliefs


It has three beliefs to be precise. It believes that no one is going to win, or it is going to win, or its opponent is going to win.

    
    (def beliefs
      { :win "I am going to win."
        :lose "My opponent is going to win."
        :noone "No one is going to win."})


McCarthy thinks that [ascribing programs beliefs can be useful](http://gigasquidsoftware.com/blog/2012/09/20/7-john-mccarthy-papers-in-7-weeks-1/). One of the reasons is that it helps us as humans, reason and debug our programs. I definitely saw the value of this when I was trying to debug my tic tac toe game. After it failed to block my winning move, I could see what its false belief was - ah - it thought that "No one is going to win". I wrote another failing unit test to fix its bad belief.


## My Tic Tac Toe Program Looks to See What Its Possible Actions and Preferences Are


It looks at the board and computes all its possible next moves. Then it computes all the possible next moves of its opponent. It looks at the consequences of these moves by assigning a belief from one of its three beliefs. Next, it ranks the moves according to the preference of its beliefs.

    
    (def belief-action-preferences
      { (beliefs :win) 1
        (beliefs :lose) 2
        (beliefs :noone) 3})


It then chooses the move to take that has the highest rank. If it believes that no-one is going to win, I opted to have it choose a random move from the list of possible choices. But this randomness is completely arbitrary on my part and not necessary to SDFW at all.


## Why ClojureScript is Awesome


I coded the core tic-tac-toe program in Clojure, but then I thought that having a web page UI would be nice for my daughter to play with. So, I just took the game logic and moved it to ClojureScript. Let me say that again slower... I used the same code on the server on the browser. Awesome. Using the [lein-cljsbuild crossover support](https://github.com/emezeske/lein-cljsbuild/blob/0.2.10/doc/CROSSOVERS.md), I was able to simply configure my UI ClojureScript code to access my regular clojure game engine. Very cool. I was also very pleased to work with the [https://github.com/levand/domina](https://github.com/levand/domina) DOM manipulation library for ClojureScript.


## End Result


It was a fun project that let me play with ClojureScript, explore McCarthy's free will for robots, have some very interesting conversations about free will with my co-wokers and code and coffee friends, and make a game for my daughter to play and enjoy. If you are interested in checking out the program for yourself - [http://gigasquid.github.com/sdfw-tic-tac-toe/](http://gigasquid.github.com/sdfw-tic-tac-toe/). The last belief is displayed at the bottom. I have only tried it on Chrome, so beware. Finally, if you find any false beliefs, feel free to submit a pull request to [https://github.com/gigasquid/sdfw-tic-tac-toe](https://github.com/gigasquid/sdfw-tic-tac-toe).

P.S. If you are wondering, I drew the awesome graphics all by myself.
