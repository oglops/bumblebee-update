#!/usr/bin/env bash

# http://unix.stackexchange.com/questions/122681/how-can-i-tell-whether-a-package-is-installed-via-yum-in-a-bash-script
function isinstalled {
  if yum list installed "$@" >/dev/null 2>&1; then
    true
  else
    false
  fi
}

PACKAGE=kmod-nvidia

# uninstall old kmod-nvidia
if isinstalled $PACKAGE; then 
	yum remove kmod-nvidia -y 
fi


# install specified kmod-nvidia
array=( $(repoquery kmod-nvidia --show-duplicates) )

PS3="Please enter your choice: "
select answer in "${array[@]}"; do
	if [ ! -z "$answer" ]; then
  		echo "you selected $answer"
		break
	fi
done

yum install -y $answer



# reinstall bumblebee or you won't be able to login to x
yum reinstall bumblebee bumblebee-selinux -y

# Xlib:  extension "GLX" missing on display ":0.0".
yum reinstall mesa-libGL  mesa-dri-drivers -y

# restore configure files
NVIDIA_CONF=/etc/ld.so.conf.d/nvidia.conf

if [ -f $NVIDIA_CONF ]; then
    mv $NVIDIA_CONF ~
fi

ldconfig

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cp -f $DIR/99-nvidia.conf  /etc/X11/xorg.conf.d/99-nvidia.conf
cp -f $DIR/bumblebee.conf  /etc/bumblebee/bumblebee.conf

# you should reboot now