#!/bin/sh

yum -y update

yum -y install wget nc telnet gcc gcc-c++ autoconf cmake bison libevent libevent-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers libpcap libpcap-devel libtool iptables rsync file perl* perl-devel sysstat mailx ntpdate vim jwhois bind-utils git ipset tcpdump libxml2 libxml2-devel openssl-devel curl curl-devel  libjpeg-devel openldap-devel

cd $DOWNLOAD
if ! [ -f $DOWNLOAD/iftop-0.17.tar.gz ]; then
	wget --directory-prefix=$DOWNLOAD http://www.ex-parrot.com/pdw/iftop/download/iftop-0.17.tar.gz
	tar -zxf iftop-0.17.tar.gz
fi

whereis iftop
if [ $? -ne 0 ]; then
	cd $DOWNLOAD/iftop-0.17
	./configure && make && make install
fi