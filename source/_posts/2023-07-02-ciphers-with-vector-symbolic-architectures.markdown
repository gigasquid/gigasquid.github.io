---
layout: post
title: "Ciphers with Vector Symbolic Architectures"
date: 2023-07-02 12:31
comments: true
categories: 
- All
- Clojure
- AI
---
![](https://raw.githubusercontent.com/gigasquid/vsa-clj/main/examples/secret-message.png)

_A secret message inside a 10,000 hyperdimensional vector_


We've seen in previous posts how we can encode data structures using [Vector Symbolic Architectures in Clojure](http://gigasquidsoftware.com/blog/2022/12/31/vector-symbolic-architectures-in-clojure/). This is an exploration of how we can use this to develop a cipher to transmit a secret message between two parties.

### A Hyperdimensional Cipher

Usually, we would develop a dictionary/ cleanup memory of randomly chosen hyperdimensional vectors to represent each symbol. We could do this, but then sharing the dictionary as our key to be able to decode messages would be big. Instead, we could share a single hyperdimensional vector and then use the protect/ rotation operator to create a dictionary of the alphabet and some numbers to order the letters. Think of this as the initial seed symbol and the rest being defined as `n+1`.

```clojure
(def alphabet
  [:a :b :c :d :e :f :g :h :i :j :k :l :m :n :o :p :q :r :s :t :u :v :w :x :y :z :end-of-message])


(def max-num 4)
(def numbers (range 1 (inc max-num)))
(def key-codes (into alphabet numbers))


(defn add-keys-to-cleanup-mem!
  "Take a single hdv as a seed and create an alphabet + numbers of them by using rotation/ protect"
  [seed-hdv]
  (vb/reset-hdv-mem!)
  (doall
    (reduce (fn [v k]
              (let [nv (vb/protect v)]
                (vb/add-hdv! k nv)
                nv))
            seed-hdv
            key-codes)))
```

We can then encode a message by using a VSA data structure map with the form:

```
{1 :c, 2 :a, 3 :t, 4 :s}
```
where the numbers are the key to the order of the sequence of the message.

```clojure
(defn encode-message
  "Encode a message using key value pairs with numbers for ordering"
  [message]
  (when (> (count message) max-num)
    (throw (ex-info "message too long" {:allowed-n max-num})))
  (let [ds (zipmap numbers
                   (conj (->> (mapv str message)
                              (mapv keyword))
                         :end-of-message))]
    (println "Encoding " message " into " ds)
    (vd/clj->vsa ds)))
```

The message is now in a single hyperdimensional vector. We can decode the message by inspecting each of the numbers in the key value pairs encoded in the data structure.

```clojure
(defn decode-message
  "Decode a message by getting the value of the numbered pairs"
  [msg]
  (let [message-v
        _ (println "decoded message-v " message-v)
        decoded (->> message-v
                     (partition-by #(= % :end-of-message))
                     first
                     (mapv #(if (keyword? %)
                              (name %)
                              (str %)))
                     (apply str))]
    (println "Decoded message is " decoded)
    decoded))
```

Some example code of generating and decoding the message:

```clojure
  (vb/set-size! 1e4)
  (def seed-key-hdv (vb/hdv))
  (add-keys-to-cleanup-mem! seed-key-hdv)
  (image/write-image-hdv "seed-key-hdv" seed-key-hdv)

  (def message (encode-message "cats"))
  (image/write-image-hdv "secret-message" message)
  (decode-message message)
  ;=> "cats"
```

The cool thing is that both hyperdimensional dictionary and the hyperdimensional encoded message can both be shared as a simple image like these:

- ![](https://raw.githubusercontent.com/gigasquid/vsa-clj/main/examples/seed-key-hdv.png) The seed key to generate the dictionary/ cleanup-mem

- ![](https://raw.githubusercontent.com/gigasquid/vsa-clj/main/examples/secret-message.png)The encoded secret message

Then you can load up the seed key/ message from the image. Once you have the dictionary shared, you can create multiple encoded messages with it.

```clojure
(def loaded-key (image/read-image-to-hdv "examples/seed-key-hdv.png"))
  (add-keys-to-cleanup-mem! loaded-key)
  (def loaded-message (image/read-image-to-hdv "examples/secret-message.png"))
  (decode-message loaded-message)
```

### Caveats

Please keep in mind that this is just an experiment - *do not use* for anything important. Another interesting factor to keep in mind is that the VSA operations to get the key value are probabilistic  so that the correct decoding is not guaranteed. In fact, I set a limit on the 10,000 dimensional vector message to be 4 letters, which I found to be pretty reliable. For example, with 10,000 dimensions, encoding `catsz` decoded as `katsz`.

Increasing the number of dimensions lets you encode longer messages. This article is a good companion to look at [capacity across different implementations of VSAs](https://link.springer.com/article/10.1007/s10462-021-10110-3).


### Conclusion

VSAs could be an interesting way to do ciphers. Some advantages could be that the distribution of the information across the vector and the nature of the mapped data structure, it is hard to do things like vowel counting to try to decipher messages. Of course you don't need to have letters and numbers be the only symbols used in the dictionary, they could represent other things as well. The simplicity of being able to encode data structures in a form that can easily be expressed as a black and white image, also lends in its flexibility. Another application might be the ability to combine this technique with deep learning to keep information safe during the training process.

[Link to the full github code](https://github.com/gigasquid/vsa-clj/blob/main/examples/vsa_cipher.clj)
