---
layout: post
title: " Kolmogorov-Uspensky Machine"
date: 2016-03-16 18:19
comments: true
categories:
- Clojure
- All
---


It happened again.  I was sitting down reading a paper and I came across the phrase _Kolmogorov-Uspensky machine_ and I had no idea what it was.  My initial reaction was just to move on.  It probably wasn't important, I told myself, just a detail that I could skim over.  I took a sip of my tea and continued on. The next paragraph it appeared _again_.  It was just sticking up like a thread waiting to be pulled. Still, I resisted.  After all, I wasn't even near my computer.  I would have to get up an walk into the other room.   After considering it for a moment, inertia won out and I continued my reading.  There it was _once more_.  This time right in the same paragraph, silently mocking me.  I knew then I had to do something so I strode to my computer and pulled the thread.

## What is a Kolmogorov-Uspensky machine?

The first thing I found is that the Kolmogorov-Uspensky machine, (also referred to as KUM), is very similar to the [Turing machine](https://en.wikipedia.org/wiki/Turing_machine).  In fact, it shares the same computational class of being Turing-complete.

{% img https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Turing_machine_2b.svg/320px-Turing_machine_2b.svg.png %}

The Turing machine operates on a tape divided into cells.  The head can move along the tape and read and write to it.  The tape is the storage for the machine.  Its movements are controlled by a collection of instructions which will be executed if certain prerequisites are met. The difference between the Turing machine  and a Kolmogorov-Uspensky machine is that the KUM has a tape that can change topology.  It's a graph.

The graph of a KUM machine is not just any graph.  It's a particular kind of graph.  It must have the property that if you start at a one vertex, all the other vertexes are uniquely addressable.  The graph also has a active node which, in turn, has a active neighborhood of other nodes associated with it.  This is not unlike the Turing machine's head that points to the current cell.  To figure out what do, the KUM machine looks at the graph to decide on what instruction to execute.  The instructions can consist of adding a node or edge to the active neighborhood, removing a node or edge from the active neighborhood, or halting.

After spending some time reading and researching, I felt like a had some idea of what a Kolmogorov-Uspensky machine was but it was still a bit fuzzy.  I wanted to really dig in and experience it by trying to implement one.  I found an esoteric programming language called [Eodermdrome](https://esolangs.org/wiki/Eodermdrome) that fit the bill and set to work building it out in Clojure.

## Eodermdrome

An Eodermdrome program creates graphs from a string of letters.  For example the graph of _abcdae_ would produce

{% img https://github.com/gigasquid/eodermdrome/blob/master/images/abcdae.png?raw=true %}

The program itself consists of series of commands or rules.  The command will be executed if the following prereqs are met:

* The match graph in the command is a subgraph of the system graph.
* If an input set is part of the command, the input character read of the system input must match it.

A command is of the form:

* **match-graph graph-replacement**
	* This will execute if the match-graph is a subgraph and then transform the match to the replacement.
	* Example:`a abc`
* **(input-set) match-graph graph-replacement**.
    * This will execute if the match is a subgraph and if the next character of the system input matches.  On executing, it will read one char from the input and then transform the match graph with the replacement.
    * Example: `(1) a abc`
* **match-graph (output) graph-replacement.**
	* This will execute if the match-graph is a subgraph. On executing, it will print the output to the system and transform the match with the replacement.
	* Example: `a (1) abc`
* **(input-set) match-graph (output) graph-replacement.**
	* This will execute if the match is a subgraph and if the next character of the system input matches.  On executing, it will read one char from the input, print the output to the system, and then transform the match graph with the replacement.
	* Example: `(0) a (1) abc`

Comments are also allowed as text in between commas.  In this implementation, they must be contained on a single line.  Example: `,this is a comment,(1) a abc`

The initial state of the graph with a program is the denoted by the graph string _thequickbrownfoxjumpsoverthelazydog_.

{% img https://github.com/gigasquid/eodermdrome/blob/master/images/thequickbrownfoxjumpsoverthelazydog.png?raw=true  %}


We now have all we need to walk through an example program in the Kolmogorov-Uspensky machine.

### An add program

Let's take program for adding two string of ones together separated by zeros.

```
,takes input of ones separated by zeros and adds the ones, thequickbrownfoxjumpsoverthelazydog a
(1) a ab
(0) a a
ab (1) a
```

Given a system input of "101", it will print out "11".  Let's walk through what happens in the program.

**Step 1** - The program starts with our graph in the initial state of our beloved _thequickbrownfoxjumpsoverthelazydog_ configuration.

{% img https://github.com/gigasquid/eodermdrome/blob/master/images/step-1.png?raw=true  %}

**Step 2** - The first instruction matches `,takes input of ones separated by zeros and adds the ones, thequickbrownfoxjumpsoverthelazydog a` with he active subgraph being the whole graph. It is replaced by the single graph node _a_.

{% img https://github.com/gigasquid/eodermdrome/blob/master/images/step-2.png?raw=true %}

**Step 3** - The next instruction set `(1) a ab` _a_ subgraph matches and takes a 1 off the input and transforms the graph to _ab_.

{% img https://github.com/gigasquid/eodermdrome/blob/master/images/step-3.png?raw=true %}

**Step 4** - The instruction set `(0) a a` also matches (since a is a subgraph of ab) and it takes a zero off the input and transforms back the _a_ to _a_ so the graph is still _ab_.

{% img https://github.com/gigasquid/eodermdrome/blob/master/images/step-4.png?raw=true %}

**Step 5** -  The instruction set `ab (1) a` now matches and a one prints out and the _ab_ graph changes to _a_.

{% img https://github.com/gigasquid/eodermdrome/blob/master/images/step-5.png?raw=true %}

**Step 6** - Now, the `(1) a ab` instruction matches, it takes another 1 off the input (our last one) and transforms to _ab_

{% img https://github.com/gigasquid/eodermdrome/blob/master/images/step-3.png?raw=true %}

**Step 7** - Finally, `ab (1) a` matches and it prints out a 1 and rewrites the graph to back to _a_

{% img https://github.com/gigasquid/eodermdrome/blob/master/images/step-5.png?raw=true %}

There are no more matching subgraphs without input required for instructions, so the program ends.


## Parting thoughts and threads

The Kolmogorov-Uspensky machine is quite interesting. Not only is the idea of graph storage and rewriting appealing, it is also pretty powerful compared to Turing machines.  In fact, Dima Grigoriev proved that Turing machines cannot simulate Kolmogorov machines in real time.

It's been quite a fun and enriching jaunt.  The next time you see an unfamiliar term or concept, I encourage you to pull the thread. You never know where it will take you. It's a great way to enlarge your world.

If you are interested in the code and hacking for yourself, here is the repo  [https://github.com/gigasquid/eodermdrome](https://github.com/gigasquid/eodermdrome).

Other good resources on KUM:

* [On Kolmogorov Machines And Related Issues](http://research.microsoft.com/en-us/um/people/gurevich/opera/78.pdf)
* [Kolmogorov's Heritage in Mathematics](https://books.google.com/books?id=SpTv44Ia-J0C&pg=PA284&lpg=PA284&dq=active+node+kolmogorov+uspensky+machine&source=bl&ots=uQQSLaaKOS&sig=9-V_m8z-Yh9zlzy6vX9MplGMbjw&hl=en&sa=X&ved=0ahUKEwjy8820rMDLAhVByYMKHWP5A8oQ6AEILDAC#v=onepage&q=active%20node%20kolmogorov%20uspensky%20machine&f=false)
* [What is a "pointer machine"](http://dl.acm.org/citation.cfm?id=202846)
