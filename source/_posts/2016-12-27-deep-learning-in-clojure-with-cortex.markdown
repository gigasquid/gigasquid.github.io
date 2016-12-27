---
layout: post
title: "Deep Learning in Clojure with Cortex"
date: 2016-12-27 10:44
comments: true
categories:
- All
- Clojure
- Machine Learning
- AI
---

There is an awesome new _Clojure-first_ machine learning library called [Cortex](https://github.com/thinktopic/cortex) that was open sourced recently. I've been exploring it lately and wanted to share my discoveries so far in this post. In our exploration, we are going to tackle one of the classic classification problems of the internet. How do you tell the difference between a cat and dog pic?

## Where to Start?

{% img http://kaggle2.blob.core.windows.net/competitions/kaggle/3362/media/woof_meow.jpg %}

For any machine learning problem, we're going to need data. For this, we can use Kaggle's data for the [Cats vs Dogs Challenge](https://www.kaggle.com/c/dogs-vs-cats-redux-kernels-edition/data).  The training data consists of 25,000 images of cats and dogs. That should be more than enough to train our computer to recognize cats from doggies.

We also need some idea of how to train against the data. Luckily, the Cortex project has a very nice set of examples to help you get started. In particular there is a [suite classification example](https://github.com/thinktopic/cortex/tree/master/examples/suite-classification) using MNIST, (hand written digit), corpus. This example contains a number cutting edge features that we'll want to use:

* Uses GPU for _fast_ computation.
* Uses a deep, multi-layered, convolutional layered network for feature recognition.
* Has "forever" training by image augmentation.
* Saves the network configuration as it trains to an external nippy file so that it can be imported later.
* Has a really nice ClojureScript front end to visualize the training progress with a confusion matrix.
* Has a way to import the saved nippy network configuration and perform inference on it to classify a new image.

Basically, it has everything we need to hit the ground running.

## Data Wrangling

To use the example's _forever_ training, we need to get the data in the right form. We need all the images to be the same size as well as in a directory structure that is split up into the training and test images. Furthermore, we want all the dog images to be under a "dog" directory and the cat images under the "cat" directory so that the all the indexed images under them have the correct "label".  It will look like this:

```
- training
  - cat
    - 1.png
    - 2.png
  - dog
    - 1.png
    - 2.png
```

For this task, we are going to use a couple image libraries to help us out:

```clojure
 [mikera.image.core :as imagez]
 [think.image.image :as image]
```

We can resize and rewrite the original images into the form we want. For a image size, we're going to go with 52x52. The choice is arbitrary in that I wanted it bigger than the MNIST dataset which is 28x28 so it will be easier to see, but not so big that it kills my CPU. This is even more important since we want to use RGB colors which is 3 channels as opposed to the MNIST grey scale of 1.

```clojure
(def dataset-image-size 52)
(def dataset-num-classes 2)
(def dataset-num-channels 3)
(def dataset-datatype :float)

(defn resize-and-write-data
  [output-dir [idx [file label]]]
  (let [img-path (str output-dir "/" label "/" idx ".png" )]
    (when-not (.exists (io/file img-path))
      (io/make-parents img-path)
      (-> (imagez/load-image file)
          (image/resize dataset-image-size dataset-image-size)
          (imagez/save img-path)))
    nil))
```

As far as the split between training images and testing images, we are going the go for an simple even split between testing and training data.

## Network Configuration

The Network layer configuration is the meat of the whole thing. We are going to go with the exact same network description as the MNIST example:

```clojure
(defn create-basic-network-description
  []
  [(desc/input dataset-image-size dataset-image-size dataset-num-channels)
   (desc/convolutional 5 0 1 20)
   (desc/max-pooling 2 0 2)
   (desc/relu)
   (desc/convolutional 5 0 1 50)
   (desc/max-pooling 2 0 2)
   (desc/relu)
   (desc/convolutional 1 0 1 50)
   (desc/relu)
   (desc/linear->relu 1000)
   (desc/dropout 0.5)
   (desc/linear->softmax dataset-num-classes)])
```

It uses a series of convolutional layers with max pooling for feature recognition. We'll see if it works for color versions of cats and dogs as well as street numbers.

We'll also keep the image augmentation the same as in the example.

```clojure
(def max-image-rotation-degrees 25)

(defn img-aug-pipeline
  [img]
  (-> img
      (image-aug/rotate (- (rand-int (* 2 max-image-rotation-degrees))
                           max-image-rotation-degrees)
                        false)
      (image-aug/inject-noise (* 0.25 (rand)))))

(def ^:dynamic *num-augmented-images-per-file* 1)
```

It injects one augmented image into our training data by slightly rotating it and adding noise.

### Running it!

It's time to test it out. Using `lein run`, we'll launch the `train-forever` function:

```clojure
(defn train-forever
  []
  (let [dataset (create-dataset)
        initial-description (create-basic-network-description)
        confusion-matrix-atom (display-dataset-and-model dataset initial-description)]
    (classification/train-forever dataset observation->image
                                  initial-description
                                  :confusion-matrix-atom confusion-matrix-atom)))
```

This opens a port to a localhost webpage where we can view the progress `http://localhost:8091/`

{% img http://c3.staticflickr.com/1/599/31877481106_ab49402b71_b.jpg %}

Below the confusion matrix is shown. This tracks the progress of the training in the classification. In particular, how many times it thought a cat was really a cat and how many times it got it wrong.

{% img http://c7.staticflickr.com/1/371/31541533750_69d80cc7fa.jpg %}

As we are training the data, the loss for each epoch is shown on the console as well as when it saves the network to the external file.

After only thirty minutes of training on my Mac Book Pro, we get to some pretty good results, with the correct percentage in the 99s :

{% img http://c1.staticflickr.com/1/707/31541538600_8e61134375.jpg %}

It's time to do some inference on our trained network.

## Inference

Firing up a REPL we can connect to our namespace and use the `label-one` function from the cortex example to spot check our classification. It reads in the external nippy file that contains the trained network description, takes a random image from the testing directory, and classifies it.

```clojure
(defn label-one
  "Take an arbitrary image and label it."
  []
  (let [file-label-pairs (shuffle (classification/directory->file-label-seq testing-dir
                                                                            false))
        [test-file test-label] (first file-label-pairs)
        test-img (imagez/load-image test-file)
        observation (png->observation dataset-datatype false test-img)]
    (imagez/show test-img)
    (infer/classify-one-observation (:network-description
                                     (suite-io/read-nippy-file "trained-network.nippy"))
                                    observation
                                    (ds/create-image-shape dataset-num-channels
                                                           dataset-image-size
                                                           dataset-image-size)
                                    dataset-datatype
                                    (classification/get-class-names-from-directory testing-dir))))
```

Running `(label-one)` gives us the picture:

{% img http://c2.staticflickr.com/1/423/31105658073_b6143b2f00.jpg %}

and classifies it as a cat. Yipee!

```clojure
{:probability-map {"cat" 0.9995587468147278, "dog" 4.4119369704276323E-4}, :classification "cat"}
```

Not bad, but let's try it with something harder. Personally, I'm not even sure whether this is a cat or a dog.

{% img http://c6.staticflickr.com/1/596/31105666133_223dc2f04e_c.jpg %}


Feeding it through the program - it says it is a cat.

```clojure
 {:probability-map {"cat" 0.9942012429237366, "dog" 0.005798777565360069}, :classification "cat"}
```

After much [debate on the internet](http://www.today.com/pets/cat-or-dog-wild-eyed-cutie-has-us-all-confused-t104835), I think that is the best answer the humans got too :)


## Kaggle it

So it seems like we have a pretty good model, why don't we submit our results to the Kaggle competition and see how it rates. All they need is to have us run the classification against their test data of 12,500 images and classify them as 1 = dog or 0 = cat in a csv format.

We will take each image and resize it, then feed it into cortex's `infer-n-observations` function, to do all our classification as a batch.

```clojure
 (infer/infer-n-observations (:network-description
                                             (suite-io/read-nippy-file "trained-network.nippy"))
                                            observations
                                            (ds/create-image-shape dataset-num-channels
                                                                   dataset-image-size
                                                                   dataset-image-size)
                                            dataset-datatype)
```

Finally, we just need to format our results to a csv file and export it:

```clojure
(defn write-kaggle-results [results]
  (with-open [out-file (io/writer "kaggle-results.csv")]
    (csv/write-csv out-file
                   (into [["id" "label"]]
                         (-> (mapv (fn [[id class]] [(Integer/parseInt id) (if (= "dog" class) 1 0)]) results)
                             (sort))))))
```

After uploading the file to the Kaggle, I was pleased that the answer got in the top 91%! It made it on the [Leaderboard](https://www.kaggle.com/c/dogs-vs-cats-redux-kernels-edition/leaderboard).


## Conclusion

Using an example setup from the Cortex project and 30 minutes of processing time on my laptop, we were able to crunch through some significant data and come up with a trained classification model that was good enough to make the charts in the Kaggle competition. On top of it all, it is in pure Clojure.

In my mind, this is truely impressive and even though the Cortex library is in it's early phases, it puts it on track to be as useful a tool as Tensor Flow for Machine Learning.

Earlier this month, I watched an ACM Learning webcast with Peter Norvig speaking on AI. In it, he spoke of one of the next challenges of AI which is to combine [symbolic with neural](https://twitter.com/gigasquid/status/806916856040689664?lang=en). I can think of no better language than Clojure with it's simplicity, power, and rich LISP heritage to take on the challenge for the future. With the Cortex library, it's off to a great start.

_If want to see all the cats vs dog  Kaggle Code, it's out on github here [https://github.com/gigasquid/kaggle-cats-dogs](https://github.com/gigasquid/kaggle-cats-dogs)_ 




