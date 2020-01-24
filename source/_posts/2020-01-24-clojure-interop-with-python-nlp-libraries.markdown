---
layout: post
title: "Clojure Interop with Python NLP Libraries"
date: 2020-01-24 15:34
comments: true
categories: 
- All
- Clojure
- Python
---

![clojure-python](http:////live.staticflickr.com/65535/49435394578_400fdf1c7f_c.jpg)


In this edition of the blog series of looking at examples of Clojure-Python interop with [libpython-clj](https://github.com/cnuernber/libpython-clj), we'll be taking a look at two popular Python NLP libraries: [NLTK](https://www.nltk.org/) and [SpaCy](https://spacy.io/).

## NLTK - Natural Language Toolkit

I was taking requests for doing examples of python-clojure interop libraries on twitter the other day, and by _far_ NLTK was the most requested library. After looking into it, I can see why. It's the most popular natural language processing library in Python and you will see it everywhere there is text someone is touching.

### Installation

To use the NLTK toolkit you will need to install it. I use `sudo pip3 install nltk`, but libpython-clj now supports virtual environments with this [PR](https://github.com/cnuernber/libpython-clj/pull/53), so feel free to use whatever is best for you.


### Features 

We'll take a quick tour of the features of NLTK following along initially with the [nltk official book](https://www.nltk.org/book/ch01.html) and then moving onto this more data task centered [tutorial](https://www.datacamp.com/community/tutorials/text-analytics-beginners-nltk).


First, we need to require all of our things as usual:

```clojure
(ns gigasquid.nltk
  (:require [libpython-clj.require :refer [require-python]]
            [libpython-clj.python :as py :refer [py. py.. py.-]]))
(require-python '([nltk :as nltk]))
```

#### Downloading packages

There are all sorts of packages available to download from NLTK. To start out and tour the library, I would go with a small one that has basic data for the nltk book tutorial.

```clojure
 (nltk/download "book")
  (require-python '([nltk.book :as book]))
```

There are all other sorts of downloads as well, such as `(nltk/download "popular")` for most used ones. You can also download `"all"`, but beware that it is big.

You can check out some of the texts it downloaded with:

```clojure
  (book/texts)

  ;;; prints out in repl
  ;; text1: Moby Dick by Herman Melville 1851
  ;; text2: Sense and Sensibility by Jane Austen 1811
  ;; text3: The Book of Genesis
  ;; text4: Inaugural Address Corpus
  ;; text5: Chat Corpus
  ;; text6: Monty Python and the Holy Grail
  ;; text7: Wall Street Journal
  ;; text8: Personals Corpus
  ;; text9: The Man Who Was Thursday by G . K . Chesterton 1908
  
  book/text1 ;=>  <Text: Moby Dick by Herman Melville 1851>
  book/text2 ;=>  <Text: Sense and Sensibility by Jane Austen 1811>
  
```
  
  You can do fun things like see how many tokens are in a text
  
```clojure
  (count (py.- book/text3 tokens))  ;=> 44764
```
  
  Or even see the lexical diversity, which is a measure of the richness of the text by looking at the unique set of word tokens against the total tokens.
  
```clojure
  (defn lexical-diversity [text]
    (let [tokens (py.- text tokens)]
      (/ (-> tokens set count)
         (* 1.0 (count tokens)))))

  (lexical-diversity book/text3) ;=> 0.06230453042623537
  (lexical-diversity book/text5) ;=> 0.13477005109975562
```


 This of course is all very interesting but I prefer to look at some more practical tasks, so we are going to look at some sentence tokenization.
 
 
#### Sentence Tokenization
 
 Text can be broken up into individual word tokens or sentence tokens. Let's start off first with the token package
 
```clojure
(require-python '([nltk.tokenize :as tokenize]))
(def text "Hello Mr. Smith, how are you doing today? The weather is great, and city is awesome.
The sky is pinkish-blue. You shouldn't eat cardboard")
```

To tokenize sentences, you take the text and use `tokenize/sent_tokenize`.

```clojure
 (def text "Hello Mr. Smith, how are you doing today? The weather is great, and city is awesome.
The sky is pinkish-blue. You shouldn't eat cardboard")
 (def tokenized-sent (tokenize/sent_tokenize text))
 tokenized-sent
 ;;=> ['Hello Mr. Smith, how are you doing today?', 'The weather is great, and city is awesome.', 'The sky is pinkish-blue.', "You shouldn't eat cardboard"]
```

Likewise, to tokenize words, you use `tokenize/word_tokenize`:

```clojure
 (def text "Hello Mr. Smith, how are you doing today? The weather is great, and city is awesome.
The sky is pinkish-blue. You shouldn't eat cardboard")
 (def tokenized-sent (tokenize/sent_tokenize text))
 tokenized-sent
 ;;=> ['Hello Mr. Smith, how are you doing today?', 'The weather is great, and city is awesome.', 'The sky is pinkish-blue.', "You shouldn't eat cardboard"]


 (def tokenized-word (tokenize/word_tokenize text))
 tokenized-word
  ;;=> ['Hello', 'Mr.', 'Smith', ',', 'how', 'are', 'you', 'doing', 'today', '?', 'The', 'weather', 'is', 'great', ',', 'and', 'city', 'is', 'awesome', '.', 'The', 'sky', 'is', 'pinkish-blue', '.', 'You', 'should', "n't", 'eat', 'cardboard']
```
 
 
#### Frequency Distribution
 
 You can also look at the frequency distribution of the words with using the probability package.
 
 
```clojure
 (require-python '([nltk.probability :as probability]))

 (def fdist (probability/FreqDist tokenized-word))
 fdist ;=> <FreqDist with 25 samples and 30 outcomes>

 (py. fdist most_common)
  ;=> [('is', 3), (',', 2), ('The', 2), ('.', 2), ('Hello', 1), ('Mr.', 1), ('Smith', 1), ('how', 1), ('are', 1), ('you', 1), ('doing', 1), ('today', 1), ('?', 1), ('weather', 1), ('great', 1), ('and', 1), ('city', 1), ('awesome', 1), ('sky', 1), ('pinkish-blue', 1), ('You', 1), ('should', 1), ("n't", 1), ('eat', 1), ('cardboard', 1)]

```

#### Stop Words

Stop words are considered noise in text and there are ways to use the library to remove them using the `nltk.corpus`.


```clojure
(def stop-words (into #{} (py. corpus/stopwords words "english")))
 stop-words
  ;=> #{"d" "itself" "more" "didn't" "ain" "won" "hers"....}
```

Now that we have a collection of the stop words, we can filter them out of our text in the normal way in Clojure.

```clojure
(def filtered-sent (->> tokenized-sent
                         (map tokenize/word_tokenize)
                         (map #(remove stop-words %))))
 filtered-sent
 ;; (("Hello" "Mr." "Smith" "," "today" "?")
 ;; ("The" "weather" "great" "," "city" "awesome" ".")
 ;; ("The" "sky" "pinkish-blue" ".")
 ;; ("You" "n't" "eat" "cardboard"))
```


#### Lexion Normalization and Lemmatization

Stemming and Lemmatization allow ways for the text to be reduced to base words and normalized.
For example, the word `flying` has a stemmed word of `fli` and a lemma of `fly`.

```clojure
(require-python '([nltk.stem :as stem]))
(require-python '([nltk.stem.wordnet :as wordnet]))

(let [lem (wordnet/WordNetLemmatizer)
       stem (stem/PorterStemmer)
       word "flying"]
   {:lemmatized-word (py. lem lemmatize word "v")
    :stemmed-word (py. stem stem word)})
 ;=> {:lemmatized-word "fly", :stemmed-word "fli"}
```

#### POS Tagging

It also has support for Part-of-Speech (POS) Tagging. A quick example of that is:

```clojure
(let [sent "Albert Einstein was born in Ulm, Germany in 1879."
       tokens (nltk/word_tokenize sent)]
   {:tokens tokens
    :pos-tag (nltk/pos_tag tokens)})
 ;; {:tokens
 ;; ['Albert', 'Einstein', 'was', 'born', 'in', 'Ulm', ',', 'Germany', 'in', '1879', '.'],
 ;; :pos-tag
 ;; [('Albert', 'NNP'), ('Einstein', 'NNP'), ('was', 'VBD'), ('born', 'VBN'), ('in', 'IN'), ('Ulm', 'NNP'), (',', ','), ('Germany', 'NNP'), ('in', 'IN'), ('1879', 'CD'), ('.', '.')]}
```

Phew! That's a brief overview of what NLTK can do, now what about the other library SpaCy?

## SpaCy

[SpaCy](https://spacy.io/usage/spacy-101#whats-spacy) is the main competitor to NLTK. It has a more opinionated library which is more object oriented than NLTK which mainly processes text. It has better performance for tokenization and POS tagging and has support for word vectors, which NLTK does not.

Let's dive in a take a look at it.

### Installation

To install spaCy, you will need to do:

* `pip3 install spacy`
* ` python3 -m spacy download en_core_web_sm` to load up the small language model

We'll be following alon the tutorial beginning at [https://spacy.io/usage/spacy-101#annotat]( https://spacy.io/usage/spacy-101#annotat)

We will, of course, need to load up the library

`(require-python '([spacy :as spacy]))`

and its language model:

```clojure
(def nlp (spacy/load "en_core_web_sm"))
```

#### Linguistic Annotations

There are many linguistic annotations that are available, from POS, lemmas, and more:


```clojure
(let [doc (nlp "Apple is looking at buying U.K. startup for $1 billion")]
  (map (fn [token]
         [(py.- token text) (py.- token pos_) (py.- token dep_)])
       doc))
;; (["Apple" "PROPN" "nsubj"]
;;  ["is" "AUX" "aux"]
;;  ["looking" "VERB" "ROOT"]
;;  ["at" "ADP" "prep"]
;;  ["buying" "VERB" "pcomp"]
;;  ["U.K." "PROPN" "compound"]
;;  ["startup" "NOUN" "dobj"]
;;  ["for" "ADP" "prep"]
;;  ["$" "SYM" "quantmod"]
;;  ["1" "NUM" "compound"]
;;  ["billion" "NUM" "pobj"])
```

Here are some more:

```clojure
(let [doc (nlp "Apple is looking at buying U.K. startup for $1 billion")]
  (map (fn [token]
         {:text (py.- token text)
          :lemma (py.- token lemma_)
          :pos (py.- token pos_)
          :tag (py.- token tag_)
          :dep (py.- token dep_)
          :shape (py.- token shape_)
          :alpha (py.- token is_alpha)
          :is_stop (py.- token is_stop)} )
       doc))

;; ({:text "Apple",
;;   :lemma "Apple",
;;   :pos "PROPN",
;;   :tag "NNP",
;;   :dep "nsubj",
;;   :shape "Xxxxx",
;;   :alpha true,
;;   :is_stop false}
;;  {:text "is",
;;   :lemma "be",
;;   :pos "AUX",
;;   :tag "VBZ",
;;   :dep "aux",
;;   :shape "xx",
;;   :alpha true,
;;   :is_stop true}
;;  ...
```

### Named Entities

It also handles named entities in the same fashion.

```clojure
(let [doc (nlp "Apple is looking at buying U.K. startup for $1 billion")]
  (map (fn [ent]
         {:text (py.- ent text)
          :start-char (py.- ent start_char)
          :end-char (py.- ent end_char)
          :label (py.- ent label_)} )
       (py.- doc ents)))

;; ({:text "Apple", :start-char 0, :end-char 5, :label "ORG"}
;;  {:text "U.K.", :start-char 27, :end-char 31, :label "GPE"}
;;  {:text "$1 billion", :start-char 44, :end-char 54, :label "MONEY"})
```

As you can see, it can handle pretty much the same things as NLTK. But let's take a look at what it can do that NLTK and that is with word vectors.

#### Word Vectors

In order to use word vectors, you will have to load up a medium or large size data model because the small ones don't ship with word vectors. You can do that at the command line with:

```
python3 -m spacy download en_core_web_md
```

You will need to restart your repl and then load it with:

```clojure
(require-python '([spacy :as spacy]))
(def nlp (spacy/load "en_core_web_md"))
```

Now you can see cool word vector stuff!

```clojure
(let [tokens (nlp "dog cat banana afskfsd")]
  (map (fn [token]
         {:text (py.- token text)
          :has-vector (py.- token has_vector)
          :vector_norm (py.- token vector_norm)
          :is_oov (py.- token is_oov)} )
       tokens))

;; ({:text "dog",
;;   :has-vector true,
;;   :vector_norm 7.033673286437988,
;;   :is_oov false}
;;  {:text "cat",
;;   :has-vector true,
;;   :vector_norm 6.680818557739258,
;;   :is_oov false}
;;  {:text "banana",
;;   :has-vector true,
;;   :vector_norm 6.700014114379883,
;;   :is_oov false}
;;  {:text "afskfsd", :has-vector false, :vector_norm 0.0, :is_oov true})
```

And find similarity between different words.

```clojure
(let [tokens (nlp "dog cat banana")]
  (for [token1 tokens
        token2 tokens]
    {:token1 (py.- token1 text)
     :token2 (py.- token2 text)
     :similarity (py. token1 similarity token2)}))

;; ({:token1 "dog", :token2 "dog", :similarity 1.0}
;;  {:token1 "dog", :token2 "cat", :similarity 0.8016854524612427}
;;  {:token1 "dog", :token2 "banana", :similarity 0.2432764321565628}
;;  {:token1 "cat", :token2 "dog", :similarity 0.8016854524612427}
;;  {:token1 "cat", :token2 "cat", :similarity 1.0}
;;  {:token1 "cat", :token2 "banana", :similarity 0.28154364228248596}
;;  {:token1 "banana", :token2 "dog", :similarity 0.2432764321565628}
;;  {:token1 "banana", :token2 "cat", :similarity 0.28154364228248596}
;;  {:token1 "banana", :token2 "banana", :similarity 1.0})
```

## Wrap up

We've seen a grand tour of the two most popular natural language python libraries that you can now use through Clojure interop!

I hope you've enjoyed it and if you are interested in exploring yourself, the code examples are [here](https://github.com/gigasquid/libpython-clj-examples)
