---
layout: post
title: "Breakfast with Zero-Shot NLP"
date: 2021-03-15 09:07
comments: true
categories:
- All
- AI
- Deep Learning
---

![](https://i.imgflip.com/51ror1.jpg)

What if I told you that you could pick up a library model and instantly classify text with arbitrary categories without any training or fine tuning?

That is exactly what we are going to do with [Hugging Face's zero-shot learning model](https://joeddav.github.io/blog/2020/05/29/ZSL.html). We will also be using [libpython-clj](https://github.com/clj-python/libpython-clj) to do this exploration without leaving the comfort of our trusty Clojure REPL.

### What's for breakfast?

We'll start off by taking some text from a recipe description and trying to decide if it's for breakfast, lunch or dinner:

`"French Toast with egg and bacon in the center with maple syrup on top. Sprinkle with powdered sugar if desired."`

Next we will need to install the required python deps:

`pip install numpy torch transformers lime`

Now we just need to set up the libpython clojure namespace to load the Hugging Face transformers library.

```clojure
(ns gigasquid.zeroshot
  (:require
   [libpython-clj2.python :as py :refer [py. py.. py.-]]
   [libpython-clj2.require :refer [require-python]]))


(require-python '[transformers :bind-ns])
```

Setup is complete. We are now ready to classify with zeroshot.

#### Classify with Zero Shot

To create the classifier with zero shot, you need only create it with a handy pipeline function.

```clojure
(def classifier (py. transformers "pipeline" "zero-shot-classification"))
```

After that you need just the text you want to classify and category labels you want to use.

```clojure
(def text "French Toast with egg and bacon in the center with maple syrup on top. Sprinkle with powdered sugar if desired.")

(def labels ["breakfast" "lunch" "dinner"])
```

Classification is only a function call away with:

```clojure
(classifier text labels)

{'labels': ['breakfast', 'lunch', 'dinner'],
 'scores': [0.989736795425415, 0.007010194938629866, 0.003252972150221467]}
```

Breakfast is the winner. Notice that all the  probabilities add up to 1. This is because the default mode for `classify` uses `softmax`. We can change that so the categories are each considered independently with the `:multi-class` option.

```clojure
(classifier text labels :multi_class true)
{'labels': ['breakfast', 'lunch', 'dinner'],
 'scores': [0.9959920048713684, 0.22608685493469238, 0.031050905585289]}
```


This is a really powerful technique for such an easy to use library. However, how can we do anything with it if we don't understand how it is working and get a handle on how to debug it. We need some level of trust in it for utility.

This is where LIME enters.

### Using LIME for Interpretable Models

One of the biggest problems holding back applying state of the art machine learning models to real life problems is that of interpretability and trust. The [lime technique](https://github.com/marcotcr/lime) is a well designed tool to help with this. One of the reasons that I really like it is that it is `model agnostic`. This means that you can use it with whatever code you want to use with it as long as you adhere to it's `api`. You need to provide it with the input and a function that will classify and return the probabilities in a numpy array.

The creation of the explainer is only a `require` away:

```clojure
(require-python '[lime.lime_text :as lime])
(require-python 'numpy)


(def explainer (lime/LimeTextExplainer :class_names labels))
```

We need to create a function that will take in some text and then return the probabilities  for the labels. Since the zeroshot classifier will reorder the returning labels/probs by the value, we need to make sure that it will match up by index to the original labels.

```clojure
(defn predict-probs
  [text]
  (let [result (classifier text labels)
        result-scores (get result "scores")
        result-labels (get result "labels")
        result-map (zipmap result-labels result-scores)]
    (mapv (fn [cn]
            (get result-map cn))
          labels)))


(defn predict-texts
  [texts]
d  (println "lime texts are " texts)
  (numpy/array (mapv predict-probs texts)))


 (predict-texts [text]) ;=>  [[0.99718672 0.00281324]]
````

Finally we make an explanation for our text here. We are only using 6 features and 100 samples, to keep the cpus down, but in real life you would want to use closer to the default amount of `5000` samples. The samples are how the explainers work, it modifies the text over and over again and sees the difference in classification values. For example, one of the sample texts for our case is `' Toast with   bacon in the center with  syrup on .  with  sugar  desired.'`.


```clojure
(def exp-result
  (py. explainer "explain_instance" text predict-texts
       :num_features 6
       :num_samples 100))


(py. exp-result "save_to_file" "explanation.html")
```

![](https://live.staticflickr.com/65535/51039510876_e547177bb2_h.jpg)


## Final Thoughts

Exciting advances are happening in Deep Learning and NLP. To make them truly useful,  we will need to continue to consider how to make them interpretable and debuggable.

As always, keep your Clojure REPL handy.

