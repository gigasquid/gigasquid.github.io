---
layout: post
title: "Conversations with Datomic"
date: 2015-08-15 10:29
comments: true
categories:
- All
- Clojure
- Datomic
---

{% img https://avatars0.githubusercontent.com/u/1478702?v=3&s=200 %}

**Human:** Hi [Datomic](http://www.datomic.com/).   I have been hearing good things about you.  I would like to talk to you and get to know you.  Is that alright?

**Datomic:** Sure!  I would be happy to talk with you.  What language would you like to converse in?

**Human:**  I like Clojure.

**Datomic:**  That is one of my favorites too.  You know how to setup a Leiningen project right?

**Human:** Oh yes.  What dependency should I use?

**Datomic:** Just use `[com.datomic/datomic-free "0.9.5206"]`.

**Human:** Got it.  Do you mind if I record our conversation in a namespaced file, so that I can refer back to it later?

**Datomic:**  Not a problem.  Make sure to require `datomic.api` when you set it up.

```clojure
(ns conversations.datomic
  (require [datomic.api :as d]))
```

**Human:**  All right.  I am all setup up.  I don't really know where to start, so maybe you can tell me a little about yourself.

**Datomic:**  I would be happy to.  I am a database of facts.  Would you like to create a database with me?

**Human:**  Sure.  How do I do that?

**Datomic:** For a casual conversation like this, we can use a in memory database with a uri like this:

```clojure
(def uri "datomic:mem://first-conversation")
````

Then we can create the database and simply connect to it.

```clojure
(d/create-database uri)
(def conn (d/connect uri))
```

**Human:** So, being a database, obviously you store things.  What sort of things to you store?

**Datomic:**  I store facts about things, which I call _datoms_.

**Human:**  That sound neat.  How do I tell you a fact to store?  For example, what if I want you to store a fact about a dog, like its name?

**Datomic:**  Ah.  Well the name of a dog is an attribute.  First, you need to tell me about the name attribute, so that I can use it to store the fact for you .  You can describe the attribute in the form of a map like this:

```clojure
{:db/id #db/id[:db.part/db]
 :db/ident :dog/name
 :db/valueType :db.type/string
 :db/cardinality :db.cardinality/one
 :db/unique :db.unique/identity
 :db/doc "Name of the Dog"
 :db.install/_attribute :db.part/db}
```
 This map is also considered a fact, that I call a  _datom_.  This datom is about the schema, which is about the possible attributes that an entity, (like a dog), can have. I will explain the different parts to you.

* `db/id` is the internal id of the fact. With `#db/id[:db.part/db]`, I will generate it for you, so you don't have to worry about it.
* `db/ident` is the human readable reference for it. While I am fine just referring to the attribute by an id, humans prefer text.  This says that you can refer to this attribute by the namespaced keyword `:dog/name`.
* `db/valueType` tells me the type of the attribute.  The dog's name is a string.
* `db/cardinality` lets me know if there is a one-to-one relationship with the entity or not. In our case, a dog has only one name.
* `db/unique` is if that attribute is unique for an entity.  In our example case, we are saying that a dog can be uniquely identified by its name.
* `db/doc` is some documentation for humans that explains a bit more about the attribute.
* `db.install/_attribute` tells me that this is an schema attribute that I should store with the other things like it.

**Human:** I think I understand. Let me try one out for myself.  So dog breed would be this?

```clojure
{:db/id #db/id[:db.part/db]
 :db/ident :dog/breed
 :db/valueType :db.type/string
 :db/cardinality :db.cardinality/one
 :db/doc "Breed of the Dog"
 :db.install/_attribute :db.part/db}
```

**Datomic:**  Yes!  I think you got it.  Let's try one more.

**Human:** Ok.  How about the dog's favorite treat?

```clojure
{:db/id #db/id[:db.part/db]
 :db/ident :dog/favorite-treat
 :db/valueType :db.type/string
 :db/cardinality :db.cardinality/one
 :db/doc "Dog's Favorite Treat to Eat"
 :db.install/_attribute :db.part/db}
```

**Datomic:** You got it.  Now, that you have these attributes, you can give them to me using a transaction with the connection.

**Human:** Ok.  Do you want that in a specific format?


**Datomic:**  Yes.  Please send it to me using the form:

```clojure
(d/transact conn [....facts....])
```

**Human:** Sounds good.  I will put the dog schema datoms we discussed in a vector and call it `dog-schema` and then send it to you.

```clojure
(def dog-schema  [{:db/id #db/id[:db.part/db]
                   :db/ident :dog/name
                   :db/valueType :db.type/string
                   :db/cardinality :db.cardinality/one
                   :db/unique :db.unique/identity
                   :db/doc "Name of the Dog"
                   :db.install/_attribute :db.part/db}
                  {:db/id #db/id[:db.part/db]
                   :db/ident :dog/breed
                   :db/valueType :db.type/string
                   :db/cardinality :db.cardinality/one
                   :db/doc "Breed of the Dog"
                   :db.install/_attribute :db.part/db}
                  {:db/id #db/id[:db.part/db]
                   :db/ident :dog/favorite-treat
                   :db/valueType :db.type/string
                   :db/cardinality :db.cardinality/one
                   :db/doc "Dog's Favorite Treat to Eat"
                   :db.install/_attribute :db.part/db}])

(d/transact conn dog-schema)
```

**Datomic:** The transaction was fine.  I know all about those dog attributes now.

**Human:**  I would like to also add a schema for owners for the dogs now.  I think I know how to describe the name of the owner, but I don't know how to express how the owner has dogs.

**Datomic:** Ah. I that case you can specify the `db:valueType` as a `ref` type.  This lets me know that it references another entity.

**Human:**  Do I need to tell you that is a type of dog somehow?

**Datomic:** No.  I am pretty smart that way.  I will figure it out
  once you try to tell me about some real entities.  In fact, entities don't have types. A ref attribute can reference _any_ entity.


**Human:**  Cool.  Well, in that case, here is the owner schema.  The owner has a name and some dogs.

```clojure
(def owner-schema [{:db/id #db/id[:db.part/db]
                    :db/ident :owner/name
                    :db/valueType :db.type/string
                    :db/cardinality :db.cardinality/one
                    :db/unique :db.unique/identity
                    :db/doc "Name of the Owner"
                    :db.install/_attribute :db.part/db}
                   {:db/id #db/id[:db.part/db]
                    :db/ident :owner/dogs
                    :db/valueType :db.type/ref
                    :db/cardinality :db.cardinality/many
                    :db/doc "Dogs of the Owner"
                    :db.install/_attribute :db.part/db}])

(d/transact conn owner-schema)
```

**Datomic:**  The transaction is fine.  I now know about the attributes that dogs and owners have.  Would you like to tell me some facts about specific dogs and owners?


**Human:**  Yes. Bob is an owner.  He has two dogs. Fluffy is a poodle whose favorite treat is cheese, and Fido is a mixed breed, whose favorite treat is a bone.  Lucy is also an owner who has one dog named Tiny.  Tiny is a Great Dane whose favorite treat is cheese.

I am a bit confused how to represent the dogs of the owners. How do I do that?

**Datomic:**  That is easy, just nest the datoms for dogs under the `:owner/dogs` attribute. You just need to create datoms for them.  Each dog or owner will by its own map.  Use `:db/id` set to `#db/id [:db.part/user]` so I can generate it for you.  Then use each attribute from the schema as the key and let me know the value.

**Human:**  Like this?

```clojure
(d/transact conn [{:db/id #db/id [:db.part/user]
                   :owner/name "Bob"
                   :owner/dogs [{:db/id #db/id [:db.part/user]
                                 :dog/name "Fluffy"
                                 :dog/breed "Poodle"
                                 :dog/favorite-treat "Cheese"}
                                {:db/id #db/id [:db.part/user]
                                 :dog/name "Fido"
                                 :dog/breed "Mix"
                                 :dog/favorite-treat "Bone"}]}
                  {:db/id #db/id [:db.part/user]
                   :owner/name "Lucy"
                   :owner/dogs [{:db/id #db/id [:db.part/user]
                                 :dog/name "Tiny"
                                 :dog/breed "Great Dane"
                                 :dog/favorite-treat "Cheese"}]}])
```

**Datomic:**  Exactly right.  I now know the facts about Bob and Lucy and their dogs.

**Human:**  Umm, how do I query you about the facts that your know?  For example, how do I ask you about the dog named Tiny?

**Datomic:**  There are a couple a ways to inquire about facts I know.  To find out about the attributes of a specific dog, or entity, I would recommend using `d/pull`.  You can ask me in the form of this to get all the attributes for a given dog name.  Note that this works since the dog name is a way to uniquely identify the dog:

```clojure
(d/pull (d/db conn) '[*] [:dog/name "Tiny"])
```

**Human:**  What is the `(d/db conn)` all about?

**Datomic:**  That function returns the current database value of the connection. The facts I know change during time.  Every time there is a transaction, I consider the time to be different and there is a new database value.  the `d/db` function gives you the most recent value that I know about.

**Human:** I am assuming the `[*]` is a wildcard that means give me all the attributes for that dog?

**Datomic:**  Exactly right.

**Human:** Ok.  Tell me about Tiny.

```clojure
(d/pull (d/db conn) '[*] [:dog/name "Tiny"])
```

**Datomic:**
```clojure
{:db/id 17592186045424
 :dog/name "Tiny"
 :dog/breed "Great Dane"
 :dog/favorite-treat "Cheese"}
```

Tiny is a Great Dane that has a favorite treat of Cheese.

**Human:**  This is fun.  What about more complicated questions.  How do I ask about the name of the owner of the dog "Tiny"?

**Datomic:**  For that I would ask using the _datalog_ query `d/q`.  It uses logic to unify your query with all of my facts and give you the result.  The query itself would be a vector with logic statements inside like:

```clojure
'[:find ?owner-name
  :where [?owner :owner/name ?owner-name]
         [?owner :owner/dogs ?dog]
         [?dog :dog/name "Tiny"]]
```

**Human:**  Whoa.  What is the deal with those question marks?

**Datomic:** The things with the question marks are considered as variables that we will _unify_ to find the answer.  For example, we are looking for something that we are going to call `?owner-name`. I am going the use the following constraints with my facts to try to find the answer:

* There is an entity that we are going to call `?owner` that has an attribute of `:owner/name` that has some value that we are going to refer to as `?owner-name`
* This same `?owner` entity must have an attribute `:owner/dogs` that has some value that we will refer to as `?dog`
* This ``?dog` is an entity that has an attribute `:dog/name` that also has the value of "Tiny".

**Human:**  Alright, so when I ask for this query, do I need to give you a database value too?

**Datomic:**  Yes.  They should have the form of:

```clojure
(d/q '[datalog-query] db-value)
```

Remember, to get the current db value use `(d/db conn)`.


**Human:**  Ok.  Here we go.

```clojure
(d/q '[:find ?owner-name
       :where [?owner :owner/name ?owner-name]
              [?owner :owner/dogs ?dog]
              [?dog :dog/name "Tiny"]]
     (d/db conn))
```

**Datomic:**

The answer is:

```clojure
#{["Lucy"]}
```

**Human:**  What if I want to pass the dog name as a parameter?  How do I communicate that to you?

**Datomic:**  You will need to use an `in` clause in the query like this:

```clojure
'[:find [blah]
   :in $ ?dog-name
   :where [blah]]
```

The $ is shorthand for the database value and the `?dog-name` is what you will pass in as a parameter in the query after the db-value.

**Human:**  Like this?

```clojure
(d/q '[:find ?owner-name
       :in $ ?dog-name
       :where [?owner :owner/name ?owner-name]
              [?owner :owner/dogs ?dog]
              [?dog :dog/name ?dog-name]]
     (d/db conn) "Tiny")
