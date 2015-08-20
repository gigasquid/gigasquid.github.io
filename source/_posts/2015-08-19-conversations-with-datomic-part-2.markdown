---
layout: post
title: "Conversations with Datomic Part 2"
date: 2015-08-19 08:56
comments: true
categories:
- All
- Clojure
- Datomic
---

{% img https://avatars0.githubusercontent.com/u/1478702?v=3&s=200 %}

_The following is a continuation of the first [conversation](http://gigasquidsoftware.com/blog/2015/08/15/conversations-with-datomic/) which touched on schema creation and querying.  This conversation includes learning new facts, time, and the sometimes unfortunate reality of lawyers._

**Human:**  Hi [Datomic](http://www.datomic.com/).  I am back from my tea and cookies break.  I really enjoyed talking with you, could we continue our conversation?

**Datomic:** Certainly.  Let me see, where did we leave off?

**Human:** Let me check my [notes](https://gist.github.com/gigasquid/92a1effb14fe4f6ced59).  Oh yes, we had created a database and filled it with facts about some dogs and owners.  You showed me how to ask you things about the facts, like which dogs liked cheese.

**Datomic:** Ah yes.  We were just getting to the really interesting part about how I learn new facts without forgetting the past ones.

**Human:** Can you please explain a bit more about how you learn new facts?

**Datomic:** Sure.  I learn facts when you tell me to _add_ a new fact about some entity, or to _retract_ a fact about it.  It will probably make more sense with an example.  Let's take the dog with the name "Tiny" that I know about.  Could you please ask me about the dog and all of the attributes?

**Human:** Alright.

```clojure
(d/pull (d/db conn) '[*] [:dog/name "Tiny"])
```

**Datomic:**

```clojure
{:db/id 17592186045423
 :dog/name "Tiny"
 :dog/breed "Great Dane"
 :dog/favorite-treat "Cheese"}
```
There is an entity (dog) with the name "Tiny" who is a Great Dane and his favorite-treat is Cheese.  I am not really sure why the Cheese is capitalized, but I am sure it makes sense to a human.

**Human:** Oh right.  Well, now that you mention it, I am not really sure about the cheese thing either. Can I just remove that fact?


**Datomic:** Well, you can tell me to _retract_ that fact by sending me a transaction in the form of `[:db/retract entity-id attribute value]`.  In the case of the dog, since the name attribute is unique, you can just give me the selector for Tiny like this `[:dog/name "Tiny"]`.

**Human:** Like this?

```clojure
(d/transact conn [[:db/retract [:dog/name "Tiny"] :dog/favorite-treat "Cheese"]])
```

**Datomic:** Exactly.  I have retracted that fact about "Tiny".  Go ahead and ask me about all of Tiny's attributes again.

**Human:**  Ok.  I use `(d/db conn)` for the current database value right?

**Datomic:** Yes. But if you are going to be asking me multiple questions about this database value, you should not repeat the `(d/db conn)` all the time.

**Human:** Oh. What should I do instead?

**Datomic:** The connection with me is like a ref.  Just like other refs, you should deref it once to get the database value and then use the value repeatedly. This single database value will provide consistency for all your queries.

**Human:** That makes sense.


```clojure
(def db-tiny-no-cheese (d/db conn))

(d/pull db-tiny-no-cheese '[*] [:dog/name "Tiny"])
```

**Datomic:**

```clojure
{:db/id 17592186045423, :dog/name "Tiny", :dog/breed "Great Dane"}
```

Tiny is a Great Dane.


**Human:** So you don't know anything about the `:dog/favorite-treat` for "Tiny"?

**Datomic:** At this particular time, I do not have anything to assert about the favorite-treat of Tiny.  However, I still remember everything about all the facts that you have told me.  For each transaction that you send me, I have a notion of a point in time like _t0_, _t1_, _t2_.  I have a complete database value for each one of those points in time.  In fact, you can look at _all_ of my assertions and retractions that I have learned about using the `d/history` function on the database value.  This asks me to expose my history, which is normally hidden in favor of the _present_. I will return back a special database containing all the _datoms_ with an additional field.

**Human:**  What is the additional field?

**Datomic:** Normally, a _datom_ consists of 4 parts: the entity, the attribute, the value, and the transaction (e a v tx).  This history database adds a fifth part to this datom, operation, which tells you if the fact was added or retracted (e a v tx op).  Why don't you try using the `d/history` function to ask me about all the facts having to do with Tiny?  I suggest using the datalog query

```clojure
'[:find ?e ?a ?v ?tx ?op
  :in $
  :where [?e :dog/name "Tiny"]
         [?e ?a ?v ?tx ?op]]
```

which will return all the entity, attribute, value, transaction, and operation facts I ever knew about Tiny.

**Human:** Ok.  Here goes.

```clojure
(d/q '[:find ?e ?a ?v ?tx ?op
       :in $
       :where [?e :dog/name "Tiny"]
       [?e ?a ?v ?tx ?op]]
  (d/history db-tiny-no-cheese))
```

**Datomic:**

```clojure
#{[17592186045423 63 "Tiny"       13194139534314 true]
  [17592186045423 64 "Great Dane" 13194139534314 true]
  [17592186045423 65 "Cheese"     13194139534314 true]
  [17592186045423 65 "Cheese"     13194139534320 false]}
```

During one transaction, you told me to add three facts about an entity:

* The `:dog/name` attribute, (which I refer to as 63), has the value of "Tiny".
* The `:dog/breed` attribute, (which I refer to as 64), has the value of "Great Dane".
* The `:dog/favorite-treat` attribute, (which I refer to as 65), has the value of "Cheese".

During another transaction, you told me to retract a fact regarding the attribute `:dog/favorite-treat` about the same entity.

**Human:** Wow, that is really cool.  Is there a way that I can _travel back in time_ to see the world as it was during that first transaction?

**Datomic:** Yes.  I am practically a Tardis.  You can use the `d/as-of` function with a database value and the transaction number and you can time travel.  Using that _time traveled_ database value, you can ask me about all the facts I knew as of that time.

**Human:** I can't wait to try this.  Ok, let's go back to the time when I first asserted the fact that Tiny liked cheese.

```clojure
(d/pull (d/as-of db-tiny-no-cheese 13194139534314) '[*] [:dog/name "Tiny"])
```

**Datomic:**  Hold on.  We are time traveling!

```clojure
{:db/id 17592186045423
 :dog/name "Tiny"
 :dog/breed "Great Dane"
 :dog/favorite-treat "Cheese"}
```

Tiny is a Great Dane whose favorite treat is Cheese.

**Human:** Fantastic! Let's go back to the future now, ummm I mean present. Time is a bit wibbly wobbly.

**Datomic:** Just take the `as-of` function off of the database value and you will be back in the _present_.

**Human:** Hmmm... Do I have to do a _retract_ every time I want to change a value?  For example, the dog named Fido has a favorite treat of a Bone right now, right?

```clojure
(d/pull db-tiny-no-cheese '[*] [:dog/name "Fido"])
```

**Datomic:**

```clojure
{:db/id 17592186045421
 :dog/name "Fido"
 :dog/breed "Mix"
 :dog/favorite-treat "Bone"}
```

Yes, it is a "Bone".

**Human:** So, if I want to change it to be "Eggs".  Do I need to retract the current value of "Bone" first and then add the fact of "Eggs"?

**Datomic:** You certainly could do that and I would understand you perfectly.  However, if you simply assert a new value for an existing attribute, I will automatically add the retraction for you.

**Human:** Cool.

```clojure
(d/transact conn [{:db/id [:dog/name "Fido"]
                   :dog/favorite-treat "Eggs"}])

(d/pull (d/db conn) '[*] [:dog/name "Fido"])
```

**Datomic**

```clojure
{:db/id 17592186045421
 :dog/name "Fido"
 :dog/breed "Mix"
 :dog/favorite-treat "Eggs"}
```

Fido now has a favorite-treat of "Eggs".

**Human:** This is really cool.  You _never_ forget any facts?

**Datomic:** Nope. Well, except in really exceptional circumstances that usually involve lawyers.

**Human:** Lawyers?

**Datomic:** Sigh.  Yes, well in some unique situations, you might be under a legal obligation to really _forget_ certain facts and totally remove them from the database. There is a special tool that you can use to _excise_ the data.  However, I will store a fact that _something_ was deleted at that time. I just won't be able to remember _what_.

**Human:** That doesn't sound fun.

**Datomic:** I prefer to keep all my facts intact.

**Human:** I can definitely see that. Well, on a happier subject, I have been very impressed with you during our conversations.  Having a time traveling database that can reason about facts seems like a really useful thing.  You are also really nice.

**Datomic:** Awww shucks, thanks.  You are really nice for a human too.

**Human:** I was thinking about the possibility of you coming and working with me every day. Would you mind chatting some more to me about your architecture?  I want to understand how your would fit with our other systems.

**Datomic:** Certainly. I would love that.  Do you want to talk about it now, or have another cookie break first?

**Human:** Now that you mention cookies... Let's take a short break and we will talk again soon.
