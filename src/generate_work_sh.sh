#！/bin/bash
# Generate work script used to deploy on remote host
# Get setting info

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# if work script not specified, use work.sh as default
if [ ! -n "$1" ]; then
    cat $DIR/qsub_header $DIR/commands > $DIR/work.sh
    chmod u+x $DIR/work.sh
    out="work.sh"
else
    cat $DIR/qsub_header $DIR/commands > $DIR/$1
    chmod u+x $DIR/$1
    out="$1"
fi

#echo $out

#cat qsub_header commands > work.sh
#chmod u+x work.sh
#./upload.sh -n work.sh ./test/test.R -d "~/test"
