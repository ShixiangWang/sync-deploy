#!/bin/bash
# run work task on remote server

while getopts :f:ht opt
do case "$opt" in
    f) fl=$OPTARG ;;
	h)  echo
		echo "Usage: ./sync-run.sh -f work_script -t"
        echo "==> work_script: script used to run on remote, must be a shell script contains qsub_header."
        echo "==>              You can use relative/absolute file path on server file system."
        echo "==> if -t option specified, the command will run as batch mode, it usually called by sync-deploy.sh script."
        echo "==>"
        echo "==> examples:"
        echo "              ./sync-run.sh -f work.sh         # this is regular mode, basically you wanna this if you run this script independently"
        echo "         or"
        echo "              ./sync-run.sh -n work.sh -t      # this is batch mode, basically used to be called by sync-deploy.sh script"
        echo "                                               # it will additionally generate a job_id file in the same directory as work_script"
        echo
        exit ;;
    t)  batch="y" ;;
	*) echo "Unknown option: $opt"
		echo
		./sync-run.sh -h
        exit ;;
	esac
done

# Get setting info
source "$(pwd)/syn-setting"

# if variable port is not set, set 22 as default
if [ ! -n "$port" ]; then
	port=22
fi

if [ ! -n "$batch" ]; then
    batch="n"
fi
# you can also use absolute path
if [ $batch == "y" ]; then
    echo "==> run as batch mode......."
    ssh -p $port $remote_user@$remote_ip "qsub $fl > $(dirname $fl)/job_id; echo 'job_id file locate at $(dirname $fl)/job_id , id is'; cat $(dirname $fl)/job_id"
else
    echo "==> run as regular mode......."
    ssh -p $port $remote_user@$remote_ip "qsub $fl"
fi
#ssh -p 22 liuxs@10.15.22.110 "qsub ~/test/work.sh"
