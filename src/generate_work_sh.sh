#！/bin/bash
# Generate work script used to deploy on remote host
# Get setting info

# if work script not specified, use work.sh as default
if [ ! -n "$1" ]; then
    cat qsub_header commands > work.sh
    chmod u+x work.sh
    out="work.sh"
else
    cat qsub_header commands > $1
    chmod u+x $1
    out="$1"
fi

#echo $out

#cat qsub_header commands > work.sh
#chmod u+x work.sh
#./upload.sh -n work.sh ./test/test.R -d "~/test"
