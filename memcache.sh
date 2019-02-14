#!/bin/sh

. $(pwd)/include.sh

files=()
files=(${files[@]} "http://memcached.googlecode.com/files/memcached-1.4.13.tar.gz")
libs=$( download files[@] )
for lib in ${libs[@]}; do
	cd $lib
	./configure --prefix=$PREFIX/memcache --with-libevent=$LIB > $DOWNLOAD/memcache.log
	make >> $DOWNLOAD/memcache.log
	make install >> $DOWNLOAD/memcache.log
	cd $PWD
done




#redis
useradd redis
ver="redis-2.8.13"
files=()
files=(${files[@]} "http://download.redis.io/releases/$ver.tar.gz")
download files[@]

cd $ver
make >/dev/null
make PREFIX=$PREFIX/redis install
