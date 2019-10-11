---
layout: post
title: "Integrating Deep Learning with clojure.spec"
date: 2019-10-11 13:51
comments: true
categories: 
- All
- Clojure
- Deep Learning
- MXNet
---

clojure.spec allows you to write specifications for data and use them for validation. It also provides a generative aspect that allows for robust testing as well as an additional way to understand your data through manual inspection. The dual nature of validation and generation is a natural fit for deep learning models that consist of paired discriminator/generator models.

<br>

**__TLDR: In this post we show that you can leverage the dual nature of clojure.spec's validator/generator to incorporate a deep learning model's classifier/generator.__**

<br>

A common use of clojure.spec is at the boundaries to validate that incoming data is indeed in the expected form. Again, this is boundary is a fitting place to integrate models for the deep learning paradigm and our traditional software code.

Before we get into the deep learning side of things, let's take a quick refresher on how to use clojure.spec.

## quick view of clojure.spec

To create a simple spec for keywords that are cat sounds, we can use `s/def`.

```clojure
(s/def ::cat-sounds #{:meow :purr :hiss})
```

To do the validation, you can use the `s/valid?` function.

```clojure
(s/valid? ::cat-sounds :meow) ;=> true
(s/valid? ::cat-sounds :bark) ;=> false
```

For the generation side of things, we can turn the spec into generator and sample it.

```clojure
(gen/sample (s/gen ::cat-sounds))
;=>(:hiss :hiss :hiss :meow :meow :purr :hiss :meow :meow :meow)
```

There is the ability to compose specs by adding them together with `s/and`.

```clojure
(s/def ::even-number (s/and int? even?))
(gen/sample (s/gen ::even-number))
;=> (0 0 -2 2 0 10 -4 8 6 8)
```

We can also control the generation by creating a custom generator using `s/with-gen`.
In the following the spec is only that the data be a general string, but using the custom generator, we can restrict the output to only be a certain set of example cat names.

```clojure
(s/def ::cat-name
  (s/with-gen
    string?
    #(s/gen #{"Suki" "Bill" "Patches" "Sunshine"})))

(s/valid? ::cat-name "Peaches") ;=> true
(gen/sample (s/gen ::cat-name))
;; ("Patches" "Sunshine" "Sunshine" "Suki" "Suki" "Sunshine"
;;  "Suki" "Patches" "Sunshine" "Suki")
```

