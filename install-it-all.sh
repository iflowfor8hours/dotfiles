#!/bin/bash
set -e

# remap ctrl
# sudo sed -i 's/^XKBOPTIONS.*/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

sudo apt-get -y install python-software-properties curl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo add-apt-repository -y ppa:git-core/ppa
sudo add-apt-repository "deb http://deb.bitmask.net/debian vivid main"

wget -O- https://dl.bitmask.net/apt.key | sudo apt-key add -
sudo apt-get update
sudo apt-get -y install \
abook \
apt-transport-https \
ack-grep \
arandr \
autoconf \
autojump \
automake \
bison \
bitmask \
build-essential \
ca-certificates \
cmake \
curl \
dconf-editor \
docker-ce \
dnsmasq \
exuberant-ctags \
git \
gnome-commander \
gnupg2 \
htop \
kupfer \
leap-keyring \
libc6:i386 \
libffi-dev \
libgdbm-dev \
libgdbm3 \
libgnutls-dev \
libgpgme11 \
libgpgme11-dev \
libncurses5-dev \
libreadline-dev \
libreadline6-dev \
libssl-dev \
libuu-dev \
libuu0 \
libuuid1 \
libyaml-dev \
light-locker-settings \
mc \
msmtp \
mutt-patched \
mysql-common \
nfs-common \
nfs-kernel-server \
notmuch-mutt \
offlineimap \
openvpn \
pgp \
python-dev \
python-pip \
python-virtualenv \
ranger \
redshift \
resolvconf \
software-properties-common \
sqlite \
terminator \
tmux \
unrar \
urlview \
uuid-dev \
vim \
w3m \
weechat-curses \
xsel \
zlib1g-dev \
zsh \

# node
#curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
#sudo apt-get install --yes nodejs

# rbenv
#cd ~
#git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
#git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

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

# vpn?
mkdir -p /home/${USER}/dev
cd /home/${USER}/projects

# homedir setup
mkdir -p ~/.logs
mkdir -p /home/${USER}/src
mkdir -p /home/${USER}/projects
mkdir -p /home/${USER}/bin
mkdir -p /home/${USER}/media
mkdir -p /home/${USER}/dev

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
echo "Install keybase \
lastpass \ 
authy \
aws tools \
aws credentials \
gpg tools \
git crypt \
PIA \
ansible \
taskwarrior"

echo "Look at the commented tasks and update accordingly for vagrant, vbox, node/npm, etc"
echo "nothing is permanent, ownership is ephemeral, work to make that happen"
