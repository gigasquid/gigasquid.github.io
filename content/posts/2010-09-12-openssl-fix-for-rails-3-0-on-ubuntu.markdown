---
date: 2010-09-12T14:11:14+00:00
title: Openssl fix for Rails 3.0 on Ubuntu
categories:
- Ruby
tags:
- rails
- Ruby
- ubuntu
---

If you are trying to run ruby rvm and rails 3.0 on Ubuntu you might run into this problem when you start up you server.

    
    LoadError: no such file to load
    -- openssl
    


After much googling and researching – just installing the openssl library on your system won't fix the problem.  You need to recompile and install your rvm ruby version with the openssl.  I found this fixed it for me.

    
    rvm install 1.9.2-p0 -C --with-openssl-dir=$rvm_path/usr
    


There is also another solution
[ here so you don't have to recompile every time](http://cjohansen.no/en/ruby/ruby_version_manager_ubuntu_and_openssl)
