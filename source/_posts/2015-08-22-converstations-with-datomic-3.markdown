---
layout: post
title: "Conversations with Datomic - Part 3"
date: 2015-08-22 10:28
comments: true
categories:
- All
- Clojure
- Datomic
---

{% img https://avatars0.githubusercontent.com/u/1478702?v=3&s=200 %}

_This is a continuation of the [first](http://gigasquidsoftware.com/blog/2015/08/15/conversations-with-datomic/) and
[second](http://gigasquidsoftware.com/blog/2015/08/19/conversations-with-datomic-part-2/) conversations in which topics such as creating databases,
learning facts, querying, and time traveling were discussed.  Today's topics include architecture, caching, and scaling._

**Human:**  Hello again [Datomic](http://www.datomic.com/). Ready to talk again?

**Datomic:** Sure.  I think you wanted to ask me some questions about how I would fit in with your other systems.

**Human:** Yes.  Like I was saying earlier, I think your abilities to learn facts, reason about them, and keep track of the history of all those facts is really great.
I am interested in having you work with me every day, but first I want to understand your components so that I can make sure you are a good fit for us.

**Datomic:** I would be happy to explain my architecture to you.  Perhaps showing you this picture is the best way to start.

{% img http://c2.staticflickr.com/6/5723/20819693686_f9ec3852c3_z.jpg %}

I am made of three main parts: my _transactors_, my _peers_, and my storage.

**Human**:  What is a _peer_?

**Datomic**:  A _peer_ is an application that is using the peer library.  In our last conversations,  we were talking through the Clojure api with `datomic.api`.  The application, or process, that is running this api is called a peer.  There can be many of these, all having conversations with me.

**Human**: The peers then talk to your _transactor_?

**Datomic** Yes. The peers talk to my transactor whenever you call `transact` with the peer library.  It is the central coordinator between all the peers and processes the requests using _ACID_ transactions, and then sends the facts off to storage.

**Human:**  Could you remind me what _ACID_ stands for again?  I always forget.  The first one is _Atomic_ right?

**Datomic:** That is right.  I am _Atomic_ in that every transaction you send to me is all or nothing.  If for some reason, one part of it fails, I will reject the entire transaction and leave my datbase unchanged.

The C is for _Consistency_.  This means that I provide every peer with a consistent view of facts over time and transactions.  I provide a global ordering of transactions across all the peers with my transactor and peers will always see all the transactions up to their current time without any gaps.

**Human:** What if a peer is behind the global time?  How do they catch up to know about the new facts that were transacted by a different peer?

**Datomic:** After one peer sends me a successful transaction with some new facts, I will notify all the peers about them.

**Human:** Cool. That takes care of the A and C in ACID. What about the I?

**Datomic:** It stands for Isolated.  It makes sure that even through there are many peers having conversations with me, transactions are executed serially.  This happens naturally with my transactor.  Since there is only one transactor, transactions are always executed serially.

**Human**:  In the picture, why are there are two transactors then?

**Datomic**:  Oh, that is just in case of emergencies.  When I startup my system, I launch two running transactors, but I hold one of them in reserve.  Just on the off chance something happens to the main one, I will swap in the failover one to keep things running smoothly.

The final D in _ACID_ is for Durability.  Once a transaction has been committed by my transactor, it is shipped off to storage for safe keeping.

**Human:** What exactly is this storage?

**Datomic:** Instead of storing datoms, I send blocks to storage.  I have quite a few options for storage:

* Dev mode - which just runs within my transactor and writes to the local file system.
* SQL database
* DynamoDB
* Cassandra
* Riak
* Couchbase
* Infispan memory cluster

**Human:** Which one is the best to use?

**Datomic:** The best one to use is the one that you are already have in place at work.  This way, I can integrate seamlessly with your other systems.  Some people even think of me as a smart caching and query layer on top of their existing database.

**Human:** Oh, we didn't really talk about caching.  Can you explain how you do that?

**Datomic:** Certainly.  It is even worth another picture.

{% img http://c2.staticflickr.com/6/5630/20852217305_90506481fe.jpg %}

Each peer has a its own _working set_ of recent datoms along with a index to all the rest of the datoms in storage in memory.  When the peer has a query for a datom, it first checks to see if it has it locally in its memory cache.  If it can't find it there, then it will ask for a segment chunk of that datom from storage.  Storage will return that datom along with other related datoms in that seqgment so that the peer can cache that in memory to make it faster for the next query.

**Human:** That seems really different from other databases, where the client constantly requests queries from a server.

**Datomic:** Yes.  When most questions can be answered from the local memory, responses are really fast.  You don't need to hit storage unless you really need too.  You can even add an extra layer of caching with memcached.


**Human:** That sounds great.  I can't wait tell you about all of our data.  Is there a limit to how many facts you can know?

**Datomic:** I can hold up to 10 billion datoms.

**Human:** Whoa, that seems like a lot.  But what happens if we need more?

**Datomic:** You have two options, you could shard me, by storing things in multiple Datomic databases if your data makes sense that way.  You could also go through a process called _decanting_, where you can pour off some very old historical data that you don't need anymore into another Datomic database or long term storage.

**Human:** That sounds fine.  What about scaling?


**Datomic:** I really excel at reads.  All you have to do is elastically add another peer to me for querying.  I am not really a good fit for write scale.  You will find me most happy with data that is valuable information of record and has history that is important.  I am also really good at being flexible for development and operations since I can use many different types of storage.


**Human:** Thanks for answering all my questions.  I think you would fit in quite well with our other systems.  I would be happy to have you come and work with us.

**Datomic:** Great!

**Human:** One more thing, this conversation has been great, but do you have any training resources for me and  my other human coworkers?

**Datomic:** Sure thing. There are a few really good resources on the [Datomic Training Site](http://www.datomic.com/training.html).  I would suggest watching the videos there and pairing them with:

* [The slides for the videos](https://github.com/stuarthalloway/presentations/blob/master/Nov2014/DayOfDatomicNov2014.pdf?raw=true) which have the labs to work through form the videos.
* [The Day of Datomic Repo](https://github.com/Datomic/day-of-datomic) which has lots of great examples to play with.
* [Tne Datomic Development Resources](http://docs.datomic.com/), which include the docs on the [Clojure API](http://docs.datomic.com/clojure/index.html)


**Human:** Thanks Datomic.  I look forward to working with you.

**Datomic:** Likewise, see you soon. Eat a cookie for me :)
