#!/bin/sh

. $(pwd)/include.sh

path=mysql

useradd mysql

VER="mariadb-10.1.23"

rm -rf $DOWNLOAD/$VER

files=()
#files=(${files[@]} "http://www.cmake.org/files/v2.8/cmake-2.8.6.tar.gz")
files=(${files[@]} "https://downloads.mariadb.com/MariaDB/$VER/source/$VER.tar.gz")
#files=(${files[@]} "http://downloads.mysql.com/archives/mysql-5.5/mysql-5.5.15.tar.gz")
download files[@]

#cd $DOWNLOAD/cmake-2.8.6
#./configure --prefix=$PREFIX/cmake > $DOWNLOAD/cmake.log
#make >> $DOWNLOAD/cmake.log
#make install >> $DOWNLOAD/cmake.log

yum install -y libaio libaio-devel

if ! [ -f $DOWNLOAD/jemalloc-3.6.0.tar.bz2 ]; then
	wget http://www.canonware.com/download/jemalloc/jemalloc-3.6.0.tar.bz2 --directory-prefix=$DOWNLOAD --no-check-certificate
fi
cd $DOWNLOAD
rm -rf jemalloc-3.6.0
tar -jxf jemalloc-3.6.0.tar.bz2
cd jemalloc-3.6.0
./configure --prefix=/usr >> jemalloc.log
make >> jemalloc.log
make install >> jemalloc.log
ldconfig



cd $DOWNLOAD/$VER
#$PREFIX/cmake/bin/
cmake \
	-DCMAKE_BUILD_TYPE=RelWithDebInfo \
	-DBUILD_CONFIG=mysql_release \
	-DFEATURE_SET=community \
	-DWITH_EMBEDDED_SERVER=OFF \
	-DCMAKE_INSTALL_PREFIX:PATH=$PREFIX/$path \
	-DDEFAULT_CHARSET=utf8 \
	-DWITH_EXTRA_CHARSETS:STRING=complex \
	-DDEFAULT_COLLATION=utf8_general_ci \
	-DWITH_MYISAM_STORAGE_ENGINE=1 \
	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
	-DWITH_MEMORY_STORAGE_ENGINE=1 \
	-DWITH_READLINE=1 \
	-DENABLED_LOCAL_INFILE=1 \
	-DCMAKE_EXE_LINKER_FLAGS="-ljemalloc" \
	-DWITH_SAFEMALLOC=OFF \
	-DWITH_MARIABACKUP=OFF \
	-DMYSQL_USER=mysql > $DOWNLOAD/mysql.log

#-DWITH_ZLIB:FILEPATH=$LIB \
#-DCURSES_NCURSES_LIBRARY:FILEPATH=$LIB/lib/libncurses.a \
make >> $DOWNLOAD/mysql.log
make install >> $DOWNLOAD/mysql.log


#cd $DOWNLOAD/mysql-5.5.15
#$PREFIX/cmake/bin/cmake \
#	-DCMAKE_INSTALL_PREFIX:PATH=$PREFIX/mysql \
#	-DDEFAULT_CHARSET=gbk \
#	-DWITH_EXTRA_CHARSETS:STRING=complex \
#	-DDEFAULT_COLLATION=gbk_chinese_ci \
#	-DWITH_MYISAM_STORAGE_ENGINE=1 \
#	-DWITH_INNOBASE_STORAGE_ENGINE=1 \
#	-DWITH_ZLIB:FILEPATH=$LIB \
#	-DWITH_READLINE=1 \
#	-DCURSES_NCURSES_LIBRARY:FILEPATH=$LIB/lib/libncurses.a \
#	-DENABLED_LOCAL_INFILE=1 > $DOWNLOAD/mysql.log
#make >> $DOWNLOAD/mysql.log
#make install >> $DOWNLOAD/mysql.log


cd $DOWNLOAD/$VER/storage/HandlerSocket-Plugin-for-MySQL/
./autogen.sh
./configure --with-mysql-source=../.. --with-mysql-bindir=$PREFIX/$path/bin
make
make install

$PREFIX/$path/scripts/mysql_install_db --basedir=$PREFIX/$path --user=mysql --datadir=$MYSQL_DATA/data

cp support-files/mysql.server $PREFIX/$path/mysql.server

chmod a+x $PREFIX/$path/mysql.server
mkdir $MYSQL_DATA/{relaylog,binlog}
chown mysql:mysql $MYSQL_DATA/{relaylog,binlog}

#get the fuck off
rm -f /etc/my.cnf

cat <<EOD >> /etc/profile

export PATH=\$PATH:$PREFIX/$path/bin
EOD

#$PREFIX/mysql/bin/mysqladmin -u root password '(#@yOu!kn0w@It*)'
