#!/bin/sh


#iptables, 80 port
#crontab, 
#ssh keys

. $(pwd)/include.sh


$PWD_9377/centos6-lib.sh






files=()
files=(${files[@]} "ftp://mcrypt.hellug.gr/pub/crypto/mcrypt/libmcrypt/libmcrypt-2.5.7.tar.gz")
files=(${files[@]} "http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.14.tar.gz")
files=(${files[@]} "https://launchpad.net/libmemcached/1.0/1.0.18/+download/libmemcached-1.0.18.tar.gz")
#files=(${files[@]} "ftp://xmlsoft.org/libxml2/libxml2-2.7.8.tar.gz")
libs=$( download files[@] )

for lib in ${libs[@]}; do
	cd $lib
	name=$(basename $lib)
	echo "configuring $name"
	./configure > $DOWNLOAD/$name.log
	[ $? -ne 0 ] && echo -e "-------------------\n configure $name fail" && exit 1
	make >> $DOWNLOAD/$name.log
	[ $? -ne 0 ] && echo -e "-------------------\n make $name fail" && exit 1
	make install >> $DOWNLOAD/$name.log
	[ $? -ne 0 ] && echo -e "-------------------\n install $name fail" && exit 1
	cd $PWD_9377
done

#mcrypt
cd $DOWNLOAD/libmcrypt-2.5.7/libltdl
./configure --enable-ltdl-install > /dev/null
echo "configuring libltdl"
make > /dev/null
make install > /dev/null
cd $PWD_9377



#nginx
$PWD_9377/nginx.sh

cd $PWD_9377






f=(/usr/lib64/libldap*)
for l in "${f[@]}"; do
	ln -sf $l /usr/lib/$(basename $l)
done


PHP_VERSION=php-5.3.26

file="http://museum.php.net/php5/$PHP_VERSION.tar.gz"
if ! [ -s "$DOWNLOAD/$PHP_VERSION.tar.gz" ]; then
	wget $file --directory-prefix=$DOWNLOAD
	if ! [ -s "$DOWNLOAD/$PHP_VERSION.tar.gz" ]; then
		echo "Downloading $file failed!!!"
		exit
	fi
fi

cd $DOWNLOAD
tar -zxf $DOWNLOAD/$PHP_VERSION.tar.gz

PHP_SRC_PATH=$DOWNLOAD/$PHP_VERSION
PHP_PATH=$PREFIX/php-5.3

rm -rf $PHP_SRC_PATH

cd $DOWNLOAD
tar -zxf $DOWNLOAD/$PHP_VERSION.tar.gz

cd $PHP_SRC_PATH
#sed -i 's/"-lgd  $LIBS"/"-lgd -liconv $LIBS"/g' configure
./configure --prefix=$PHP_PATH \
	--with-config-file-path=$PHP_PATH/etc \
	--enable-fastcgi --enable-fpm \
	--with-mysql=mysqlnd \
	--with-mysqli=mysqlnd \
	--enable-pdo --with-pdo-mysql=mysqlnd \
	--with-iconv \
	--with-iconv-dir \
	--with-zlib-dir \
	--with-mcrypt \
	--with-openssl \
	--with-openssl-dir \
	--with-gd \
	--with-freetype-dir \
	--with-jpeg-dir \
	--with-png-dir \
	--with-curl \
	--with-curlwrappers \
	--with-libxml-dir=/usr \
	--with-ldap --with-ldap-sasl \
	--enable-bcmath \
	--enable-soap \
	--enable-ftp \
	--enable-force-cgi-redirect \
	--enable-mbstring --enable-zip \
	--enable-sysvsem --enable-inline-optimization \
	--enable-pcntl --enable-bcmath \
	--disable-debug --disable-rpath --enable-sockets --quiet
	#--with-apxs2=$PREFIX/apache/bin/apxs
[ "$?" -ne 0 ] && echo 'configuring php failed' && exit
make ZEND_EXTRA_LIBS='-liconv' --quiet
make install

cp sapi/fpm/init.d.php-fpm $PHP_PATH/fpm
chmod a+x $PHP_PATH/fpm
ln -sf $PHP_PATH/bin/php /bin/php

cd $DOWNLOAD
#eaccelerator
file="http://downloads.sourceforge.net/project/eaccelerator/eaccelerator/eAccelerator%200.9.6.1/eaccelerator-0.9.6.1.tar.bz2"
if ! [ -s $DOWNLOAD/eaccelerator-0.9.6.1.tar.bz2 ]; then
	wget $file --directory-prefix=$DOWNLOAD
	if ! [ -s $DOWNLOAD/eaccelerator-0.9.6.1.tar.bz2 ]; then
		echo "Downloading $file failed!!!"
		exit
	fi
fi

rm -rf $DOWNLOAD/eaccelerator-0.9.6.1
tar -jxf $DOWNLOAD/eaccelerator-0.9.6.1.tar.bz2

cd $DOWNLOAD/eaccelerator-0.9.6.1
$PHP_PATH/bin/phpize
./configure --with-php-config=$PHP_PATH/bin/php-config --enable-eaccelerator=shared --without-eaccelerator-use-inode
make > /dev/null
make install > /dev/null


#memcache
cd $DOWNLOAD
file=http://pecl.php.net/get/memcache-2.2.7.tgz
if ! [ -s $DOWNLOAD/memcache-2.2.7.tgz ]; then
	wget $file --directory-prefix=$DOWNLOAD
	if ! [ -s $DOWNLOAD/memcache-2.2.7.tgz ]; then
		echo "Downloading $file failed!!!"
		exit
	fi
fi

rm -rf $DOWNLOAD/memcache-2.2.7
tar -zxf $DOWNLOAD/memcache-2.2.7.tgz

cd $DOWNLOAD/memcache-2.2.7
$PHP_PATH/bin/phpize
./configure --with-php-config=$PHP_PATH/bin/php-config
make > /dev/null
make install > /dev/null


#memcached
cd $DOWNLOAD
file=http://pecl.php.net/get/memcached-2.2.0.tgz
if ! [ -s $DOWNLOAD/memcached-2.2.0.tgz ]; then
	wget $file --directory-prefix=$DOWNLOAD
	if ! [ -s $DOWNLOAD/memcached-2.2.0.tgz ]; then
		echo "Downloading $file failed!!!"
		exit
	fi
fi

rm -rf $DOWNLOAD/memcached-2.2.0
tar -zxf $DOWNLOAD/memcached-2.2.0.tgz

cd $DOWNLOAD/memcached-2.2.0
$PHP_PATH/bin/phpize
./configure --with-php-config=$PHP_PATH/bin/php-config --disable-memcached-sasl --with-libmemcached-dir=/usr/local
make > /dev/null
make install > /dev/null


#redis
cd $DOWNLOAD/
wget http://pecl.php.net/get/redis-2.2.7.tgz
tar -zxf $DOWNLOAD/redis-2.2.7.tgz
#git clone https://github.com/nicolasff/phpredis.git
cd $DOWNLOAD/redis-2.2.7
$PHP_PATH/bin/phpize
./configure --with-php-config=$PHP_PATH/bin/php-config
make > /dev/null
make install > /dev/null



ln $PHP_PATH/fpm /sbin/fpm -sf

useradd www
mkdir /www
chown www:www /www

cd $PWD_9377

. $PWD_9377/nginx.sh

cd $PWD_9377
. $PWD_9377/env.sh

cd $PWD_9377
. $PWD_9377/gen_sh.sh
