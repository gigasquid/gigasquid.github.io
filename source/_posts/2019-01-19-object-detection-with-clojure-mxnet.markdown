---
layout: post
title: "Object Detection with Clojure MXNet"
date: 2019-01-19 13:34
comments: true
categories:
- All
- Clojure
- Deep Learning
- MXNet
---

![](https://c1.staticflickr.com/8/7837/32928474208_4960caafb3.jpg)

Object detection just landed in MXNet thanks to the work of contributors [Kedar Bellare](https://github.com/kedarbellare) and [Nicolas Modrzyk](https://github.com/hellonico/). Kedar ported over the `infer` package to Clojure, making inference and prediction much easier for users and Nicolas integrated in his [Origami](https://github.com/hellonico/origami) OpenCV library into the the examples to make the visualizations happen.

We'll walk through the main steps to use the `infer` object detection which include creating the detector with a model and then loading the image and running the inference on it.


### Creating the Detector

To create the detector you need to define a couple of things:

* How big is your image?
* What model are you going to be using for object detection?

In the code below, we are going to be giving it an color image of size 512 x 512.

```clojure
(defn create-detector []
  (let [descriptors [{:name "data"
                      :shape [1 3 512 512]
                      :layout layout/NCHW
                      :dtype dtype/FLOAT32}]
        factory (infer/model-factory model-path-prefix descriptors)]
    (infer/create-object-detector factory)))
```

 * The shape is going to be `[1 3 512 513]`. 
    * The `1` is for the batch size which in our case is a single image.
    * The `3` is for the channels in the image which for a RGB image is `3`
    * The `512` is for the image height and width.
 * The `layout` specifies that the shape given is in terms of `NCHW` which is batch size, channel size, height, and width.
 * The `dtype` is the image data type which will be the standard `FLOAT32`
 * The `model-path-prefix` points to the place where the trained model we are using for object detection lives. 

The model we are going to use is the [Single Shot Multiple Box Object Detector (SSD)](https://arxiv.org/abs/1512.02325). You can download the model yourself using this [script](https://github.com/apache/incubator-mxnet/blob/master/contrib/clojure-package/examples/infer/objectdetector/scripts/get_ssd_data.sh).

### How to Load an Image and Run the Detector

Now that we have a model and a detector, we can load an image up and run the object detection.

To load the image use `load-image` which will load the image from the path.

```clojure
(infer/load-image-from-file input-image)
```

Then run the detection using `infer/detect-objects` which will give you the top five predictions by default.

```clojure
(infer/detect-objects detector image)
```

It will give an output something like this:

```clojure
[[{:class "person",
   :prob 0.9657765,
   :x-min 0.021868259,
   :y-min 0.049295247,
   :x-max 0.9975169,
   :y-max 0.9734151}
  {:class "dog",
   :prob 0.17513266,
   :x-min 0.16772352,
   :y-min 0.45792937,
   :x-max 0.55409217,
   :y-max 0.72507095}
   ...
]]
```

which you can then use to draw bounding boxes on the image.

### Try Running the Example

![](https://c1.staticflickr.com/8/7804/31862638207_61be3a6e3c_b.jpg)

One of the best ways to explore using it is with the [object detection example](https://github.com/apache/incubator-mxnet/tree/master/contrib/clojure-package/examples/infer/objectdetector) in the MXNet repo. It will be coming out officially in the `1.5.0` release, but you can get an early peek at it by building the project and running the example with the nightly snapshot.

You can do this by cloning the [MXNet Repo](https://github.com/apache/incubator-mxnet) and changing directory to `contrib/clojure-package`.

Next, edit the `project.clj` to look like this:

```clojure
(defproject org.apache.mxnet.contrib.clojure/clojure-mxnet "1.5.0-SNAPSHOT"
  :description "Clojure package for MXNet"
  :url "https://github.com/apache/incubator-mxnet"
  :license {:name "Apache License"
            :url "http://www.apache.org/licenses/LICENSE-2.0"}
  :dependencies [[org.clojure/clojure "1.9.0"]
                 [t6/from-scala "0.3.0"]

                 ;; To use with nightly snapshot
                 ;[org.apache.mxnet/mxnet-full_2.11-osx-x86_64-cpu "<insert-snapshot-version>"]
                 ;[org.apache.mxnet/mxnet-full_2.11-linux-x86_64-cpu "<insert-snapshot-version>"]
                 ;[org.apache.mxnet/mxnet-full_2.11-linux-x86_64-gpu "<insert-snapshot-version"]

                 [org.apache.mxnet/mxnet-full_2.11-osx-x86_64-cpu "1.5.0-SNAPSHOT"]

                 ;;; CI
                 #_[org.apache.mxnet/mxnet-full_2.11 "INTERNAL"]

                 [org.clojure/tools.logging "0.4.0"]
                 [org.apache.logging.log4j/log4j-core "2.8.1"]
                 [org.apache.logging.log4j/log4j-api "2.8.1"]
                 [org.slf4j/slf4j-log4j12 "1.7.25" :exclusions [org.slf4j/slf4j-api]]]
  :pedantic? :skip
  :plugins [[lein-codox "0.10.3" :exclusions [org.clojure/clojure]]
            [lein-cloverage "1.0.10" :exclusions [org.clojure/clojure]]
            [lein-cljfmt "0.5.7"]]
  :codox {:namespaces [#"^org\.apache\.clojure-mxnet\.(?!gen).*"]}
  :aot [dev.generator]
  :repositories [["staging" {:url "https://repository.apache.org/content/repositories/staging"                  :snapshots true
                             :update :always}]
                 ["snapshots" {:url "https://repository.apache.org/content/repositories/snapshots"               :snapshots true
                              :update :always}]])
```
If you are running on linux, you should change the `mxnet-full_2.11-osx-x86_64-cpu` to `mxnet-full_2.11-linux-x86_64-cpu`.


Next, go ahead and do `lein test` to make sure that everything builds ok. If you run into any trouble please refer to [README](https://github.com/apache/incubator-mxnet/blob/master/contrib/clojure-package/README.md) for any missing dependencies.

After that do a `lein install` to install the `clojure-mxnet` jar to your local maven. Now you are ready to `cd examples/infer/object-detection` to try it out. Refer to the README for more details.

If you run into any problems getting started, feel free to reach out in the Clojarian #mxnet slack room or open an issue at the MXNet project. We are a friendly group and happy to help out.

Thanks again to the community for the contributions to make this possible. It's great seeing new things coming to life.

Happy Object Detecting!
