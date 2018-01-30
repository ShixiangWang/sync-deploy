#!/bin/bash
# Main script deploy work on server


# Get setting info
source "$(pwd)/syn-setting"

while getopts :n:d:h opt
do case "$opt" in
	n) local="" ;;
	d) dest="" ;;
	h)  echo
		echo "Usage: ./sync-deploy.sh -n local_files -d 'destdir'"
		echo "==> local_files: files you wanna upload, can be directories or filenames"
		echo "==> destdir: The only one directory you wanna transfer to."
		echo "==>          Do not set more than one destdir, error will occur."
		echo "==>  	Please do note the 'destdir' must be quoted otherwise you use absolute file path!!!"
		echo "==>"
		echo "==> examples:"
		echo "              ./sync-deploy.sh -n work.sh -d /public/home/liuxs/test"
		echo "         or"
		echo "              ./sync-deploy.sh -n work.sh -d '~/test'"
        echo
        exit ;;
	*) echo "Unknown option: $opt"
		echo
		./sync-deploy.sh -h
        exit ;;
	esac
done

#echo all variables  $*

local=$(echo "$*" | sed -E 's/-n (.*) -d (.*)$/\1/')
dest=$(echo "$*" | sed -E 's/-n (.*) -d (.*)$/\2/')

# if variable name is not set, show help info
if [ ! -n "$local" ]; then
	./sync-deploy.sh -h
	exit
fi

# if variable dir is not set, show help info
if [ ! -n "$dest" ]; then
	./sync-deploy.sh -h
	exit
fi

# if variable port is not set, set 22 as default
if [ ! -n "$port" ]; then
	port=22
fi

# 1. generate work script
./generate_work_sh.sh

# 2. upload files to server
./sync-upload.sh -n $local ./work.sh -d $dest

# 3. run task on remote server
./sync-run.sh -f $dest/work.sh -t # -f Following file path on remote server

#ssh -p $port $remote_user@$remote_ip "qstat $job_id" | awk  '$1 ~/'$job_id'/ {print $5}'
sleep 0.3
echo "==>"
echo "==> The work deploy successfully."
echo "==> You can use sync-check.sh script to check the working status."
echo "==>     more info, run   ./sync-check -h"
echo "==> bye"
echo
# done
