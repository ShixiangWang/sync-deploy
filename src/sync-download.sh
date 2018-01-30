#!/bin/bash
#
# Download files to server by scp command

# Get setting info
source "$(pwd)/syn-setting"

while getopts :n:d:h opt
#while getopts :P:h opt
do case "$opt" in
	n) remote="" ;;
	d) dest="" ;;
#	P) port=$OPTARG ;;
	h)  echo
		echo "Usage: ./sync-download.sh -n 'remote_files' -d localdir"
        echo "==> remote_files: files you wanna download, can be directories or filenames"
        echo "==> localdir: The only one directory you wanna transfer to."
		echo "==>          Do not set more than one destdir, error will occur."
		echo "==>  	Please do note the 'remote_files' must be quoted otherwise you use absolute file path!!!"
		echo "==>"
		echo "==> examples:"
		echo "              ./sync-download.sh -n '~/test/*' -d ./test"
		echo "         or"
		echo "              ./sync-download.sh -n /public/home/liuxs/test/* -d ./test"
#        echo "==> port: ssh port, default is 22"
        echo
        exit ;;
	*) echo "Unknown option: $opt"
		echo
		./sync-download.sh -h
        exit ;;
	esac
done

#echo all variables  $*

remote=$(echo "$*" | sed -E 's/-n (.*) -d (.*)$/\1/')
dest=$(echo "$*" | sed -E 's/-n (.*) -d (.*)$/\2/')

# if variable name is not set, show help info
if [ ! -n "$remote" ]; then
	./sync-download.sh -h
	exit
fi

# if variable dir is not set, show help info
if [ ! -n "$dest" ]; then
	./sync-download.sh -h
	exit
fi

# if variable port is not set, set 22 as default
if [ ! -n "$port" ]; then
	port=22
fi

#echo all variables are $*
#echo $#
#echo $@

echo "==> command used: scp -pr -P $port $remote_user@$remote_ip:$remote $dest"
echo "==>"
scp -pr -P $port $remote_user@$remote_ip:$remote $dest


echo "==> Files download successfully."
echo
