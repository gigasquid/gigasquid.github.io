---
layout: post
title: "A Taste of the Star Programming Language"
date: 2014-06-11 10:38
comments: true
categories:
- All
- Star
---

A while ago, I was [exploring creating a programming language with
Instaparse](http://gigasquidsoftware.com/blog/2013/05/01/growing-a-language-with-haskell-and-instaparse/).
I ended up exploring some concepts of Speech Acts proposed by John
McCarthy by creating my first toy language called
[Babar](http://gigasquidsoftware.com/blog/2013/06/04/babar-a-little-language-with-speech-acts-for-machines/).
Shortly after posting a blog about it, I got an email from someone
saying that I might be interested in a full blown, real programming
language that also incorporated Speech Acts.  I happily started
composing an reply to the email that started off with

    That is so cool! ...

Then I realized that the author of the email and language was none
other than
Frank McCabe,
one of the designers of the
[Go! programming language](http://bit.ly/1pJtG0x)
(not to be confused with Google Go).  My brain froze
while it was thinking

    "OMG!!!! Frank McCabe, a real language designer, just email me!".

This unfortunately, made the rest of my email reply sound something like
this

    Frank,
    That is so cool!  herp derp derp Speech Acts herp derp John
    McCarthy derp...
    

His programming language is the Star
Programming Language.  It was originally developed for use at a company that he
worked at called Starview.  It has since been open sourced and moved
to [git](https://github.com/fmccabe/star).  I finally had a bit a
spare time and I had been itching to give
Star a look.  To my pleasant surprise, despite my initial fumbling
email impression,  Frank was open a friendly to
get me started in it.
I have only scratched the surface in exploring the language, but I
wanted to share my initial impressions, as well as point you to some
[beginner katas](https://github.com/gigasquid/star-lang-katas) that I
put together, so that you could join in the fun.


## Crash Overview
Star is a strongly typed, functional language. It is not a pure
functional language because is allows assignment and stateful objects,
but the language is designed in a way that immutable functional
programming is encouraged. The feel of the language is concise but
human readable.

{% blockquote Feel different on the Java platform: the star programming language  http://dl.acm.org/citation.cfm?id=2500837&dl=ACM&coll=DL&CFID=354902651&CFTOKEN=90319052 %}
    Star is a coherent, general-purpose programming language that
    combines elements from a wide variety of existing languages as
    well as adding innovative elements of its own. Star inherits func-
    tional programming in general, a Haskell-style type system, an F#-
    style monad for parallel computations, and Concurrent ML for or-
    chestrating concurrent and parallel applications.
{% endblockquote %}

### Hello World
The best way to get a feel for it is to look at a few examples.  Of
course, let's start off with Hello World.

```haskell
main() do {
  logMsg(info, "Hello World");
}
```

Another way of doing our Hello World is in a worksheet.
This feature is still in the works, but it will likely turn into a
replacement for a REPL, being integrated into the editor.  The import
statement will also soon not be required.  But a nice feature of using
the worksheeet is that is a combined module and transcript of the
session.

```haskell
import worksheet
 
worksheet{
  show "hello world"
}
```

Here is what the output looks like:

    Jun 11, 2014 11:21:09 AM  
    INFO: "hello world" -> "hello world" at 4
    info: execution took 0.053684428

### Pattern Matching
Let's take a look at another example.  This time a naive fib function
with pattern matching.

```haskell
import worksheet
 
worksheet{
  fib(0) is 0
  fib(1) is 1
  fib(n) is fib(n-1) + fib(n-2)
 
  assert fib(0)=0;
  assert fib(1)=1;
  assert fib(3)=2;
  assert fib(10)=55;
}
```

Notice how the fib function is defined with pattern matching.  Also
how the keyword "is" is used instead of an "=" to make the code flow
more readable (IMO).

The output of running the program is:


    Jun 11, 2014 3:32:38 PM  
    INFO: fib(0) = 0 ok at 9
    Jun 11, 2014 3:32:38 PM  
    INFO: fib(1) = 1 ok at 10
    Jun 11, 2014 3:32:38 PM  
    INFO: fib(3) = 2 ok at 11
    Jun 11, 2014 3:32:38 PM  
    INFO: fib(10) = 55 ok at 12
    info: execution took 0.039725132

### Pattern Matching with Guards
The declaration of pattern matching for functions can also include
guards like in this fizzbuzz example

```haskell
fizzbuzz has type (integer) => string
fizzbuzz(N) where N%3=0 and N%5=0 is "fizzbuzz"
fizzbuzz(N) where N%3=0 is "fizz"
fizzbuzz(N) where N%5=0 is "buzz"
fizzbuzz(N) default is "$N"
```
Also note the type declaration.  The type declaration is optional.
The complier is smart enough to figure it out.  Sometimes it is more
readable to include the type declaration.  But, it can be left out for
more concise code.

### Cons Lists

One of the important collection types are cons lists. These are lists
that you add to the front of and are destructed as the first element
and then the rest of the list. To construct a cons list:

```haskell
 testNumbers is cons of {1;2;3;4;5;6;7;8;9;10;11;12;13;14;15}
```

To use a cons list in a function with pattern matching:

```haskell
listFizzBuzz has type (cons of integer) => cons of string
listFizzBuzz(nil) is nil
listFizzBuzz(cons(x, xs)) is cons(fizzbuzz(x), listFizzBuzz(xs))
```

The function listFizzBuzz takes in a list of integers and turns it
into a list of strings using the fizzbuzz function. If we evaluate:

```haskell
testNumbers is cons of {1;2;3;4;5;6;7;8;9;10;11;12;13;14;15}
result is listFizzBuzz(testNumbers)
```

The result will look like
```haskell
cons of {"1";"2";"fizz";"4";"buzz";"fizz";"7";"8";"fizz";"buzz";"11";"fizz";"13";"14";"fizzbuzz"}
```

There are other collection types such as arrays and relations, (which
are really cool - you can do queries on them like a database), but I haven't explored them well enough to really
talk about yet.

### Actors and Speech Acts

Star has actors that use three Speech Acts: Notify, Request, and
Query.  The actors themselves can also be concurrent. I explored the
Speech Act/ Actor model with an example from John McCarthy's
[Elephant 2000 paper](http://www-formal.stanford.edu/jmc/elephant/elephant.html),
which is a Airline Reservation system.

To use the notify speech act, you need to define what type the
notifications are on the actors channel.  In my case, the
notifications are either going to be a book(string) method, or a
cancel(string) method.  To book a reservation for a person or cancel
it.

```haskell
type tx is book(string) or cancel(string);
```

The actor is defined using:

```haskell
flight((FlightName has type string), (MaxPeople has type integer)) is actor{
    var flightStatus := "open";
 
    setFlightStatus(s) do { flightStatus := s };

    on book(pname) on Tx do
        logMsg(info,"booking $pname on #FlightName's flight: max #MaxPeople current $(size(plist))");
    on book(pname) on Tx where size(plist) < MaxPeople do
      extend plist with pname;
    on book(pname) on Tx where size(plist) >= MaxPeople do
      logMsg(info, "sorry .. the flight is full");
    on book(pname) on Tx where flightStatus != "open" do
      logMsg(info, "sorry .. the flight is no longer open");

    on cancel(pname) on Tx do
      delete (X where X = pname) in plist;

    getPassengerList has type () => list of string;
    getPassengerList() is plist;
    }
```

There is some extra things in the code, but for right now, look at the
book and cancel methods.  These are the functions that will be called
when the actor is notified like this:

```haskell
F is flight("flight123", 5)
notify F with book("Carin") on Tx
notify F with book("Bob") on Tx
```

To query the actor we use :

```haskell
 x is query F's getPassengerList with getPassengerList()
```

To use a request with the actor we use

```haskell
 request F's setFlightStatus to setFlightStatus("closed")
```

## Go Explore

I have only scratched the surface of the language, but I have had a
great time.  I invite you to come take a look.

Warning.  Only the brave need apply.  There is no StackOverflow.
There is no user group or IRC channel yet.  These are green fields to
be discovered in the Open Source world.  If it appeals to you as much
as me, jump on in.  Here are a few resources to get you going:

* [Star-Lang Katas](https://github.com/gigasquid/star-lang-katas):
  Clone the repo or fork the repos.  It has a shell script
  to compile and run the star programs.  It also has a emacs mode
  plugin and a reference pdf. The most important part is that it has a
  template of katas ready for your to solve.  Your challenge:
  uncomment the assertion and make the code pass.  My solutions are in
  the solutions branch when you are done.  If you finish all of them
  and want more, consider creating some and submitting a pull request :)

* I mentioned it earlier, but there is a great overview paper on the
  language itself
  [here](http://www.deinprogramm.de/sperber/papers/star.pdf).

* Finally, here is the repo of the Star Language itself
  [https://github.com/fmccabe/star](https://github.com/fmccabe/star).
  Checkout out the tests.  There are tons of sample star programs
  that cover the language's features.
















