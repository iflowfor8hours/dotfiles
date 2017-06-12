#!/bin/bash

sudo -i

# systemctl list-dependencies multi-user.target 

# /usr/share/X11/xorg.conf.d/90-libinput.conf 
#Section "InputClass"
#        Identifier "libinput pointer catchall"
#        MatchIsPointer "on"
#        MatchDevicePath "/dev/input/event*"
#        Driver "libinput"
#        Option "Tapping" "False"
#        Option "PalmDetection" "True"
#        Option "DisableWhileTyping" "True"
#        Option "AccelProfile" "adaptive"
#        Option "AccelSpeed" "1.00"
#        Option "ClickMethod" "buttonareas"
#        Option "MiddleEmulation" "True"
#        Option "ScrollMethod" "twofinger"
#        Option "HorizontalScrolling" "True"
#EndSection




sudo systemctl disable apt-daily.service # disable run when system boot
sudo systemctl disable apt-daily.timer   # disable timer run
systemctl stop ModemManager.service
systemctl disable ModemManager.service
rfkill block bluetooth
rfkill block wwan
