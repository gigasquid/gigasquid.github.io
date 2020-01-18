---
layout: post
title: "Parens for Pyplot"
date: 2020-01-18 15:39
comments: true
categories:
- All
- Clojure
- Python
---

[libpython-clj](https://github.com/cnuernber/libpython-clj) has opened the door for Clojure to directly interop with Python libraries. That means we can take just about any Python library and directly use it in our Clojure REPL. But what about [matplotlib](https://matplotlib.org/)?




Matplotlib.pyplot is a standard fixture in most tutorials and python data science code. How do we interop with a python graphics library?


## How do you interop?


It turns out that matplotlib has a headless mode where we can export the graphics and then display it using any method that we would normally use to display a .png file. In my case, I made a quick macro for it using the shell `open`. I'm sure that someone out that could improve upon it, (and maybe even make it a cool utility lib), but it suits what I'm doing so far:

```clojure
ns gigasquid.plot
(:require [libpython-clj.require :refer [require-python]]
[libpython-clj.python :as py :refer [py. py.. py.-]]
[clojure.java.shell :as sh])


;;; This uses the headless version of matplotlib to generate a graph then copy it to the JVM
;; where we can then print it

;;;; have to set the headless mode before requiring pyplot
(def mplt (py/import-module "matplotlib"))
(py. mplt "use" "Agg")

(require-python 'matplotlib.pyplot)
(require-python 'matplotlib.backends.backend_agg)
(require-python 'numpy)


(defmacro with-show
  "Takes forms with mathplotlib.pyplot to then show locally"
  [& body]
  `(let [_# (matplotlib.pyplot/clf)
         fig# (matplotlib.pyplot/figure)
         agg-canvas# (matplotlib.backends.backend_agg/FigureCanvasAgg fig#)]
     ~(cons 'do body)
     (py. agg-canvas# "draw")
     (matplotlib.pyplot/savefig "temp.png")
     (sh/sh "open" "temp.png")))
```

## Parens for Pyplot!

Now that we have our wrapper let's take it for a spin. We'll be following along more or less this [tutorial for numpy plotting](http://cs231n.github.io/python-numpy-tutorial/#matplotlib-plotting)


For setup you will need the following installed in your python environment:

- numpy
- matplotlib
- pillow


We are also going to use the latest and greatest syntax from libpython-clj so you are going to need to install the snapshot version locally until the next version goes out:

* `git clone git@github.com:cnuernber/libpython-clj.git`
* `cd cd libpython-clj`
* `lein install`


After that is all setup we can require the libs we need in clojure.

```clojure
(ns gigasquid.numpy-plot
  (:require [libpython-clj.require :refer [require-python]]
            [libpython-clj.python :as py :refer [py. py.. py.-]]
            [gigasquid.plot :as plot]))
```

The `plot` namespace contains the macro for `with-show` above. The `py.` and others is the new and improved syntax for interop.


### Simple Sin and Cos

Let's start off with a simple sine and cosine functions. This code will create a `x` numpy vector of a range from 0 to `3 * pi` in 0.1 increments and then create `y` numpy vector of the `sin` of that and plot it

```clojure
(let [x (numpy/arange 0 (* 3 numpy/pi) 0.1)
        y (numpy/sin x)]
    (plot/with-show
      (matplotlib.pyplot/plot x y)))
```

![sin](https://live.staticflickr.com/65535/49405284796_014447588d_z.jpg)


Beautiful yes!


Let's get a bit more complicated now and and plot both the sin and cosine as well as add labels, title, and legend.

```clojure
(let [x (numpy/arange 0 (* 3 numpy/pi) 0.1)
        y-sin (numpy/sin x)
        y-cos (numpy/cos x)]
    (plot/with-show
      (matplotlib.pyplot/plot x y-sin)
      (matplotlib.pyplot/plot x y-cos)
      (matplotlib.pyplot/xlabel "x axis label")
      (matplotlib.pyplot/ylabel "y axis label")
      (matplotlib.pyplot/title "Sine and Cosine")
      (matplotlib.pyplot/legend ["Sine" "Cosine"])))
```

![sin and cos](http:////live.staticflickr.com/65535/49405284806_1d04957bce_z.jpg)


We can also add subplots. Subplots are when you divide the plots into different portions.
It is a bit stateful and involves making one subplot _active_ and making changes and then making the other subplot _active_. Again not too hard to do with Clojure.

```clojure
(let [x (numpy/arange 0 (* 3 numpy/pi) 0.1)
        y-sin (numpy/sin x)
        y-cos (numpy/cos x)]
    (plot/with-show
      ;;; set up a subplot gird that has a height of 2 and width of 1
      ;; and set the first such subplot as active
      (matplotlib.pyplot/subplot 2 1 1)
      (matplotlib.pyplot/plot x y-sin)
      (matplotlib.pyplot/title "Sine")

      ;;; set the second subplot as active and make the second plot
      (matplotlib.pyplot/subplot 2 1 2)
      (matplotlib.pyplot/plot x y-cos)
      (matplotlib.pyplot/title "Cosine")))
```

![sin and cos subplots](http:////live.staticflickr.com/65535/49405284836_8e49e4a6b8_z.jpg)


### Plotting with Images

Pyplot also has functions for working directly with images as well. Here we take a picture of my cat and create another version of it that is tinted.

```clojure
(let [img (matplotlib.pyplot/imread "resources/cat.jpg")
        img-tinted (numpy/multiply img [1 0.95 0.9])]
    (plot/with-show
      (matplotlib.pyplot/subplot 1 2 1)
      (matplotlib.pyplot/imshow img)
      (matplotlib.pyplot/subplot 1 2 2)
      (matplotlib.pyplot/imshow (numpy/uint8 img-tinted))))
```

![cat tinted](http://live.staticflickr.com/65535/49404801993_ed398d5768_n.jpg)

### Pie charts

Finally, we can show how to do a pie chart. I asked people in a [twitter thread](https://twitter.com/gigasquid/status/1218358472049397761) what they wanted an example of in python interop and one of them was a pie chart. This is for you!

The original code for this example came from this [tutorial](https://matplotlib.org/3.1.1/gallery/pie_and_polar_charts/pie_features.html).

```clojure
(let [labels ["Frogs" "Hogs" "Dogs" "Logs"]
        sizes [15 30 45 10]
        explode [0 0.1 0 0] ; only explode the 2nd slice (Hogs)
        ]
    (plot/with-show
      (let [[fig1 ax1] (matplotlib.pyplot/subplots)]
        (py. ax1 "pie" sizes :explode explode :labels labels :autopct "%1.1f%%"
                             :shadow true :startangle 90)
        (py. ax1 "axis" "equal")) ;equal aspec ration ensures that pie is drawn as circle
      ))
```

![pie chart](http://live.staticflickr.com/65535/49404802008_7e84ceff76_z.jpg)


### Onwards and Upwards!

This is just the beginning. In upcoming posts, I will be showcasing examples of interop with different libraries from the python ecosystem. Part of the goal is to get people used to how to use interop but also to raise awareness of the capabilities of the python libraries out there right now since they have been historically out of our ecosystem.


If you have any libraries that you would like examples of, I'm taking requests. Feel free to leave them in the comments of the blog or in the [twitter thread](https://twitter.com/gigasquid/status/1218358472049397761).

Until next time, happy interoping!



PS All the code examples are here [https://github.com/gigasquid/libpython-clj-examples](https://github.com/gigasquid/libpython-clj-examples)

