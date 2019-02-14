#!/bin/sh

PREFIX={#$PREFIX#}
LOG={#$LOG#}

#0 0 */1 * * {#$PREFIX#}/cronlog.sh


path=$LOG/$(date -d "yesterday" +"%Y/%m-%d")
! [ -d $path ] && mkdir -p $path

mv $LOG/*.log $path

path=$LOG/html/$(date -d "yesterday" +"%Y/%m-%d")
! [ -d $path ] && mkdir -p $path
mv $LOG/html/*.log $path/$_file

$PREFIX/nginx/sbin/nginx -s reload
$PREFIX/php-5.3/fpm reload
