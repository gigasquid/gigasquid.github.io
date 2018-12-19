---
layout: post
title: "How to GAN a Flan"
date: 2018-12-18 16:34
comments: true
categories:
- All
- Clojure
- Deep Learning
- MXNet
---


It's holiday time and that means parties and getting together with friends. Bringing a baked good or dessert to a gathering is a time honored tradition. But what if this year, you could take it to the next level? Everyone brings actual food. But with the help of Deep Learning, you can bring something completely different -  you can bring the _image_ of baked good! I'm not talking about just any old image that someone captured with a camera or created with a pen and paper. I'm talking about the computer itself **creating**. This image would be never before seen, totally unique, and crafted by the creative process of the machine.


That is exactly what we are going to do. We are going to create a _flan_

{% img https://c1.staticflickr.com/5/4065/4339500429_aa9c55f246_n.jpg %}_Photo by Lucia Sanchez on Flickr_


If you've never had a flan before, it's a yummy dessert made of a baked custard with caramel sauce on it.

"Why a flan?", you may ask. There are quite a few reasons:

* It's tasty in real life.
* Flan rhymes with GAN, _(unless you pronounce it "Gaaahn")_.
* Why not?

Onto the recipe. How are we actually going to make this work? We need some ingredients:

* [Clojure](https://clojure.org/) - the most advanced programming language to create generative desserts.
* [Apache MXNet](https://mxnet.apache.org) - a flexible and efficient deep learning library that has a Clojure package.
* 1000-5000 pictures of flans - for Deep Learning you need data!


## Gather Flan Pictures

The first thing you want to do is gather your 1000 or more images with a [scraper](https://github.com/montoyamoraga/scrapers). The scraper will crawl google, bing, or instagram and download pictures of _mostly_ flans to your computer. You may have to eyeball and remove any clearly wrong ones from your stash.

Next, you need to gather all these images in a directory and run a tool called [im2rec.py](https://github.com/apache/incubator-mxnet/blob/master/tools/im2rec.py) on them to turn them into an [image record iterator](https://mxnet.incubator.apache.org/tutorials/basic/data.html#loading-data-using-image-iterators) for use with MXNet. This will produce an optimized format that will allow our deep learning program to efficiently cycle through them.

Run:

    python3 im2rec.py --resize 28 root flan

to produce a `flan.rec` file with images resized to 28x28 that we can use next.



## Load Flan Pictures into MXNet

The next step is to import the image record iterator into the MXNet with the [Clojure API](https://github.com/apache/incubator-mxnet/tree/master/contrib/clojure-package). We can do this with the `io` namespace.

Add this to your require:

    [org.apache.clojure-mxnet.io :as mx-io]

Now, we can load our images:

```clojure
(def flan-iter (mx-io/image-record-iter {:path-imgrec "flan.rec"
                                         :data-shape [3 28 28]
                                         :batch-size batch-size}))
```

Now, that we have the images, we need to create our `model`. This is what is actually going to do the learning and creating of images.

## Creating a GAN model.

GAN stands for _Generative Adversarial Network_. This is a incredibly cool deep learning technique that has two different models pitted against each, yet both learning and getting better at the same time. The two models are a generator and a discriminator. The generator model creates a new image from a random noise vector. The discriminator then tries to tell whether the image is a real image or a fake image. We need to create both of these models for our network.

First, the discriminator model. We are going to use the `symbol` namespace for the clojure package:

```clojure
(defn discriminator []
  (as-> (sym/variable "data") data
    (sym/convolution "d1" {:data data
                           :kernel [4 4]
                           :pad [3 3]
                           :stride [2 2]
                           :num-filter ndf
                           :no-bias true})
    (sym/batch-norm "dbn1" {:data data :fix-gamma true :eps eps})
    (sym/leaky-re-lu "dact1" {:data data :act-type "leaky" :slope 0.2})

	...

```

There is a variable for the `data` coming in, (which is the picture of the flan), it then flows through the other layers which consist of convolutions, normalization, and activation layers. The last three layers actually repeat another two times before ending in the output, which tells whether it thinks the image was a fake or not.


The generator model looks similar:

```clojure
(defn generator []
  (as-> (sym/variable "rand") data
    (sym/deconvolution "g1" {:data data
                             :kernel [4 4]
                             :pad [0 0]
                             :stride [1 1]
                             :num-filter
                             (* 4 ndf) :no-bias true})
    (sym/batch-norm "gbn1" {:data data :fix-gamma true :eps eps})
    (sym/activation "gact1" {:data data :act-type "relu"})
	
	...
	
```

There is a variable for the `data` coming in, but this time it is a random noise vector. Another interesting point that is is using a `deconvolution` layer instead of a `convolution` layer. The generator is basically the inverse of the discriminator. It starts with a random noise vector, but that is translated up through the layers until it is expanded to a image output.

Next, we iterate through all of our training images in our `flan-iter` with `reduce-batches`. Here is just an excerpt where we get a random noise vector and have the generator run the data through and produce the output image:

```clojure
(mx-io/reduce-batches
       flan-iter
       (fn [n batch]
         (let [rbatch (mx-io/next rand-noise-iter)
               dbatch (mapv normalize-rgb-ndarray (mx-io/batch-data batch))
               out-g (-> mod-g
                         (m/forward rbatch)
                         (m/outputs))
```

The whole code is [here](https://github.com/gigasquid/mxnet-gan-flan) for reference, but let's skip forward and run it and see what happens.

{% img ../images/gout-96-0.jpg %}

FLANS!! Well, they could be flans if you squint a bit.

Now that we have them kinda working for a small image size 28x28, let's biggerize it.


## Turn on the Oven and Bake

Turning up the size to 128x128 requires some alterations in the layers' parameters to make sure that it processes and generates the correct size, but other than that we are good to go.

Here comes the fun part, watching it train and learn:

### Epoch 0

{% img ../images/flan-random-128-0-0.jpg %}

In the beginning there was nothing but random noise.


### Epoch 10

{% img ../images/flan-random-128-10-0.jpg %}

It's beginning to learn colors! Red, yellow, brown seem to be important to flans.

### Epoch 23

{% img ../images/flan-random-128-23-0.jpg %}

It's learning shapes! It has learned that flans seem to be blob shaped.

### Epoch 33

{% img ../images/flan-random-128-33-0.jpg %}

It is moving into its surreal phase. Salvidor Dali would be proud of these flans.

### Epoch 45

{% img ../images/flan-random-128-45.jpg %}

Things take a weird turn. Does that flan have eyes?

### Epoch 68

{% img ../images/flan-random-128-68-0.jpg %}

Even worse. Are those demonic flans? Should we even continue down this path? 

Answer: Yes - **the training must go on..**

### Epoch 161

{% img ../images/flan-random-161-0.jpg %}

Big moment here. It looks like something that could possibly be edible.

### Epoch 170

{% img ../images/flan-random-170-0.jpg %}

Ick! Green Flans! No one is going to want that.


### Epoch 195

{% img ../images/explore-195.jpg %}

We've achieved maximum flan, (for the time being).


## Explore

If you are interested in playing around with the pretrained model, you can check it out [here with the pretrained function](https://github.com/gigasquid/mxnet-gan-flan/blob/master/src/mxnet_gan_flan/gan.clj#L355).
It will load up the trained model and generate flans for you to explore and bring to your dinner parties.

Wrapping up, training GANs is a _lot_ of fun. With MXNet, you can bring the fun with you to Clojure.

Want more, check out this Clojure Conj video -  [Can You GAN?](https://www.youtube.com/watch?v=yzfnlcHtwiY).









