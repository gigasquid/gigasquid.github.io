---
layout: post
title: "Hugging Face GPT with Clojure"
date: 2020-01-10 19:33
comments: true
categories: 
- All
- Clojure
- Deep Learning
---

![](https://live.staticflickr.com/65535/49364554561_6e4f4d0a51_w.jpg)

A new age in Clojure has dawned. We now have interop access to any python library with [libpython-clj](https://github.com/cnuernber/libpython-clj).

<br>

Let me pause a minute to repeat.

<br>

** You can now interop with ANY python library. **

<br>

I know. It's overwhelming. It took a bit for me to come to grips with it too.

<br>

Let's take an example of something that I've _always_ wanted to do and have struggled with mightly finding a way to do it in Clojure:  
I want to use the latest cutting edge GPT2 code out there to generate text.  

Right now, that library is [Hugging Face Transformers](https://github.com/huggingface/transformers).  
<br>

Get ready. We will wrap that sweet hugging face code in Clojure parens!  

### The setup

The first thing you will need to do is to have python3 installed and the two libraries that we need:

<br>

* pytorch - `sudo pip3 install torch`
* hugging face transformers - `sudo pip3 install transformers`

<br>

Right now, some of you may not want to proceed. You might have had a bad relationship with Python in the past. It's ok, remember that some of us had bad relationships with Java, but still lead a happy and fulfilled life with Clojure and still can enjoy it from interop. The same is true with Python. Keep an open mind.

<br>


There might be some others that don't want to have anything to do with Python and want to keep your Clojure pure. Well, that is a valid choice. But you are missing out on what the big, vibrant, and chaotic Python Deep Learning ecosystem has to offer. 

<br>

For those of you that are still along for the ride, let's dive in.

<br>

Your deps file should have just a single extra dependency in it:

```clojure
:deps {org.clojure/clojure {:mvn/version "1.10.1"}
        cnuernber/libpython-clj {:mvn/version "1.30"}}
```

### Diving Into Interop

The first thing that we need to do is require the libpython library.

```clojure
(ns gigasquid.gpt2
  (:require [libpython-clj.require :refer [require-python]]
            [libpython-clj.python :as py]))
```

It has a very nice `require-python` syntax that we will use to load the python libraries so that we can use them in our Clojure code.

```clojure
(require-python '(transformers))
(require-python '(torch))
```

Here we are going to follow along with the OpenAI GPT-2 tutorial and translate it into interop code.
The original tutorial is [here](https://huggingface.co/transformers/quickstart.html)

<br>

Let's take the python side first:

```python
import torch
from transformers import GPT2Tokenizer, GPT2LMHeadModel

# Load pre-trained model tokenizer (vocabulary)
tokenizer = GPT2Tokenizer.from_pretrained('gpt2')
```

This is going to translate in our interop code to:

```clojure
(def tokenizer (py/$a transformers/GPT2Tokenizer from_pretrained "gpt2"))
```

The `py/$a` function is used to call attributes on a Python object. We get the `transformers/GPTTokenizer` object that we have available to use and call `from_pretrained` on it with the string argument `"gpt2"`

<br>



Next in the Python tutorial is:

```python
# Encode a text inputs
text = "Who was Jim Henson ? Jim Henson was a"
indexed_tokens = tokenizer.encode(text)

# Convert indexed tokens in a PyTorch tensor
tokens_tensor = torch.tensor([indexed_tokens])
```

This is going to translate to Clojure:

```clojure
(def text "Who was Jim Henson ? Jim Henson was a")
;; encode text input
(def indexed-tokens  (py/$a tokenizer encode text))
indexed-tokens ;=>[8241, 373, 5395, 367, 19069, 5633, 5395, 367, 19069, 373, 257]

;; convert indexed tokens to pytorch tensor
(def tokens-tensor (torch/tensor [indexed-tokens]))
tokens-tensor
;; ([[ 8241,   373,  5395,   367, 19069,  5633,  5395,   367, 19069,   373,
;;    257]])
```

Here we are again using `py/$a` to call the `encode` method on the text. However, when we are just calling a function, we can do so directly with `(torch/tensor [indexed-tokens])`. We can even directly use vectors. 

<br>

Again, you are doing this in the REPL, so you have full power for inspection and display of the python objects. It is a great interop experience - (cider even has doc information on the python functions in the minibuffer)!

<br>

The next part is to load the model itself. This will take a few minutes, since it has to download a big file from s3 and load it up.

<br>

In Python:

```python
# Load pre-trained model (weights)
model = GPT2LMHeadModel.from_pretrained('gpt2')
```

In Clojure:

```clojure
;;; Load pre-trained model (weights)
;;; Note: this will take a few minutes to download everything
(def model (py/$a transformers/GPT2LMHeadModel from_pretrained "gpt2"))
```


The next part is to run the model with the tokens and make the predictions.

<br>

Here the code starts to diverge a tiny bit.

<br>

Python:

```python
# Set the model in evaluation mode to deactivate the DropOut modules
# This is IMPORTANT to have reproducible results during evaluation!
model.eval()

# If you have a GPU, put everything on cuda
tokens_tensor = tokens_tensor.to('cuda')
model.to('cuda')

# Predict all tokens
with torch.no_grad():
    outputs = model(tokens_tensor)
    predictions = outputs[0]

# get the predicted next sub-word (in our case, the word 'man')
predicted_index = torch.argmax(predictions[0, -1, :]).item()
predicted_text = tokenizer.decode(indexed_tokens + [predicted_index])
assert predicted_text == 'Who was Jim Henson? Jim Henson was a man'
```

And Clojure

```clojure
;;; Set the model in evaluation mode to deactivate the DropOut modules
;;; This is IMPORTANT to have reproducible results during evaluation!
(py/$a model eval)


;;; Predict all tokens
(def predictions (py/with [r (torch/no_grad)]
                          (first (model tokens-tensor))))

;;; get the predicted next sub-word"
(def predicted-index (let [last-word-predictions (-> predictions first last)
                           arg-max (torch/argmax last-word-predictions)]
                       (py/$a arg-max item)))

predicted-index ;=>582

(py/$a tokenizer decode (-> (into [] indexed-tokens)
                            (conj predicted-index)))

;=> "Who was Jim Henson? Jim Henson was a man"
```

The main differences is that we are obviously not using the python array syntax in our code to manipulate the lists. For example, instead of using `outputs[0]`, we are going to use `(first outputs)`. But, other than that, it is a pretty good match, even with the `py/with`.


Also note that we are not making the call to configure it with GPU. This is intentionally left out to keep things simple for people to try it out. Sometimes, GPU configuration can be a bit tricky to set up depending on your system. For this example, you definitely won't need it since it runs fast enough on cpu. If you do want to do something more complicated later, like fine tuning, you will need to invest some time to get it set up. 


### Doing Longer Sequences

The next example in the tutorial goes on to cover generating longer text. 

<br>

Python

```python
tokenizer = GPT2Tokenizer.from_pretrained("gpt2")
model = GPT2LMHeadModel.from_pretrained('gpt2')

generated = tokenizer.encode("The Manhattan bridge")
context = torch.tensor([generated])
past = None

for i in range(100):
    print(i)
    output, past = model(context, past=past)
    token = torch.argmax(output[0, :])

    generated += [token.tolist()]
    context = token.unsqueeze(0)

sequence = tokenizer.decode(generated)

print(sequence)

```

And Clojure

```clojure
(def tokenizer (py/$a transformers/GPT2Tokenizer from_pretrained "gpt2"))
(def model (py/$a transformers/GPT2LMHeadModel from_pretrained "gpt2"))

(def generated (into [] (py/$a tokenizer encode "The Manhattan bridge")))
(def context (torch/tensor [generated]))


(defn generate-sequence-step [{:keys [generated-tokens context past]}]
  (let [[output past] (model context :past past)
        token (-> (torch/argmax (first output)))
        new-generated  (conj generated-tokens (py/$a token tolist))]
    {:generated-tokens new-generated
     :context (py/$a token unsqueeze 0)
     :past past
     :token token}))

(defn decode-sequence [{:keys [generated-tokens]}]
  (py/$a tokenizer decode generated-tokens))

(loop [step {:generated-tokens generated
             :context context
             :past nil}
       i 10]
  (if (pos? i)
    (recur (generate-sequence-step step) (dec i))
    (decode-sequence step)))

;=> "The Manhattan bridge\n\nThe Manhattan bridge is a major artery for"
```

The great thing is once we have it embedded in our code, there is no stopping. We can create a nice function:

```clojure
(defn generate-text [starting-text num-of-words-to-predict]
  (let [tokens (into [] (py/$a tokenizer encode starting-text))
        context (torch/tensor [tokens])
        result (reduce
                (fn [r i]
                  (println i)
                  (generate-sequence-step r))

                {:generated-tokens tokens
                 :context context
                 :past nil}

                (range num-of-words-to-predict))]
    (decode-sequence result)))
```

And finally we can generate some fun text!

```clojure
(generate-text "Clojure is a dynamic, general purpose programming language, combining the approachability and interactive" 20)

;=> "Clojure is a dynamic, general purpose programming language, combining the approachability and interactive. It is a language that is easy to learn and use, and is easy to use for anyone"
```

**Clojure is a dynamic, general purpose programming language, combining the approachability and interactive. It is a language that is easy to learn and use, and is easy to use for anyone**

<br>

So true GPT2! So true!


### Wrap-up


libpython-clj is a really powerful tool that will allow Clojurists to better explore, leverage, and integrate Python libraries into their code. 

<br>

I've been really impressed with it so far and I encourage you to check it out.

<br>

There is a [repo with the examples](https://github.com/gigasquid/libpython-clj-examples) out there if you want to check them out. There is also an example of doing MXNet MNIST classification there as well.

