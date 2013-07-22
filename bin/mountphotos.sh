#!/usr/bin/env bash
read -s -p "Enter Password: " MYPASSWORD
mount -t cifs //lowspeed/media1 /media/lowspeed -o user=matt,password=$MYPASSWORD,workgroup=WORKGROUP,ip=192.168.42.10
