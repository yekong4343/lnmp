#!/bin/sh

. $(pwd)/include.sh

yum install -y ruby ruby-devel rubygems rubygems-devel
gem install redis
