#!/bin/sh

. $(pwd)/include.sh

if ! [ -f $DOWNLOAD/jdk-8u31-linux-x64.tar.gz ]; then
	wget 'http://download.oracle.com/otn-pub/java/jdk/8u31-b13/jdk-8u31-linux-x64.tar.gz' --header='Cookie: s_cc=true; oraclelicense=accept-securebackup-cookie; s_nr=1422338535659; gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjdk8-downloads-2133151.html; s_sq=%5B%5BB%5D%5D' --directory-prefix=$DOWNLOAD --no-check-certificate
fi

#rpm -ivh jdk-8u31-linux-x64.rpm
cd $DOWNLOAD
mv jdk-8u31-linux-x64.tar.gz* jdk-8u31-linux-x64.tar.gz
tar -zxf jdk-8u31-linux-x64.tar.gz
mv jdk1.8.0_31/ $PREFIX/java

cat <<EOD >> /etc/profile

export JAVA_HOME=$PREFIX/java
export JRE_HOME=\$JAVA_HOME/jre
export CLASSPATH=.:\$CLASSPATH:\$JAVA_HOME/lib:\$JRE_HOME/lib
export PATH=\$PATH:\$JAVA_HOME/bin:\$JRE_HOME/bin:$HADOOP_PREFIX/bin
EOD

source /etc/profile
