---
author: gigasquid
comments: true
date: 2012-07-07 19:02:33+00:00
layout: post
slug: how-to-include-non-clojars-clojure-version-in-your-lein-project
title: How to include non clojars/maven clojure version in your lein project
wordpress_id: 403
categories:
- All
- Clojure
---

Do you need to have a specific version of Clojure in your leiningen project that you can't get from Clojars?

I ran into this problem when I wanted to run a sample project on Clojure's reducers - which is not in the current Clojars version of 1.4.0.  I needed to use the most recent version, (unreleased), of 1.5.0.  These are the steps to get you running.



	
  * Clone the [clojure git repository ](https://github.com/clojure/clojure/)

	
  * In the project directory - run ant to build the jar

	
  * Install the jar into your local maven repo


`mvn install:install-file -DgroupId=org.clojure -DartifactId=clojure -Dfile=clojure-1.5.0-master-SNAPSHOT.jar -DpomFile=pom.xml`



	
  * Now you can update your lein project.clj with


`(defproject reducers "1.0.0-SNAPSHOT"
:description "FIXME: write description"
:dependencies [[org.clojure/clojure "1.5.0-master-SNAPSHOT"]])`
Run lein deps and you should be all set.



This trick also works with running leiningen projects with[ Datomic](http://datomic.com/).  In this case - download the Datomic library and from the root directory run
` mvn install:install-file -DgroupId=com.datomic -DartifactId=datomic -Dfile=datomic-0.1.3164.jar -DpomFile=pom.xml`

******* Update *******
I found out that there is already an alpha version of Clojure on Maven.  So you don't need to do the build.  [http://mvnrepository.com/artifact/org.clojure/clojure/1.5.0-alpha2](http://mvnrepository.com/artifact/org.clojure/clojure/1.5.0-alpha2)

It would simply be 
`(defproject reducers "1.0.0-SNAPSHOT"
  :description "FIXME: write description"
  :dependencies [[org.clojure/clojure "1.5.0-alpha2"]])`
