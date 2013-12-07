---
layout: post
title: "Neural Networks in Clojure with core.matrix"
date: 2013-12-02 19:28
comments: true
categories:
- All
- Clojure
- Machine Learning
---

After having spent some time recently looking at top-down AI, I
thought I would spend some time looking at bottom's up AI, machine
learning and neural networks.

I was pleasantly introduced to @mikea's core.matrix at Clojure Conj
this year and wanted to try making my own neural network using the
libray. The purpose of this blog is to share my learnings along the
way.

## What is a neural network?
A neural network is an approach to machine learning that involves
simulating, (in an idealized way), the way our brains work on a
biologal level.  There a three layers to neural network, the input
layer, the hidden layers, and the output layer.  Each layer consists
of neurons that have a value.  Each neuron in a layer is connected to
the neuron in the next layer by a connection strength. Inputs between
the value of 0 and 1 are "fed" through the input layer.  The values
are then "fed forward" to the hidden layer neurons though an algorithim that
relies on the input values and the connection strengths. The values
are finally "fed forward" in a similar fashion to the output layer.
The "learning" portion of the neural network comes from "training" the
network data.  The training data consists of a collection of
associated input values and target values. The training process at a
high level looks like this:

* Feed forward input values to get the output values
* How far off are the output values from the target values?
* Calculate the error values and adjust the strengths of the network
* Repeat until you think it has "learned" enough, that is when you
  feed the input values in the result of the output values are close
  enough to the target you are looking for

The beauty of this system is that the neural network, (given the right
configuration and the right training), can approximate any function -
just by exposing it to data.

## Start Small
I wanted to start with a very small network so that I could understand
the algorithims and actually do the maths for the tests along the way.
The network configuration I chose is one with 1 hidden layer.  The
input layer has 2 neurons, the hidden layer has 3 neurons and the
output layer has 2 neurons.

```clojure
;;Neurons
;;  Input Hidden  Output
;;  A     1       C
;;  B     2       D
;;        3


;; Connection Strengths
;; Input to Hidden => [[A1 A2 A3] [B1 B2 B3]]
;; Hidden to Output => [[1C 1D] [2C 2D] [3C 3D]]
```

In this example we have:

* Input Neurons: neuronA neuronB
* Hidden Neurons: neuron1 neuron2 neuron3
* Output Neurons: neuronC neuronD
* Connections between the Input and Hidden Layers
  ** neuronA-neuron1
  ** neuronA-neuron2
  ** neuronA-neuron3
  ** neuronB-neuron1
  ** neuronB-neuron2
  ** neuronB-neuron3
* Connections betwen the Hidden and Output Layers
  ** neuron1-nerounC
  ** neuron1-nerounD
  ** neuron2-nerounC
  ** neuron2-nerounD
  ** neuron3-nerounC
  ** neuron3-nerounD

To give us a concrete example to work with, let's actually assign all
our neurons and connection strengths to some real values.

```clojure
(def input-neurons [1 0])
(def input-hidden-strengths [ [0.12 0.2 0.13]
                              [0.01 0.02 0.03]])
(def hidden-neurons [0 0 0])
(def hidden-output-strengths [[0.15 0.16]
                              [0.02 0.03]
                              [0.01 0.02]])
```

## Feed Forward

Alright, we have values in the input neuron layer, let's feed them
forward through the network. The new value of neuron in the hidden
layer is the sum of all the inputs of it's connections multiplied by
the connection strength.  The neuron can also have it's own threshold,
(meaning you would subtact the threshold from the sum of inputs), but
to keep things a simple as possible in this example, the threshold is
0 - so we will ignore it.  The sum is then feed into an activation
function, that has an output in the range of -1 to 1.  The activation
function is the tanh function.  We will also need the derivative of
the tanh function a little later when we are calculating errors, so we
will define both here.

```clojure
(def activation-fn (fn [x] (Math/tanh x)))
(def dactivation-fn (fn [y] (- 1.0 (* y y))))

(defn layer-activation [inputs strengths]
  "forward propogate the input of a layer"
  (mapv activation-fn
      (mapv #(reduce + %)
       (* inputs (transpose strengths)))))
```

So now if we calculate the hidden neuron values from the input [1 0],
we get:

```clojure
(layer-activation input-neurons input-hidden-strengths)
;=>  [0.11942729853438588 0.197375320224904 0.12927258360605834]
```

Let's just remember those hidden neuron values for our next step

```clojure
(def new-hidden-neurons
  [0.11942729853438588 0.197375320224904 0.12927258360605834])
```