For further information on clojure.spec, I whole-heartedly recommend the [spec Guide](https://clojure.org/guides/spec). But, now with a basic overview of spec, we can move on to creating specs for our Deep Learning models.

## Creating specs for Deep Learning Models

In previous posts, we covered making [simple autoencoders for handwritten digits](https://gigasquidsoftware.com/blog/2019/08/16/simple-autoencoder/).

![handwritten digits](http://live.staticflickr.com/65535/48647524478_ca35bef78f_n.jpg)

Then, we made models that would:

* Take an image of a digit and give you back the string value (ex: "2") - [post](https://gigasquidsoftware.com/blog/2019/08/30/focus-on-the-discriminator/)
* Take a string number value and give you back a digit image. - [post](https://gigasquidsoftware.com/blog/2019/09/06/focus-on-the-generator/)

We will use both of the models to make a spec with a custom generator.

<br>

_Note: For the sake of simplicity, some of the supporting code is left out. But if you want to see the whole code, it is on [github]((https://github.com/gigasquid/clojure-mxnet-autoencoder/blob/master/src/clojure_mxnet_autoencoder/model_specs.clj))_

<br>

With the help of the trained discriminator model, we can make a function that takes in an image and returns the number string value.

```clojure
(defn discriminate [image]
  (-> (m/forward discriminator-model {:data [image]})
      (m/outputs)
      (ffirst)
      (ndarray/argmax-channel)
      (ndarray/->vec)
      (first)
      (int)))
```

Let's test it out with a test-image:

![test-discriminator-image](http://live.staticflickr.com/65535/48881532151_251e30840e_s.jpg)

```clojure
(discriminate my-test-image) ;=> 6
```


Likewise, with the trained generator model, we can make a function that takes a string number and returns the corresponding image.

```clojure
(defn generate [label]
  (-> (m/forward generator-model {:data [(ndarray/array [label] [batch-size])]})
      (m/outputs)
      (ffirst)))
```

Giving it a test drive as well:

```clojure
(def generated-test-image (generate 3))
(viz/im-sav {:title "generated-image"
             :output-path "results/"
			 :x (ndarray/reshape generated-test-image [batch-size 1 28 28])})
```

![generated-test-image](http://live.staticflickr.com/65535/48881532451_023de68ddb_s.jpg)


Great! Let's go ahead and start writing specs. First let's make a quick spec to describe a MNIST number - which is a single digit between 0 and 9.

```clojure
(s/def ::mnist-number (s/and int? #(<= 0 % 9)))
(s/valid? ::mnist-number 3) ;=> true
(s/valid? ::mnist-number 11) ;=> false
(gen/sample (s/gen ::mnist-number))
;=> (0 1 0 3 5 3 7 5 0 1)
```


We now have both parts to validate and generate and can create a spec for it.

```clojure
(s/def ::mnist-image
    (s/with-gen
      #(s/valid? ::mnist-number (discriminate %))
      #(gen/fmap (fn [n]
                   (do (ndarray/copy (generate n))))
                 (s/gen ::mnist-number))))
```

The `::mnist-number` spec is used for the validation after the `discriminate` model is used. On the generator side, we use the generator for the `::mnist-number` spec and feed that into the deep learning generator model to get sample images.

We have a test function that will help us test out this new spec, called `test-model-spec`. It will return a map with the following form:

```
{:spec name-of-the-spec
 :valid? whether or not the `s/valid?` called on the test value is true or not
 :sample-values This calls the discriminator model on the generated values
 }
```
It will also write an image of all the sample images to a file named `sample-spec-name`

Let's try it on our test image: 

![test-discriminator-image](http://live.staticflickr.com/65535/48881532151_251e30840e_s.jpg)


```clojure
(s/valid? ::mnist-image my-test-image) ;=> true


(test-model-spec ::mnist-image my-test-image)
;; {:spec "mnist-image"
;;  :valid? true
;;  :sample-values [0 0 0 1 3 1 0 2 7 3]}
```

![sample-mnist-image](http://live.staticflickr.com/65535/48882235262_1e0dd7b758_q.jpg)


Pretty cool!

Let's do some more specs. But first, our spec is going to be a bit repetitive, so we'll make a quick macro to make things easier.

```clojure
(defmacro def-model-spec [spec-key spec discriminate-fn generate-fn]
    `(s/def ~spec-key
       (s/with-gen
         #(s/valid? ~spec (~discriminate-fn %))
         #(gen/fmap (fn [n#]
                      (do (ndarray/copy (~generate-fn n#))))
                    (s/gen ~spec)))))
```


### More Specs - More Fun

This time let's define an even mnist image spec

```clojure
 (def-model-spec ::even-mnist-image
    (s/and ::mnist-number even?)
    discriminate
    generate)

  (test-model-spec ::even-mnist-image my-test-image)
  
  ;; {:spec "even-mnist-image"
  ;;  :valid? true
  ;;  :sample-values [0 0 2 0 8 2 2 2 0 0]}
```

![sample-even-mnist-image](http://live.staticflickr.com/65535/48882253157_02e45d3132_q.jpg)


And Odds

```clojure
  (def-model-spec ::odd-mnist-image
    (s/and ::mnist-number odd?)
    discriminate
    generate)

  (test-model-spec ::odd-mnist-image my-test-image)

  ;; {:spec "odd-mnist-image"
  ;;  :valid? false
  ;;  :sample-values [5 1 5 1 3 3 3 1 1 1]}
```
![sample-odd-mnist-image](http://live.staticflickr.com/65535/48881548138_c18850f806_q.jpg)


Finally, let's do Odds that are over 2!

```clojure
  (def-model-spec ::odd-over-2-mnist-image
    (s/and ::mnist-number odd? #(> % 2))
    discriminate
    generate)

  (test-model-spec ::odd-over-2-mnist-image my-test-image)

  ;; {:spec "odd-over-2-mnist-image"
  ;;  :valid? false
  ;;  :sample-values [3 3 3 5 3 5 7 7 7 3]}
```

![sample-odd-over-2-mnist-image](http://live.staticflickr.com/65535/48882089776_6f55416418_q.jpg)

## Conclusion

We have shown some of the potential of integrating deep learning models with Clojure. clojure.spec is a powerful tool and it can be leveraged in new and interesting ways for both deep learning and AI more generally.

I hope that more people are intrigued to experiment and take a further look into what we can do in this area.


