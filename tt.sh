#!/bin/sh

. $(pwd)/include.sh

useradd ttserver

files=()
files=(${files[@]} "http://www.lua.org/ftp/lua-5.1.4.tar.gz")
files=(${files[@]} "http://fallabs.com/tokyocabinet/tokyocabinet-1.4.47.tar.gz")
files=(${files[@]} "http://fallabs.com/tokyotyrant/tokyotyrant-1.1.41.tar.gz")
libs=$( download files[@] )

#readline, readline-devel
cd $DOWNLOAD/lua-5.1.4
make linux >> $DOWNLOAD/lua.log
make install >> $DOWNLOAD/lua.log


cd $DOWNLOAD/tokyocabinet-1.4.47
./configure --prefix=$PREFIX/tokyocabinet > $DOWNLOAD/tc.log
make >> $DOWNLOAD/tc.log
make install >> $DOWNLOAD/tc.log


cd $DOWNLOAD/tokyotyrant-1.1.41
./configure --prefix=$PREFIX/tokyotyrant \
	--with-tc=$PREFIX/tokyocabinet --with-zlib=$LIB --with-lua > $DOWNLOAD/tt.log
make >> $DOWNLOAD/tt.log
make install >> $DOWNLOAD/tt.log


mkdir /data1/ttserver/ -p && chown ttserver:ttserver /data1/ttserver/