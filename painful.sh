#!/bin/bash

# remap ctrl
sed -i 's/^XKBOPTIONS.*/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

sudo apt-get -y install python-software-properties
sudo add-apt-repository -y ppa:git-core/ppa
sudo apt-get update
sudo apt-get -y install mc gnome-commander git vim zsh htop kupfer libgnutls-dev build-essential cmake libuuid1 libuu-dev libuu0 uuid-dev terminator autojump mutt-patched exuberant-ctags offlineimap redshift sqlite notmuch-mutt urlview pgp abook tmux python-pip ack-grep arandr python-virtualenv msmtp curl weechat-curses libncurses5-dev  automake libreadline-dev gnupg2 libgpgme11 libgpgme11-dev

# Taskwarrior
taskwarrior() {
  echo "Setting up Taskwarrior"
  (mkdir -p /tmp/taskinstaller &&
  cd /tmp/taskinstaller &&
  curl -O http://taskwarrior.org/download/task-2.4.4.tar.gz &&
  tar xzvf task-2.4.4.tar.gz &&
  cd task-2.4.4 &&
  cmake -DCMAKE_BUILD_TYPE=release . &&
  make &&
  sudo make install)
  if [ $? -ne 0 ]; then
    echo "Failed to setup taskwarrior"
    return 1
  fi
}

# rbenv
cd ~
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# vbox and vagrant
cd /tmp
wget http://download.virtualbox.org/virtualbox/5.0.8/virtualbox-5.0_5.0.8-103449~Ubuntu~trusty_amd64.deb
sudo dpkg --install virtualbox-5.0_5.0.8-103449\~Ubuntu\~trusty_amd64.deb

cd /tmp
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb
sudo dpkg --install vagrant_1.7.4_x86_64.deb


# homedir setup
mkdir -p ~/.logs
mkdir -p ~/bin
#
## mail stuff
mkdir -p ~/Mail/fastmail
mkdir -p /home/matt/Mail/.mutt/mailboxes
mkdir -p /home/matt/Mail/.offlineimap
mkdir -p ~/.config/offlineimap/
mkdir -p ~/.logs/msmtp
mkdir -p ~/.mutt/temp
touch ~/.logs/msmtp/fastmail.log
touch ~/.config/offlineimap/matt.iflowfor8hours.info
echo "Add your password to ~/.config/offlineimap/matt.iflowfor8hours.info"
