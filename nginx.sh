#!/bin/sh

. $(pwd)/include.sh

pcre="8.39"
zlib="1.2.7"
openssl="1.0.1h"
nginx="1.4.7"

#pcre
files=()
files=(${files[@]} "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-$pcre.tar.gz")
files=(${files[@]} "http://www.openssl.org/source/openssl-$openssl.tar.gz")
files=(${files[@]} "http://ncu.dl.sourceforge.net/project/libpng/zlib/$zlib/zlib-$zlib.tar.gz")
files=(${files[@]} "http://nginx.org/download/nginx-$nginx.tar.gz")
libs=$( download files[@] )

cd $DOWNLOAD/nginx-$nginx
./configure --prefix=$PREFIX/nginx --user=$USER --group=$USER \
	--with-pcre=$DOWNLOAD/pcre-$pcre \
	--with-openssl=$DOWNLOAD/openssl-$openssl \
	--with-zlib=$DOWNLOAD/zlib-$zlib \
	--with-http_sub_module \
	--with-http_stub_status_module --with-http_ssl_module > $DOWNLOAD/nginx.log

make >> $DOWNLOAD/nginx.log
make install >> $DOWNLOAD/nginx.log
cd $PWD

ln $PREFIX/nginx/sbin/nginx /sbin/nginx -sf
