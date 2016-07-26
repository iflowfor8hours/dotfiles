#!/bin/bash
set -e

# remap ctrl
sudo sed -i 's/^XKBOPTIONS.*/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

sudo apt-get -y install python-software-properties
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository "deb http://deb.bitmask.net/debian vivid main"
wget -O- https://dl.bitmask.net/apt.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install mc gnome-commander git vim zsh htop kupfer libgnutls-dev build-essential cmake libuuid1 libuu-dev libuu0 uuid-dev terminator autojump mutt-patched exuberant-ctags offlineimap redshift sqlite notmuch-mutt urlview pgp abook tmux python-pip ack-grep arandr python-virtualenv msmtp curl weechat-curses libncurses5-dev  automake libreadline-dev gnupg2 libgpgme11 libgpgme11-dev resolvconf dnsmasq python-dev unrar autoconf bison libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev xsel libc6:i386  w3m libaudio2 libmysqlclient18 libqt4-declarative libqt4-network libqt4-opengl libqt4-script libqt4-sql libqt4-sql-mysql libqt4-xml libqt4-xmlpatterns libqtcore4 libqtdbus4 libqtgui4 mysql-common qtcore4-l10n bitmask leap-keyring openvpn dconf-editor

# node
curl --silent --location https://deb.nodesource.com/setup_0.12 | sudo bash -
sudo apt-get install --yes nodejs

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
sudo apt-get -f install

cd /tmp
wget https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.deb
sudo dpkg --install vagrant_1.7.4_x86_64.deb
vagrant plugin install landrush

sudo sh -c 'echo "server=/vagrant.dev/127.0.0.1#10053" > /etc/dnsmasq.d/vagrant-landrush'
sudo service dnsmasq restart

# vpn
mkdir -p /home/${USER}/dev
cd /home/${USER}/projects

# homedir setup
mkdir -p ~/.logs
mkdir -p ~/bin
mkdir -p /home/${USER}/src
mkdir -p /home/${USER}/projects
#
## mail stuff
mkdir -p ~/Mail/fastmail
mkdir -p /home/${USER}/Mail/.mutt/mailboxes
mkdir -p /home/${USER}/Mail/temporary/search
mkdir -p /home/${USER}/Mail/.offlineimap
mkdir -p ~/.config/offlineimap/
mkdir -p ~/.logs/msmtp
mkdir -p ~/.mutt/temp
touch ~/.logs/msmtp/fastmail.log
touch ~/.config/offlineimap/matt.iflowfor8hours.info
echo "Add your password to ~/.config/offlineimap/matt.iflowfor8hours.info"
echo "Setup your vpn credentials"
echo "setup backups! rsync -avhW --progress --exclude-from=/var/tmp/ignorelist /home/${USER}/ /media/${USER}/${TARGET}/${USER}/"
