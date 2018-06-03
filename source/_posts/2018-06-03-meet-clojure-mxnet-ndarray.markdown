---
layout: post
title: "Meet Clojure MXNet - NDArray"
date: 2018-06-03 16:13
comments: true
categories:
- All
- Clojure
- Deep Learning
---

{% img https://cdn-images-1.medium.com/max/800/1*OoqsrMD7JzXAvRUGx_8_fg.jpeg %}

This is the beginning of a series of blog posts to get to know the [Apache MXNet](https://mxnet.apache.org/) Deep Learning project and the new Clojure library [clojure-mxnet](https://github.com/gigasquid/clojure-mxnet).

MXNet is a first class, modern deep learning library that AWS has officially picked as its chosen library. It supports multiple languages on a first class basis and is incubating as an Apache project.

The motivation for creating a Clojure package is to be able to open the deep learning library to the Clojure ecosystem and build bridges for future development and innovation for the community. It provides all the needed tools including low level and high level apis, dynamic graphs, and things like GAN and natural language support.

So let's get on with our introduction with one of the basic building blocks of MXNet, the `NDArray`.

## Meet NDArray

The `NDArray` is the tensor data structure in MXNet. Let's start of by creating one. First we need to require the `ndarray` namespace:

```clojure
(ns tutorial.ndarray
  (:require [org.apache.clojure-mxnet.ndarray :as ndarray]))
```

Now let's create an all zero array of dimension 100 x 50

```clojure
(ndarray/zeros [100 50])
;=> #object[org.apache.mxnet.NDArray 0x3e396d0 "org.apache.mxnet.NDArray@aeea40b6"]
```

We can check the shape of this by using `shape-vec`

```clojure
(ndarray/shape-vec (ndarray/zeros [100 50]))
;=> [100 50]
```

There is also a quick way to create an ndarray of ones with the `ones` function:

```clojure
(ndarray/ones [256 32 128 1])
```

Ones and zeros are nice, but what an array with specific contents? There is an `array` function for that. Specific the contents of the array first and the shape second:

```clojure
(def c (ndarray/array [1 2 3 4 5 6] [2 3]))
(ndarray/shape-vec c)  ;=> [2 3]
```

To convert it back to a vector format, we can use the `->vec` function.

```clojure
(ndarray/->vec c)
;=> [1.0 2.0 3.0 4.0 5.0 6.0]
```

Now that we know how to create NDArrays, we can get to do something interesting like operations on them.

### Operations

There are all the standard arithmetic operations:

```clojure
(def a (ndarray/ones [1 5]))
(def b (ndarray/ones [1 5]))
(-> (ndarray/+ a b) (ndarray/->vec))
;=>  [2.0 2.0 2.0 2.0 2.0]
```

Note that the original ndarrays are unchanged.

```clojure
(ndarray/->vec a) ;=> [1.0 1.0 1.0 1.0 1.0]
(ndarray/->vec b) ;=> [1.0 1.0 1.0 1.0 1.0]
```

But, we can change that if we use the inplace operators:

```clojure
(ndarray/+= a b)
(ndarray/->vec a) ;=>  [2.0 2.0 2.0 2.0 2.0]
```

There are many more operations, but just to give you a taste, we'll take a look a the `dot` product operation:

```clojure
(def arr1 (ndarray/array [1 2] [1 2]))
(def arr2 (ndarray/array [3 4] [2 1]))
(def res (ndarray/dot arr1 arr2))
(ndarray/shape-vec res) ;=> [1 1]
(ndarray/->vec res) ;=> [11.0]
```

If you are curious about the other operators available in NDArray API check out the [MXNet project documentation page](https://mxnet.incubator.apache.org/api/python/ndarray/ndarray.html)

Now that we have ndarrays and can do calculations on them, we might want to save and load them.

### Saving and Loading

You can save ndarrays with a name as a map like:

```clojure
(ndarray/save "filename" {"arr1" arr1 "arr2" arr2})
```

To load them, you just specify the filename and the map is returned.

```clojure
(ndarray/load "filename")
;=> {"arr1" #object[org.apache.mxnet.NDArray 0x1b629ff4 "org.apache.mxnet.NDArray@63da08cb"]
;=>  "arr2" #object[org.apache.mxnet.NDArray 0x25d994e3 "org.apache.mxnet.NDArray@5bbaf2c3"]}
```

One more cool thing, we can even due our operations on the cpu or gpu.

### Multi-Device Support

When creating an `ndarray` you can use a context argument to specify the device. To do this, we will need the help of the `context` namespace.

```clojure
(require '[org.apache.clojure-mxnet.context :as context])
```

By default, the `ndarray` is created on the cpu context.

```clojure
(def cpu-a (ndarray/zeros [100 200]))
(ndarray/context cpu-a)
;=> #object[ml.dmlc.mxnet.Context 0x3f376123 "cpu(0)"]
```

But we can specify the gpu instead, (if we have a gpu enabled build).

```clojure
(def gpu-b (ndarray/zeros [100 200] {:ctx (context/gpu 0)}))
```

_Note: Operations among different contexts are currently not allowed, but there is a `copy-to` function that can help copy the content from one device to another and then continue on with the computation._


## Wrap up

I hope you've enjoyed the brief introduction to the MXNet library, there is much more to explore in future posts. If you are interested in giving it a try, there are native jars for OSX cpu and Linux cpu/gpu available and the code for the ndarray tutorial can be found [here](https://github.com/gigasquid/clojure-mxnet/blob/master/examples/tutorial/src/tutorial/ndarray.clj).

_Please remember that he library is in a very **alpha** state, so if you encounter any problems or have any other feedback, please log an issue so bugs and rough edges can be fixed :)._

