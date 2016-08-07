#!/usr/bin/env bash

# restore configure files
NVIDIA_CONF=/etc/ld.so.conf.d/nvidia.conf

if [ -f $NVIDIA_CONF ]; then
    mv $NVIDIA_CONF ~
fi

ldconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp -f $DIR/99-nvidia.conf  /etc/X11/xorg.conf.d/99-nvidia.conf
cp -f $DIR/bumblebee.conf  /etc/bumblebee/bumblebee.conf