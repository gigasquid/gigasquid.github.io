---
layout: post
title: "Clojure MXNet March Update"
date: 2019-03-22 10:42
comments: true
categories: 
- Clojure
- MXNet
- All
- Deep Learning
---

I'm starting a monthly update for [Clojure MXNet](http://mxnet.incubator.apache.org/). The goal is to share the progress and exciting things that are happening in the project and our community.

Here's some highlights for the month of March.

## Shipped

Under the shipped heading, the 1.4.0 release of MXNet has been released, along with the [Clojure MXNet Jars](https://search.maven.org/search?q=clojure%20mxnet). There have been improvements to the JVM memory management and an Image API addition. You can see the full list of changes [here](https://github.com/apache/incubator-mxnet/releases/tag/1.4.0#clojure)

## Clojure MXNet Made Simple Article Series
[Arthur Caillau](https://arthurcaillau.com/about/) authored a really nice series of blog posts to help get people started with Clojure MXNet.

* [Getting started with Clojure and MXNet on AWS](https://arthurcaillau.com/mxnet-clojure-aws/)
* [MXNet made simple: Clojure NDArray API](https://arthurcaillau.com/mxnet-made-simple-ndarrays-api/)
* [MXNet made simple: Clojure Symbol API](https://arthurcaillau.com/mxnet-made-simple-symbol-api/)
* [MXNet made simple: Clojure Module API](https://arthurcaillau.com/mxnet-made-simple-module-api/)
* [MXNet made simple: Clojure Symbol Visualization API](https://arthurcaillau.com/mxnet-made-simple-symbol-visualization/)
* [MXNet made simple: Image Manipulation with OpenCV and MXNet](https://arthurcaillau.com/mxnet-made-simple-image-manipulation/)


## Lein Template & Docker file

[Nicolas Modrzyk](https://github.com/hellonico/) created a Leiningen template that allows you to easily get a MXNet project started - with a notebook too! It's a great way to take Clojure MXNet for a spin

```
# create project
lein new clj-mxnet hello

# run included sample
lein run

# start notebook engine
lein notebook

# open notebook
http://0.0.0.0:10000/worksheet.html?filename=notes/practice.clj
# open empty notebook with all namespaces
http://0.0.0.0:10000/worksheet.html?filename=notes/empty.clj
```

There also is a docker file as well

```
docker run -it -p 10000:10000 hellonico/mxnet

After starting the container, you can open the same notebooks as above:

# open notebook
http://0.0.0.0:10000/worksheet.html?filename=notes/practice.clj
# open empty notebook with all namespaces
http://0.0.0.0:10000/worksheet.html?filename=notes/empty.clj
```

## Cool Stuff in Development

There are a few really interesting things cooking for the future.

One is a [PR for memory fixes](https://github.com/apache/incubator-mxnet/pull/14372) from the Scala team that is getting really close to merging. This will be a solution to some the the memory problems that were encountered by early adopters of the Module API.

Another, is the [new version of the API for the Clojure NDArray and Symbol APIs](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=103092678) that is being spearheaded by Kedar Bellare

Finally, work is being started to create a [Gluon API for the Clojure package](https://cwiki.apache.org/confluence/pages/viewpage.action?pageId=103089990) which is quite exciting.

## Get Involved

As always, we welcome involvement in the true Apache tradition. If you have questions or want to say hi, head on over the the closest #mxnet room on your preferred server. We are on Clojurian's slack and Zulip.

## Cat Picture of the Month

There is no better way to close out an update than a cat picture, so here is a picture of our family cat, Otto, watching birds at the window. 

{% img https://farm8.staticflickr.com/7862/46718997174_13bf6e88ea_z.jpg %}

Have a great rest of March!
