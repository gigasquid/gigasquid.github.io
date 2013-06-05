---
author: gigasquid
comments: true
date: 2012-10-15 01:37:30+00:00
layout: post
slug: 7-john-mccarthy-papers-in-7-weeks-3
title: '7 John McCarthy Papers in 7 Weeks #3'
wordpress_id: 515
categories:
- All
- John McCarthy Papers
---

**In which I realize that John McCarthy is the father of the Semantic Web**

I have realized that it generally takes me more than a week to read a paper, reflect on it, experiment, and finally blog about it. But, since I made up the rules of the project in the first place,  I am not going to dwell on the time frame and just move forward with the next paper.

When I picked the paper [First Order Theories of Individual Concepts and Propositions](http://www-formal.stanford.edu/jmc/concepts/concepts.html), I thought to myself that it would be a rather narrow, more self contained paper than the first two broad papers that I read. However, the connections that it drew to current technologies caught me by surprise.

The main point of the paper is how to formalize language statements, including concepts, so that a computer can apply mathematical rules and logic to them. McCarthy had mentioned concepts and thoughts in his "Ascribing Mental Qualities" paper, where he says:


> "..the deep structure" of a publicly expressible thought is a node is the public network."


This immediately brought to my mind the Semantic Web.   In Semantic Web, data is structured in [RDF](http://www.w3.org/TR/rdf-primer/#statements) statements as triples - <subject> <predicate> <object>.  The data contained in these triples are structured and described so that machines can derive context and meaning from it.  For example, instead of just putting  "cat" as the subject.  In RDF you would use [http://dbpedia.org/resource/Cat](http://dbpedia.org/resource/Cat) as the subject. Which, is pretty much dead on McCarthy's expressible thought as a node in the public network.

McCarthy uses the following example to illustrate how to construct First Order statements.


> Frege (1892) discussed the need to distinguish direct and indirect use of words. According to one interpretation of Frege's ideas, the meaning of the phrase "Mike's telephone number" in the sentence "Pat knows Mike's telephone number" is the concept of Mike's telephone number, whereas its meaning in the sentence "Pat dialed Mike's telephone number" is the number itself. Thus if we also have Mary's telephone number = Mike's telephone number", then Pat dialed Mary's telephone number" follows, but "Pat knows Mary's telephone number does not. phone number" is the number itself. Thus if we also have Mary's telephone number = Mike's telephone number", then Pat dialed Mary's telephone number" follows, but Pat knows Mary's telephone number does not.


McCarthy express the statement "Pat knows Mike's telephone number" as:


> true Know(Pat; Telephone Mike)


He then uses more formalized statements to derive logic statements and reasoning from this example.

At this point, I was seeing more connections to the field of Semantic Web. Expressing data in RDF/ OWL gives computers exactly this type of logic and reasoning ability too.

So how would you go about expressing "Pat knows Mike's telephone number" in Semantic Web data form?   This question is not a simple one,(at least for me),  because there are so many different ways that you can construct RDF.  The choices were a bit overwhelming.

One option might be to use RDF reification, in which you can make statements about statements.  Another option might be using OWL classes and properties.  There are some excellent answers when I posed the question on [http://stackoverflow.com/questions/13114018/how-to-state-pat-knows-mikes-telephone-number-in-rdf-owl.](http://stackoverflow.com/questions/13114018/how-to-state-pat-knows-mikes-telephone-number-in-rdf-owl)

Indeed, it seems that we can express individual concepts and propositions in Semantic Web form quite well.  I had not realized that John McCarthy is the father of Sematic Web as well.

In closing, he speaks of AI Applications. Reasoning and predication are familiar applications that we use today. However he hits upon one that is quite interesting to me. That is "..determining that it **does not know **something or that someone else doesn't." This is not a common area to think about with computer programs. We are usually much more focused on what it does know and how to reason about it. But, if we are really to build intelligent, learning systems, we need to be able to identify what it does not know as well.  Perhaps then the AI can help us humans, who are pretty bad at that too.
