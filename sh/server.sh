#!/bin/bash

PREFIX={#$PREFIX#}
NAME={#$NAME#}
LOG={#$LOG#}
TMP={#$TMP#}
USER={#$USER#}
LOG={#$LOG#}
MONGO_PATH={#$MONGO_PATH#}

if [ "$1" == 'stop' ]; then
	
	$PREFIX/php-5.3/fpm stop
	#$PREFIX/mysql/mysql.server stop
	$PREFIX/nginx/sbin/nginx -s stop
	#kill -TERM `cat /tmp/memcache.pid`
	#kill -TERM $(cat /ttserver/ttserver.pid)
	#$PREFIX/apache/bin/apachectl -k stop
	
elif [ "$1" == 'netstat' ]; then
	
	netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
	
elif [ "$1" == 'restart' ]; then
	
	$0 stop
	$0 start
	
elif [ "$1" == 'reload' ]; then
	
	$PREFIX/php-5.3/fpm reload
	#$PREFIX/mysql/mysql.server reload
	$PREFIX/nginx/sbin/nginx -s reload
	#$PREFIX/apache/bin/apachectl -k graceful
	
else
	
	! [ -d $TMP ] && mkdir $TMP $TMP/{php_session,eaccelerator,eaccelerator-5.3,php_upload} && chown $USER:$USER -R $TMP
	
	! [ -d $LOG ] && mkdir -p $LOG
	! [ -d /dev/shm/$NAME ] && mkdir -p /dev/shm/$NAME
	mkdir -p /dev/shm/{ad_logs,click_logs,logs,php-cgi,rich_logs,tmp_logs}
	
	#$PREFIX/memcache/bin/memcached -d -u nobody -t 8 -c 65535 -m 64 -P /tmp/memcache.pid
	
	#$PREFIX/redis/bin/redis-server $PREFIX/redis/redis.conf
	
	$PREFIX/php-5.3/fpm start
	
	$PREFIX/nginx/sbin/nginx
	
	#echo "Starting apache " -n
	#$PREFIX/apache/bin/apachectl -k start
	#echo "done"
	
	#$PREFIX/mysql/mysql.server start
	
	
fi

mkdir -p /dev/shm/ad_logs
chown -R www:www /dev/shm/ad_logs
