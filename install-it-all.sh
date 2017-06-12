#!/bin/bash
set -e

# remap ctrl
# sudo sed -i 's/^XKBOPTIONS.*/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

# node
#curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
#sudo apt-get install --yes nodejs

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# vbox and vagrant
#cd /tmp
#wget http://download.virtualbox.org/virtualbox/5.0.8/virtualbox-5.0_5.0.8-103449~Ubuntu~trusty_amd64.deb
#sudo dpkg --install virtualbox-5.0_5.0.8-103449\~Ubuntu\~trusty_amd64.deb
#sudo apt-get -f install

#cd /tmp
#wget https://releases.hashicorp.com/vagrant/1.8.6/vagrant_1.8.6_x86_64.deb
#sudo dpkg --install vagrant_1.8.6_x86_64.deb
