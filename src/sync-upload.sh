#!/bin/bash
#
# Upload files to server by scp command

# Get setting info
source "$(pwd)/syn-setting"

while getopts :n:d:h opt
#while getopts :P:h opt
do case "$opt" in
	n) local="" ;;
	d) dest="" ;;
#	P) port=$OPTARG ;;
	h)  echo
		echo "Usage: ./sync-upload.sh -n local_files -d 'destdir'"
        echo "==> local_files: files you wanna upload, can be directories or filenames"
        echo "==> destdir: The only one directory you wanna transfer to."
		echo "==>          Do not set more than one destdir, error will occur."
		echo "==>  	Please do note the 'destdir' must be quoted otherwise you use absolute file path!!!"
		echo "==>"
		echo "==> examples:"
		echo "              ./sync-upload.sh -n work.sh -d /public/home/liuxs/test"
		echo "         or"
		echo "              ./sync-upload.sh -n work.sh -d '~/test'"
#        echo "==> port: ssh port, default is 22"
        echo
        exit ;;
	*) echo "Unknown option: $opt"
		echo
		./sync-upload.sh -h
        exit ;;
	esac
done

#echo all variables  $*

local=$(echo "$*" | sed -E 's/-n (.*) -d (.*)$/\1/')
dest=$(echo "$*" | sed -E 's/-n (.*) -d (.*)$/\2/')

# if variable name is not set, show help info
if [ ! -n "$local" ]; then
	./sync-upload.sh -h
	exit
fi

# if variable dir is not set, show help info
if [ ! -n "$dest" ]; then
	./sync-upload.sh -h
	exit
fi

# if variable port is not set, set 22 as default
if [ ! -n "$port" ]; then
	port=22
fi

#echo all variables are $*
#echo $#
#echo $@
#echo "local variable is $local"
#echo "dest variable is $dest"


echo "==> command used: scp -pr -P $port $local $remote_user@$remote_ip:$dest"
echo "==>"
scp -pr -P $port $local $remote_user@$remote_ip:$dest


echo "==> Files upload successfully."
echo
