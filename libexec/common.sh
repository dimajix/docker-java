#!/bin/bash

# Improved version of envsubst which keeps unknown variables
envsubst() {
    perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' < $1 > $2
}

render_templates() {
    SRC_DIR=$1
    DST_DIR=$2

    mkdir -p $DST_DIR

    for f in $SRC_DIR/*
    do
      src_name=$f
      dst_name=$DST_DIR/$(basename $f)
      echo $src_name "=>" $dst_name
      # take action on each file. $f store current file name
      tp_render < $src_name > $dst_name
    done
}


check_java() {
    if [ $(pidof java | wc -w) -eq 0 ]; then
	    echo "ERROR: Java process not started" >> /dev/stderr
	    exit 121;
    fi

    while [ $(pidof java | wc -w) -ge 1 ]; do
	    sleep 5 || exit 0;
    done

    echo "ERROR: Java process died." >> /dev/stderr
    exit 122;
}

