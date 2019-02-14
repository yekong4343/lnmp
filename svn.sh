#!/bin/sh

. $(pwd)/include.sh


files=()
files=(${file[@]} "http://apache.etoak.com/httpd/httpd-2.2.23.tar.gz")
files=(${file[@]} "http://labs.renren.com/apache-mirror/subversion/subversion-1.7.1.tar.gz")
items=$( download files[@] )

for item in ${items[@]}
do
	cd $DOWNLOAD/httpd-2.2.21
	./configure --prefix=$PREFIX/apache \
		--enable-so --enable-rewrite --enable-dav \
		--with-z=$LIB --enable-deflate \
		--with-ssl=$LIB --enable-ssl
	make
	make install
	
	cd $DOWNLOAD/subversion-1.7.1
	#sqlite
	#neon
	./configure  --with-apxs=$PREFIX/apache/bin/apxs \
		--prefix=$PREFIX/svn \
		--with-apr=$PREFIX/apache \
		--with-apr-util=$PREFIX/apache \
		--with-zlib=$PREFIX/lib \
		--with-ssl
	make
	make install
done