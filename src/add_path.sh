#!/usr/bin/env bash
# add sync-deploy path to bash configure file according to OS

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#---- Option Setting
while getopts :d:h opt
do case "$opt" in
	d) dest_rc=$OPTARG ;;
	h)  echo
		echo "Usage: add_path.sh -d bashrc_path"
        echo "bashrc_path: the path you set environment path for system"
		echo ">>> examples:"
		echo "              add_path.sh -d ~/.zshrc"
        echo
        exit ;;
	*) echo "Unknown option: $opt"
		echo
		$DIR/add_path.sh -h
        exit ;;
	esac
done

# if dest bashrc path is not set 
if [ ! -n "$dest_rc" ]; then
    echo "bash configure file not specified"
    echo "add sync-deploy toolkit to default configure file based on system..."
    echo 
    if [ "$(uname)" == "Darwin" ]; then
        # Do something under Mac OS X platform 
        os_rc=~/.bash_profile
    else
        os_rc=~/.bashrc   
    fi
else
    os_rc=$dest_rc
fi

echo "path of sync-deploy tookit will be add to file $os_rc ..."
echo

echo "# add path for sync-deploy tool" >> $os_rc
echo 'export' PATH=\""$DIR:\$PATH"\" >> $os_rc
source $os_rc

echo "done."
echo 
echo ">>> You can use sync-deploy tool everywhere now."
echo ">>> You can run source $os_rc by hand if you cannot find the toolkit."
echo ">>> Enjoy."
exit
