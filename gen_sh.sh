#!/bin/sh

. $(pwd)/include.sh

sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/sh/cronlog.sh | \
	sed "s|{#\$LOG#}|$LOG|g" | \
	sed "s|{#\$TMP#}|$TMP|g" > $PREFIX/cronlog.sh

sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/sh/server.sh | \
	sed "s|{#\$NAME#}|$NAME|g" | \
	sed "s|{#\$LOG#}|$LOG|g" | \
	sed "s|{#\$USER#}|$USER|g" | \
	sed "s|{#\$TMP#}|$TMP|g" > $PREFIX/server.sh

sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/sh/nginx_fpm_check.sh | \
	sed "s|{#\$LOG#}|$LOG|g" > $PREFIX/nginx_fpm_check.sh

sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/conf/php-cgi.ini | \
	sed "s|{#\$TMP#}|$TMP|g" > $PREFIX/php-cgi/etc/php.ini

sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/conf/php-fpm.conf | \
	sed "s|{#\$USER#}|$USER|g" | \
	sed "s|{#\$LOG#}|$LOG|g" | \
	sed "s|{#\$TMP#}|$TMP|g" > $PREFIX/php-cgi/etc/php-fpm.conf

#5.3
sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/conf/php-5.3.ini | \
	sed "s|{#\$TMP#}|$TMP|g" > $PREFIX/php-5.3/etc/php.ini

sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/conf/php-fpm-5.3.conf | \
	sed "s|{#\$USER#}|$USER|g" | \
	sed "s|{#\$LOG#}|$LOG|g" | \
	sed "s|{#\$TMP#}|$TMP|g" > $PREFIX/php-5.3/etc/php-fpm.conf
#5.3

sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/conf/nginx.conf | \
	sed "s|{#\$LOG#}|$LOG|g" | \
	sed "s|{#\$USER#}|$USER|g" | \
	sed "s|{#\$TMP#}|$TMP|g" > $PREFIX/nginx/conf/nginx.conf

cp $PWD_9377/conf/vhost.conf $PREFIX/nginx/conf/vhost.conf

sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/conf/my.cnf | \
	sed "s|{#\$LOG#}|$LOG|g" | \
	sed "s|{#\$MYSQL_DATA#}|$MYSQL_DATA|g" | \
	sed "s|{#\$USER#}|$USER|g" | \
	sed "s|{#\$TMP#}|$TMP|g" > $PREFIX/mysql/my.cnf

sed "s|{#\$PREFIX#}|$PREFIX|g" $PWD_9377/sh/mysql.server | \
	sed "s|{#\$LOG#}|$LOG|g" | \
	sed "s|{#\$MYSQL_DATA#}|$MYSQL_DATA|g" | \
	sed "s|{#\$USER#}|$USER|g" | \
	sed "s|{#\$TMP}|$TMP|g" > $PREFIX/mysql/mysql.server

chmod a+x $PREFIX/mysql/mysql.server

chmod a+x $PREFIX/*.sh



crontab -l > cron.tmp
echo "*/30 * * * *		ntpdate time.windows.com" >> cron.tmp
echo "*/2 * * * *		$PREFIX/nginx_fpm_check.sh" >> cron.tmp
echo "0 0 */1 * *		$PREFIX/cronlog.sh" >> cron.tmp
crontab cron.tmp

echo "$PREFIX/server.sh" >> /etc/rc.local

mkdir -p $LOG/html && chown www:www $LOG/html
setfacl -m u:www:rwx $LOG

