#!/bin/sh
set -eu

FORMATS=/formats
BINFMT_FS=/proc/sys/fs/binfmt_misc

# enable binfmt
function binfmt_is_mounted {
     mount | grep -q ${BINFMT_FS}
}

function mount_binfmt {
    if ! binfmt_is_mounted; then
        mount binfmt_misc -t binfmt_misc ${BINFMT_FS}
    fi
}

function enable_binfmt {
    echo 1 > ${BINFMT_FS}/status
}

# enable/disable a single format
function enable_format {
    echo -n enabling $1 ...
    if [ ! -f ${BINFMT_FS}/$1 ]; then
        cat ${FORMATS}/$1 > ${BINFMT_FS}/register
        echo
    else
        echo " skipping"
    fi
}

function disable_format {
    echo -n disabling $1 ...
    file=${BINFMT_FS}/$1
    if [ -f $file ]; then
        echo -1 > $file
        echo
    else
        echo " skipping"
    fi
}

# enabling/disabling all formats
function enable_all_formats {
    for format in $(ls ${FORMATS}); do
        enable_format ${format}
    done
}

function disable_all_formats {
    for format in $(ls ${FORMATS}); do
        disable_format ${format}
    done
}

# CLI
case $@ in
enable)
    mount_binfmt
    enable_binfmt
    enable_all_formats
    ;;
disable)
    mount_binfmt
    disable_all_formats
    ;;
*)
    echo "usage: enable | disable"
    exit 1
esac
