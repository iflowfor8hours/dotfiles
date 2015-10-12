#!/bin/bash

# automate ctrl to caps rebind
# map f1 to escape somehow

sudo add-apt-repo ppa:git-core/ppa
sudo apt-get update

sudo apt-get install mc gnome-commander git vim zsh htop kupfer libgnutls-dev build-essential cmake libuuid1 libuu-dev libuu0 uuid-dev terminator autojump mutt-patched exuberant-ctags offlineimap redshift sqlite notmuch-mutt urlview pgp abook tmux python-pip ack-grep

# Taskwarrior
mkdir -p /home/matt/.task/
mkdir -p /tmp/taskinstaller
cd /tmp/taskinstaller
curl -O http://taskwarrior.org/download/task-2.4.4.tar.gz
tar xzvf task-2.4.4.tar.gz
cd task-2.4.4
cmake -DCMAKE_BUILD_TYPE=release .
make
sudo make install



# rbenv
cd ~
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

# fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# mail stuff
mkdir -p ~/Mail/fastmail
mkdir -p /home/matt/Mail/.mutt/mailboxes
mkdir -p /home/matt/Mail/.offlineimap
mkdir -p ~/.config/offlineimap/
touch ~/.config/offlineimap/matt.iflowfor8hours.info
echo "Add your password to ~/.config/offlineimap/matt.iflowfor8hours.info"