````

**Datomic:**  Exactly right.  The answer is Lucy again.

```clojure
#{["Lucy"]}
```

**Human:**  I think I am getting the hang of this!  Another quick question.  How would I go about asking you which dogs have cheese as their favorite treat?  I would want the dog's name and breed back.


**Datomic:**  You would simply construct another datalog query.  This time I would recommend that you combine the `pull` syntax within the `find` part of the query.  The `pull` syntax is great at selecting attributes from an entity.  So the `find` part would look something like this:

```clojure
[(pull ?dog [:dog/name :dog/breed]) ...]
```

This will return the attributes of the `:dog/name` and the `:dog/breed`.  The three dots on the end will let me know that you want a collection returned, so I will give you back a simple vector with the entity attributes requested, instead of the set of vectors I normally give back.

The `where` section of the query is going to look for the `?dog` entity that matches the `:dog/favorite-treat` attribute with "Cheese".

```clojure
'[:find [(pull ?dog [:dog/name :dog/breed]) ...]
  :where [?dog :dog/favorite-treat "Cheese"]]
```

**Human:**  Then I put it together with the current database value in a `d/q` function?

```clojure
(d/q '[:find [(pull ?dog [:dog/name :dog/breed]) ...]
       :where [?dog :dog/favorite-treat "Cheese"]]
     (d/db conn))
```

**Datomic:** Yup.  The answer is:

```clojure
[{:dog/name "Fluffy", :dog/breed "Poodle"}
 {:dog/name "Tiny", :dog/breed "Great Dane"}]
```

**Human:**  Thanks so much.  I think I beginning to get the hang of schemas and queries.  What other things do I need to know about you?

**Datomic:**  Well, you have just scratched the surface really.  One of the most interesting things about me is that I never forget facts.  You can add new facts, like Tiny's favorite food is now hotdogs, but I won't forget that he liked cheese at another point in time.


**Human:** That sounds really interesting.  I think I need some tea and cookies before I delve into that.  Let's take a short break and talk again soon.

**Datomic:**  My pleasure.  I look forward to it.


_Special thanks to [Paul deGrandis](https://twitter.com/ohpauleez) for
the conversation idea :)_
