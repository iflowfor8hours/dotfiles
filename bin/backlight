#!/bin/bash

# Vadim Zaliva lord@crocodile.org
# based on https://gist.github.com/hadess/6847281

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


usage() {
   echo "This script controll keyboard backlight on IBM ThinkPad X-series"
   echo "Usage: ThinkLight [0|1|2]"
   echo "   0 - off"
   echo "   1 - medium"
   echo "   2 - full"
}

if [ "$#" -ne 1 ];then
   usage
   exit 1
fi

case "$1" in
        0)
            b="\x03"
            ;;
        1)
            b="\x43"
            ;;
        2)
            b="\x83"
            ;;
        *)
            usage
            exit 1
esac


sudo modprobe -r ec_sys
sudo modprobe ec_sys write_support=1

echo -n -e "$b" | sudo dd of="/sys/kernel/debug/ec/ec0/io" bs=1 seek=13 count=1 conv=notrunc 2> /dev/null
