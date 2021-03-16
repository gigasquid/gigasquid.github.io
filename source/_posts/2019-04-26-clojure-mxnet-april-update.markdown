---
layout: post
title: "Clojure MXNet April Update"
date: 2019-04-26 15:51
comments: true
categories: 
- Clojure
- MXNet
- All
- Deep Learning
---

Spring is bringing some beautiful new things to the  [Clojure MXNet](http://mxnet.incubator.apache.org/). Here are some highlights for the month of April.


## Shipped

We've merged [10 PRs](https://github.com/apache/incubator-mxnet/pulls?utf8=%E2%9C%93&q=is%3Apr+is%3Aclosed+clojure) over the last month. Many of them focus on core improvements to documentation and usability which is very important.

The MXNet project is also preparing a new release `1.4.1`, so keep on the lookout for that to hit in the near future.

## Clojure MXNet Made Simple Article Series

[Arthur Caillau](https://arthurcaillau.com/about/) added another post to his fantastic series - [MXNet made simple: Pretrained Models for image classification - Inception and VGG](https://arthurcaillau.com/mxnet-made-simple-pretrained-models/)


## Cool Stuff in Development

### New APIs

Great progress was made on the [new version of the API for the Clojure NDArray and Symbol APIs](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=103092678) by [Kedar Bellare](https://github.com/kedarbellare). We now have an experimental new version of the apis that are generated more directly from the C code so that we can have more control over the output.

For example the new version of the generated api for NDArray looks like:

```clojure
(defn
 activation
 "Applies an activation function element-wise to the input.
  
  The following activation functions are supported:
  
  - `relu`: Rectified Linear Unit, :math:`y = max(x, 0)`
  - `sigmoid`: :math:`y = \\frac{1}{1 + exp(-x)}`
  - `tanh`: Hyperbolic tangent, :math:`y = \\frac{exp(x) - exp(-x)}{exp(x) + exp(-x)}`
  - `softrelu`: Soft ReLU, or SoftPlus, :math:`y = log(1 + exp(x))`
  - `softsign`: :math:`y = \\frac{x}{1 + abs(x)}`
  
  
  
  Defined in src/operator/nn/activation.cc:L167
  
  `data`: The input array.
  `act-type`: Activation function to be applied.
  `out`: Output array. (optional)"
 ([data act-type] (activation {:data data, :act-type act-type}))
 ([{:keys [data act-type out], :or {out nil}, :as opts}]
  (util/coerce-return
   (NDArrayAPI/Activation data act-type (util/->option out)))))
```

as opposed to:

```clojure
(defn
 activation
 ([& nd-array-and-params]
  (util/coerce-return
   (NDArray/Activation
    (util/coerce-param
     nd-array-and-params
     #{"scala.collection.Seq"})))))
```

So much nicer!!!

### BERT (State of the Art for NLP)

We also have some really exciting examples for BERT in a [PR](https://github.com/apache/incubator-mxnet/pull/14769) that will be merged soon. If you are not familiar with BERT, this [blog post](http://jalammar.github.io/illustrated-bert/) is a good overview. Basically, it's the state of the art in NLP right now. With the help of exported models from [GluonNLP](https://github.com/dmlc/gluon-nlp), we can do both inference and fine tuning of BERT models in MXNet with Clojure! This is an excellent example of cross fertilization across the GluonNLP, Scala, and Clojure MXNet projects.

There are two examples.

1) BERT question and answer inference based off of a fine tuned model of the [SQuAD Dataset](https://rajpurkar.github.io/SQuAD-explorer/) in GluonNLP which is then exported. It allows one to actually do some natural language question and answering like:

```
Question Answer Data
{:input-answer
 "Rich Hickey is the creator of the Clojure language. Before Clojure, he developed dotLisp, a similar project based on the .NET platform, and three earlier attempts to provide interoperability between Lisp and Java: a Java foreign language interface for Common Lisp, A Foreign Object Interface for Lisp, and a Lisp-friendly interface to Java Servlets.",
 :input-question "Who created Clojure?",
 :ground-truth-answers ["rich" "hickey"]}

  Predicted Answer:  [rich hickey]
```

2) The second example is using the exported BERT base model and then fine tuning it in Clojure to do a task with sentence pair classification to see if two sentences are equivalent or not. 

The nice thing about this is that we were able to convert the existing [tutorial in GluonNLP](https://gluon-nlp.mxnet.io/examples/sentence_embedding/bert.html) over to a Clojure Jupyter notebook with the `lein-jupyter` plugin. I didn't realize that there is a nifty `save-as` command in Jupyter that can generate a markdown file, which makes for very handy documentation. Take a peek at the tutorial [here](https://github.com/apache/incubator-mxnet/blob/d062d46f1c351dc9b70a038511b564dab5c43266/contrib/clojure-package/examples/bert/fine-tune-bert.md). It might make its way into a blog post on its own in the next week or two.


## Upcoming Events

- I'll be speaking about Clojure MXNet at the next [Scicloj Event](https://twitter.com/scicloj) on May 15th at 10PM UTC. Please join us and get involved in making Clojure a great place for Data Science.

- I'm also really excited to attend [ICLR](https://iclr.cc/) in a couple weeks. It is a _huge conference_ that I'm sure will melt my mind with the latest research in Deep Learning. If anyone else is planning to attend, please say hi :)

## Get Involved

As always, we welcome involvement in the true Apache tradition. If you have questions or want to say hi, head on over the the closest #mxnet room on your preferred server. We are on Clojurian's slack and Zulip


## Cat Picture of the Month

To close out, let's take a lesson from my cats and don't forget the importance of naps.

{%img https://live.staticflickr.com/65535/47707608431_5c5d0c73f8_c.jpg %}

Have a great rest of April!
