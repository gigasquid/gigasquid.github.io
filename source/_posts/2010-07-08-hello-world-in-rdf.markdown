---
author: gigasquid
comments: false
date: 2010-07-08 03:33:20+00:00
layout: post
slug: hello-world-in-rdf
title: Hello World in RDF
wordpress_id: 29
categories:
- All
- Semantic Web
tags:
- RDF
- Semantic Web
---

I decided to start playing with RDFs to start me on the road to understanding and programming Semantic Web.  As always, the first step it to start with a “Hello World” type of exercise.  In my case, I had armed myself with a good cappuccino at Starbucks and decided to set myself with a purl link and FOAF page.
[
FOAF (Friend of a Friend)](https://secure.wikimedia.org/wikipedia/en/wiki/FOAF_%28software%29) is one of the most popular vocabularies out there for RDF (Resource Description Framework).  It expresses relationships in a machine readable format and is considered one of the first social Semantic Web applications.

When you look at a foaf.rdf file, it is basically just an file with xml tags:

    
    <foaf:Person rdf:ID="me">
    <foaf:name>Carin Meier</foaf:name>
    <foaf:givenname>Carin</foaf:givenname>
    <foaf:family_name>Meier</foaf:family_name>
    <foaf:nick>squid</foaf:nick>
    


Not too much fun to start coding by hand though.  Luckily, there is a handy dandy generator - [FOAF-a-matic.](http://www.ldodds.com/foaf/foaf-a-matic) Just fill in the form and you can easily generate the basic foaf rdf file for yourself.  You can always add to it later.  Save the file as foaf.rdf somewhere on your website for indexing.

Now you can do some fun stuff with it.  You can check and visualize your RDF document with [http://www.w3.org/RDF/Validator/](http://www.w3.org/RDF/Validator/).  Or you can use a[ FOAF visualizer](http://foaf-visualizer.org/?uri=http://gigasquidsoftware.com/foaf/foaf.rdf).

The final part is to set yourself up with a purl address.  [Purl.org](http://www.purl.org/docs/index.html) is a website that is dedicated to providing web endpoints or addresses that can be indentifiers for individuals.  It provides a layer of indirection that is very useful in the changing world of the web.  For example, if I use my work web page link as my identifier in my RDF and then I change jobs, all my FOAF links will be broken.  However, I can use my purl address and set up my identifier as my webpage and then change it when then need arises.   So logon to purl.org and set yourself up with an account.
When other people "know" you in FOAF, they can use your purl link:


> <foaf:Person>
<foaf:name>Carin Meier</foaf:name>
<rdfs:seeAlso rdf:resource="http://purl.org/net/cmeier"/>
</foaf:Person>


My FOAF is [http://gigasquidsoftware.com/foaf/foaf.rdf](http://gigasquidsoftware.com/foaf/foaf.rdf)
My purl link is [http://purl.org/net/cmeier](http://purl.org/net/cmeier)

That's it!  Hello World in FOAF!
