---
layout: post
title: "Focus On the Generator"
date: 2019-09-06 18:07
comments: true
categories:
- All
- Clojure
- Deep Learning
- MXNet
---

<a data-flickr-embed="true"  href="https://www.flickr.com/photos/smigla-bobinski/19705409981/in/album-72157647756733695/" title="SIMULACRA by Karina Smigla-Bobinski"><img src="https://live.staticflickr.com/330/19705409981_4e0ae93572.jpg" width="500" height="267" alt="SIMULACRA by Karina Smigla-Bobinski"></a><script async src="//embedr.flickr.com/assets/client-code.js" charset="utf-8"></script>

In this first post of this series, we took a look at a [simple autoencoder](https://gigasquidsoftware.com/blog/2019/08/16/simple-autoencoder/). It took and image and transformed it back to an image. Then, we [focused in on the disciminator](https://gigasquidsoftware.com/blog/2019/08/30/focus-on-the-discriminator/) portion of the model, where we took an image and transformed it to a label. Now, we focus in on the generator portion of the model do the inverse operation: we transform a label to an image. In recap:

* Autoencoder: image -> image
* Discriminator: image -> label
* Generator: label -> image (This is what we are doing now!)

![generator](https://live.staticflickr.com/65535/48689260086_11fe4b089b_b.jpg)

## Still Need Data of Course

Nothing changes here. We are still using the MNIST handwritten digit set and have an input and out to our model.

```clojure
(def
  train-data
  (mx-io/mnist-iter {:image (str data-dir "train-images-idx3-ubyte")
                     :label (str data-dir "train-labels-idx1-ubyte")
                     :input-shape [784]
                     :flat true
                     :batch-size batch-size
                     :shuffle true}))

(def
  test-data (mx-io/mnist-iter
             {:image (str data-dir "t10k-images-idx3-ubyte")
              :label (str data-dir "t10k-labels-idx1-ubyte")
              :input-shape [784]
              :batch-size batch-size
              :flat true
              :shuffle true}))

(def input (sym/variable "input"))
(def output (sym/variable "input_"))
```

## The Generator Model

The model does change to one hot encode the label for the number. Other than that, it's pretty much the exact same second half of the autoencoder model.

```clojure
(defn get-symbol []
  (as-> input data
    (sym/one-hot "onehot" {:indices data :depth 10})
    ;; decode
    (sym/fully-connected "decode1" {:data data :num-hidden 50})
    (sym/activation "sigmoid3" {:data data :act-type "sigmoid"})

    ;; decode
    (sym/fully-connected "decode2" {:data data :num-hidden 100})
    (sym/activation "sigmoid4" {:data data :act-type "sigmoid"})

    ;;output
    (sym/fully-connected "result" {:data data :num-hidden 784})
    (sym/activation "sigmoid5" {:data data :act-type "sigmoid"})

    (sym/linear-regression-output {:data data :label output})))

(def data-desc
  (first
   (mx-io/provide-data-desc train-data)))
(def label-desc
  (first
   (mx-io/provide-label-desc train-data)))
```

When binding the shapes to the model, we now need to specify that the input data shapes is the label instead of the image and the output of the model is going to be the image.

```clojure
(def
  model
  ;;; change data shapes to label shapes
  (-> (m/module (get-symbol) {:data-names ["input"] :label-names ["input_"]})
      (m/bind {:data-shapes [(assoc label-desc :name "input")]
               :label-shapes [(assoc data-desc :name "input_")]})
      (m/init-params {:initializer  (initializer/uniform 1)})
      (m/init-optimizer {:optimizer (optimizer/adam {:learning-rage 0.001})})))

(def my-metric (eval-metric/mse))
```

## Training

The training of the model is pretty straight forward. Just being mindful that we are using hte batch-label, (number label),  as the input and and validating with the batch-data, (image).

```clojure
(defn train [num-epochs]
  (doseq [epoch-num (range 0 num-epochs)]
    (println "starting epoch " epoch-num)
    (mx-io/do-batches
     train-data
     (fn [batch]
       ;;; change input to be the label
       (-> model
           (m/forward {:data (mx-io/batch-label batch)
                       :label (mx-io/batch-data batch)})
           (m/update-metric my-metric (mx-io/batch-data batch))
           (m/backward)
           (m/update))))
    (println "result for epoch " epoch-num " is "
             (eval-metric/get-and-reset my-metric))))
```


## Results Before Training

```clojure
(def my-test-batch (mx-io/next test-data))
  ;;; change to input labels
  (def test-labels (mx-io/batch-label my-test-batch))
  (def preds (m/predict-batch model {:data test-labels} ))
  (viz/im-sav {:title "before-training-preds"
               :output-path "results/"
               :x (ndarray/reshape (first preds) [100 1 28 28])})

  (->> test-labels first ndarray/->vec (take 10))
  ;=> (6.0 1.0 0.0 0.0 3.0 1.0 4.0 8.0 0.0 9.0)
```

![before training](http://live.staticflickr.com/65535/48689304281_a41bf39353.jpg)

Not very impressive... Let's train


```clojure
(train 3)

starting epoch  0
result for epoch  0  is  
[mse 0.0723091]
starting epoch  1
result for epoch  1  is  [mse 0.053891845]
starting epoch  2
result for epoch  2  is  [mse 0.05337505]
```

## Results After Training


```clojure
 (def my-test-batch (mx-io/next test-data))
  (def test-labels (mx-io/batch-label my-test-batch))
  (def preds (m/predict-batch model {:data test-labels}))
  (viz/im-sav {:title "after-training-preds"
               :output-path "results/"
               :x (ndarray/reshape (first preds) [100 1 28 28])})
  (->> test-labels first ndarray/->vec (take 10))

  ;=>   (9.0 5.0 7.0 1.0 8.0 6.0 6.0 0.0 8.0 1.0)
```

![after training](https://live.staticflickr.com/65535/48689328481_338416ba7c.jpg)

Cool! The first row is indeed

`(9.0 5.0 7.0 1.0 8.0 6.0 6.0 0.0 8.0 1.0)`

## Save Your Model

Don't forget to save the generator model off - we are going to use it next time.

```clojure
(m/save-checkpoint model {:prefix "model/generator" :epoch 2})
```

Happy Deep Learning until next time ...
