---
layout: post
title: "Embedded Interop between Clojure, R, and Python with GraalVM"
date: 2017-10-22 16:02
comments: true
categories: Clojure, All
---

{% img https://images-na.ssl-images-amazon.com/images/M/MV5BOTViY2Y0ZGItMTg2OC00YzEzLWJhYjYtZjg4OTMyOWE4YzM1XkEyXkFqcGdeQXVyNTQ1NzU4Njk@._V1_.jpg  %}

In my talk at [Clojure Conj](https://www.youtube.com/watch?v=eLl6_k_fZn4) I mentioned how a project from Oracle Labs named GraalVM might have to potential for Clojure to interop with Python on the same VM. At the time of the talk, I had just learned about it so I didn't have time to take a look at it. Over the last week, I've managed to take it for a test drive and I wanted to share what I found.

### Are you ready?

In this example, we will be using an ordinary Leinengen project and using the REPL we will interop with both R and python.

But first will need a bit of setup.

We will download the [Graal project](http://www.oracle.com/technetwork/oracle-labs/program-languages/downloads/index.html) so we can use its `java` instead of our own.

Once we have it downloaded we will configure our PATH to use Graal's java instead of our own.


```
# export PATH=/path/to/graalAndTruffle/bin:$PATH
```

Now, we can create a new lein project and run `lein repl` and begin the fun.

### The Polyglot Context

In our new namespace, we just need to import the [Polyglot Context](http://graalvm.github.io/graal/truffle/javadoc/org/graalvm/polyglot/Context.html) to get started:

```clojure
(ns graal-test.core
  (:import (org.graalvm.polyglot Context)))

;; note that is also supports Ruby, LLVM, and JS
(def context (Context/create (into-array ["python" "R"])))
```

Now, we are ready to actually try to run some R and Python code right in our REPL. Let's start first with R.

### Interoping with R

The main function we are going to use is the `eval` function in the context. Let's start small with some basic math.

```clojure
(.eval context "R" "
3^2 + 2^2
")
;=> #object[org.graalvm.polyglot.Value 0x7ff40e4d "13.0"]
```

Wow! It actually did something. It returned something called a [Polyglot Value](https://github.com/graalvm/graal/blob/master/sdk/src/org.graalvm.polyglot/src/org/graalvm/polyglot/Value.java) with what looks like the right answer in it.

Emboldened by our early success, let's try something a little more complicated like calling a function.

```clojure
(def result1 (.eval context "R" "
sum.of.squares <- function(x,y) {
  x^2 + y^2
}
sum.of.squares(3,4)
"))
;=> #object[org.graalvm.polyglot.Value 0xc3edd92 "25.0"]
```

Again, it looks like it worked. Let's try to get the result back into Clojure as a value we can work with. We could ask the result what sort of type it is with 

```clojure
(.isNumber result1) ;=> true 
```

but let's just use `clojure.edn` to read the string and save some time.

```
(defn ->clojure [polyglot-value]
  (-> polyglot-value
      (.toString)
      (clojure.edn/read-string)))

(->clojure result1) ;=> 25
```

It would be nice to have a easier way to export symbols and import symbols to and from the guest and host language. In fact, Graal provides a way to do this but to do this in Clojure, we would need something else called [Truffle](https://github.com/graalvm/graal/tree/master/truffle).

Truffle is part of the Graal project and is a framework for implementing languages with the Graal compliler.
There are quite a few languages implemented with the Truffle framework. R is one of them.

{% img https://image.slidesharecdn.com/polyglotonthejvmwithgraalenglish-170521104613/95/polyglot-on-the-jvm-with-graal-english-14-638.jpg?cb=1495364615 %}

My understanding is that if Clojure was implemented as a truffle lang, then interop could be much more seamless like this example in Ruby

{% img https://image.slidesharecdn.com/polyglotonthejvmwithgraalenglish-170521104613/95/polyglot-on-the-jvm-with-graal-english-37-638.jpg?cb=1495364615 %}


But let's continue in our exploration. What about doing something more interesting, like importing a useful R library and using it. How about the [numDeriv](https://www.rdocumentation.org/packages/numDeriv/versions/2016.8-1) package that supports Accurate Numerical Derivatives?


First we import the package using cran.

```clojure
(.eval context "R" "
install.packages(\"numDeriv\", repos = \"http://cran.case.edu/\")
")
```

If you are doing this at your REPL, you can will see lots of text going on in your `lein repl` process at this point. It's going out and figuring out what deps you need and installing them in your `/graalvm-0.28.2/jre/languages/R` directory structure.

After it is done, we can actually use it!

```clojure
(def result2 (.eval context "R" "
library(numDeriv)
grad(sin, (0:10)*2*pi/10)
"))
result2 ;=> #object[org.graalvm.polyglot.Value 0x76765898 "c(1,
        ;0.809016994367249, 0.309016994372158, -0.309016994373567,
        ;-0.809016994368844, -0.999999999993381, -0.809016994370298,
        ;-0.309016994373312, 0.309016994372042, 0.809016994369185,
        ;0.999999999993381)"]
```

This has a bit more interesting result as an array. But the Context has ways of dealing with it.

```clojure
(.hasArrayElements result2) ;=> true
(.getArraySize result2) ;=> 11

(for [i (range 10)]
  (-> (.getArrayElement result2 i) (->clojure)))
;=> (1.0 0.8090169943672489 0.3090169943721585 -0.3090169943735675
;-0.8090169943688436 -0.9999999999933814
; -0.8090169943702977 -0.3090169943733122 0.30901699437204233
; 0.8090169943691851)
```

So, we've showed basic interop with R - which is pretty neat. What about Python?

### Interoping with Python

Truffle is scheduled to fully support Python in 2018, but there is already an early alpha version in the Graal download that we can play with.

```clojure
(.eval context "python" "
import time;
time.clock()
")
 ;=> #object[org.graalvm.polyglot.Value 0x4a6b3b70 "1.508202803249E9"]
```

Neat!

It is still a long way for `import numpy` or `import tensorflow` but cPython compatibility is the goal. Although the c-extensions are the really tricky part.

So keep an eye on Graal and Truffle for the future and wish the Oracle Labs team the best on their mission to make the JVM Polyglot.


### Footnotes

If you are interested in playing with the code. I have a github repo here [graal-test](https://github.com/gigasquid/graal-test). If you are interested in watching a video, I really liked [this one](https://www.youtube.com/watch?v=TQMKPRc6cbE). There are also some really nice examples of running in polyglot mode with R and Java and JS here [https://github.com/graalvm/examples](https://github.com/graalvm/examples).





