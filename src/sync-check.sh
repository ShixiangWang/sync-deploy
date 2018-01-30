#!/bin/bash
# Following commands used to check working status

# Get setting info
source "$(pwd)/syn-setting"

while getopts :n:h opt
do case "$opt" in
    n) id=$OPTARG ;;
#    d) dest=$OPTARG ;;
    h)  echo
        echo "Usage: ./sync-deploy.sh -n id"
        echo "==> id: job id, if this option is not specified, it will use qstat command directly."
#		echo "Usage: ./sync-deploy.sh -n id -d dest"
#   	echo "==> id: job id, if this option is not specified, it will use id from job_id file"
#       echo "==> dest: the directory path on remote host"
		echo "==>"
		echo "==> examples:"
		echo "              ./sync-check.sh -n 87062.node1 # you can also use 87062"
		echo "         or"
		echo "              ./sync-deploy.sh"
        echo
        exit ;;
    *) echo "Unknown option: $opt"
    	echo
    	./sync-check.sh -h
        exit ;;
    esac
done

# if id is not set, use id from job_id file
if [ ! -n "$id" ]; then
#    if [ ! -n "$dest" ]; then
#        ./sync-check.sh -h
#        exit
#    fi
    #echo "use dir"
	# ssh $remote_user@$remote_ip "job_id=$(cat $dest/job_id); qstat $job_id"
    ssh $remote_user@$remote_ip "qstat"
else
    #echo "use job id"
    ssh $remote_user@$remote_ip "qstat $id"
fi
