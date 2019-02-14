#!/bin/sh

NAME=9377_serv
PWD_9377=$(pwd)
PREFIX=/opt/$NAME
LIB=/opt/$NAME/lib
DOWNLOAD=$PWD_9377/download
LOG=/var/$NAME/log
WWW=/www
USER=www
TMP=/tmp/$NAME
MYSQL_DATA=/data/$NAME/mysql
MONGO_PATH=/data1/mongo



download(){
	local files=("${!1}")
	ret=()
	
	for file in ${files[@]}; do
		base=$(basename $file)

		tmp=${base##*\?}
		base=$(basename $base "?$tmp")
		dfile=$DOWNLOAD/$base
		if ! [ -s $dfile ]; then
			wget "$file" --directory-prefix=$DOWNLOAD --no-check-certificate
			if ! [ -s $dfile ]; then
				echo "Downloading $file failed!!!"
				exit 0
			fi
		fi
		
		cd $DOWNLOAD
		local path=$DOWNLOAD/$(basename $base .tar.gz)
		rm -rf $path
		tar -zxf $dfile
		
		ret=(${ret[@]} $path)
	done

	#return
	echo ${ret[@]}
}
