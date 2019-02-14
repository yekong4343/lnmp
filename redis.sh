#!/bin/sh

. $(pwd)/include.sh

useradd redis

NAME=redis-3.0.5
files=()
files=(${files[@]} "http://download.redis.io/releases/$NAME.tar.gz")
libs=$( download files[@] )

cd $DOWNLOAD/$NAME
make
make PREFIX=$PREFIX/redis install


mkdir -p /data1/redis/ -p && chown redis:redis /data1/redis/
touch $LOG/redis.log
chown redis:redis $LOG/redis.log

cp $PWD_9377/conf/redis.conf $PREFIX/redis/
