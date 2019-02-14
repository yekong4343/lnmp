#!/bin/sh

. $(pwd)/include.sh

files=()
files=(${files[@]} "http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz")
files=(${files[@]} "http://downloads.sourceforge.net/project/boost/boost/1.49.0/boost_1_49_0.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fboost%2Ffiles%2Fboost%2F1.49.0%2F&ts=1334381960&use_mirror=nchc")
libs=$( download files[@] )

cd $DOWNLOAD/inotify-tools-3.14
./configure --prefix=$PREFIX/inotify > $DOWNLOAD/inotify.log

make >> $DOWNLOAD/inotify.log
make install >> $DOWNLOAD/inotify.log
cd $PWD