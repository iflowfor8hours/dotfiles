SHELL := /bin/bash

DIR=$(pwd)

ubuntu: directories dev_packages apt_fast_setup packages keyboard adobefont vim update_vim_plugins dotfiles virtualenvwrapper ruby_dev sysdig disable_services install_golang taskwarrior manual_steps

dev_packages: update
	sudo apt-get install -q=2 -y ack-grep python python-pip python-dev curl xbindkeys vim vim-common git tig subversion git-svn iotop iftop htop tree nethogs zsh
	sudo pip install virtualenvwrapper

directories:
	@mkdir -p ~/.logs
	@mkdir -p /home/${USER}/src
	@mkdir -p /home/${USER}/projects
	@mkdir -p /home/${USER}/bin
	@mkdir -p /home/${USER}/media
	@mkdir -p /home/${USER}/dev
	@mkdir -p /home/${USER}/dev/venvs
	@## mail stuff
	@mkdir -p /home/${USER}/Mail/fastmail
	@mkdir -p /home/${USER}/Mail/.mutt/mailboxes
	@mkdir -p /home/${USER}/Mail/temporary/search
	@mkdir -p /home/${USER}/Mail/.offlineimap
	@mkdir -p /home/${USER}/.config/offlineimap/
	@mkdir -p /home/${USER}/.logs/msmtp
	@mkdir -p /home/${USER}/.mutt/temp
	@touch /home/${USER}/.logs/msmtp/fastmail.log
	@touch /home/${USER}/.config/offlineimap/matt.iflowfor8hours.info

manual_steps:
	echo "install npm/node, virtualbox/vagrant, configure your stuff from the secrets repo"
	echo "Add your password to ~/.config/offlineimap/matt.iflowfor8hours.info"
	echo "Setup your vpn credentials"
	echo "setup backups! rsync -avhW --progress --exclude-from=/var/tmp/ignorelist /home/${USER}/ /media/${USER}/${TARGET}/${USER}/"
	echo "Install keybase \
	lastpass \
	authy \
	aws tools \
	aws credentials \
	git crypt \
	PIA \
	ansible"

taskwarrior:
	echo "Setting up Taskwarrior" \
		&& mkdir -p /tmp/taskinstaller \
		&& cd /tmp/taskinstaller \
		&& curl -L -O http://taskwarrior.org/download/task-2.5.1.tar.gz \
		&& tar xzvf task-2.5.1.tar.gz \
		&& cd task-2.5.1 \
		&& cmake -DCMAKE_BUILD_TYPE=release . \
		&& make \
		&& sudo make install

power_management:
	# dependencies for display battery and cpu temp
	sudo apt-get install -y tlp powertop acpi lm-sensors
	sudo tlp bat
	sudo powertop --auto-tune

update:
	sudo apt-get update -y
	sudo apt-get install -f -y

keyboard:
	sudo sed -i 's/^XKBOPTIONS.*/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

dotfiles:
	rm -rf ~/.bashrc
	rm -rf ~/.notmuch-config
	rm -rf ~/.vim/
	rm -rf ~/.vimrc
	rm -rf ~/.irssi
	rm -rf ~/.gitconfig
	rm -rf ~/.zshrc
	rm -rf ~/.tmux.conf
	rm -rf ~/.config/redshift.conf
	rm -rf ~/.Xresources
	rm -rf ~/.config/terminator
	rm -rf ~/.config/khal
	rm -rf ~/.muttrc
	rm -rf ~/.offlineimaprc
	rm -rf ~/.taskrc
	rm -rf ~/.msmtprc
	rm -rf ~/.mutt
	rm -rf ~/.ipython
	rm -rf ~/.hgrc
	ln -sn ~/dotfiles/.bashrc ~/.bashrc
	ln -sn ~/dotfiles/.notmuch-config ~/.notmuch-config
	ln -sn ~/dotfiles/.vim ~/.vim/
	ln -sn ~/dotfiles/.vimrc ~/.vimrc
	ln -sn ~/dotfiles/.irssi ~/.irssi
	ln -sn ~/dotfiles/.gitconfig ~/.gitconfig
	ln -sn ~/dotfiles/.zshrc ~/.zshrc
	ln -sn ~/dotfiles/.tmux.conf ~/.tmux.conf
	ln -sn ~/dotfiles/redshift.conf ~/.config/redshift.conf
	ln -sn ~/dotfiles/.Xresources ~/.Xresources
	ln -sn ~/dotfiles/.config/terminator ~/.config/terminator
	ln -sn ~/dotfiles/.config/khal ~/.config/khal
	ln -sn ~/dotfiles/.muttrc ~/.muttrc
	ln -sn ~/dotfiles/.offlineimaprc ~/.offlineimaprc
	ln -sn ~/dotfiles/.taskrc ~/.taskrc
	ln -sn ~/dotfiles/.msmtprc ~/.msmtprc
	ln -sn ~/dotfiles/.mutt ~/.mutt
	ln -sn ~/dotfiles/.ipython ~/.ipython
	ln -sn ~/dotfiles/.hgrc ~/.hgrc

vim: 
	sudo apt-get install -q=2 -y vim-nox exuberant-ctags cmake python-dev
	@if [ ! -e ~/.vim/.mine ]; then echo "Deleting existing vim configuration"; rm -fr ~/.vim/ ~/.vimrc; fi
	-@ln -sn $$(pwd)/.vimrc ~/.vimrc; true
	-@ln -sn $$(pwd)/.vim ~/.vim; true

update_vim_plugins: dev_packages vim
	git stash --all
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/nerdtree https://github.com/scrooloose/nerdtree.git  --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/syntastic https://github.com/scrooloose/syntastic.git --squash master 
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-fugitive https://github.com/tpope/vim-fugitive.git  --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/gitgutter https://github.com/jisaacks/GitGutter.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-markdown https://github.com/plasticboy/vim-markdown.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-markdown-preview https://github.com/JamshedVesuna/vim-markdown-preview.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-rsi https://github.com/tpope/vim-rsi.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-surround https://github.com/tpope/vim-surround.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/ack-vim https://github.com/mileszs/ack.vim.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/ctrlp https://github.com/ctrlpvim/ctrlp.vim.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/command-t https://github.com/wincent/command-t.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-bracketed-paste https://github.com/ConradIrwin/vim-bracketed-paste.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-unimpaired https://github.com/tpope/vim-unimpaired.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-sensible https://github.com/tpope/vim-sensible.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-commentary https://github.com/tpope/vim-commentary.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-repeat https://github.com/tpope/vim-repeat.git --squash master
	git subtree pull -q -m 'update vim plugins' --prefix .vim/bundle/vim-tbone https://github.com/tpope/vim-tbone.git --squash master
	git stash pop

virtualenvwrapper:
	- sudo apt-get remove python-pip
	sudo easy_install pip
	- sudo pip uninstall virtualenvwrapper
	sudo pip install virtualenvwrapper
	echo "export WORKON_HOME=~/dev/venvs"
	echo "mkdir -p $WORKON_HOME"
	echo "source /usr/local/bin/virtualenvwrapper.sh"
	echo "mkvirtualenv env_name"

disable_services:
	sudo bash -c "systemctl disable bluetooth.service \
		&& systemctl disable isc-dhcp-server.service \
		&& systemctl disable isc-dhcp-server6.service \
		&& systemctl disable openvpn.service \
		&& systemctl disable postgresql.service \
		&& systemctl disable transmission-daemon.service \
		&& systemctl disable whoopsie.service \
		&& systemctl disable ModemManager.service \
		&& systemctl disable bluetooth.target \
		&& rfkill block bluetooth \
		&& rfkill block wwan"

adobefont:
	wget https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip \
		&& unzip 1.017R.zip \
		&& sudo mkdir -p /usr/share/fonts/truetype/source-code-pro \
		&& sudo cp source-code-pro-1.017R/TTF/*.ttf /usr/share/fonts/truetype/source-code-pro \
		&& rm 1.017R.zip \
		&& rm -fr source-code-pro-1.017R

ruby_dev:
	rm -fr ~/.rbenv
	git clone https://github.com/rbenv/rbenv.git ~/.rbenv
	sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
	mkdir -p ~/.rbenv/plugins
	git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
	rbenv install 2.3.1
	rbenv global 2.3.1

sysdig:
	curl -s https://s3.amazonaws.com/download.draios.com/stable/install-sysdig | sudo bash

install_golang:
	sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable
	sudo apt-get update
	sudo apt-get install golang

apt_fast_setup:
	sudo bash -c "apt-get install -y aria2 git && \
		if ! [[ -f /usr/bin/apt-fast ]]; then \
		  git clone https://github.com/ilikenwf/apt-fast /tmp/apt-fast; \
		  cp /tmp/apt-fast/apt-fast /usr/bin; \
		  chmod +x /usr/bin/apt-fast; \
		  cp /tmp/apt-fast/apt-fast.conf /etc; \
		fi"
	# bash autocompletion
	sudo bash -c "cp /tmp/apt-fast/completions/bash/apt-fast /etc/bash_completion.d/ && \
		chown root:root /etc/bash_completion.d/apt-fast"
	. /etc/bash_completion
	# zsh autocompletion
	if ! [[ -f /usr/bin/zsh ]]; then \
		sudo bash -c "cp /tmp/apt-fast/completions/zsh/_apt-fast /usr/share/zsh/functions/Completion/Debian/ && \
			chown root:root /usr/share/zsh/functions/Completion/Debian/_apt-fast"; \
		source /usr/share/zsh/functions/Completion/Debian/_apt-fast; \
	fi
	# configure ubuntu apt mirrors
	sudo sed -r -i.bak "s/#MIRRORS=\( 'none' \)/MIRRORS=( 'http:\/\/mirrors.wikimedia.org\/ubuntu\/, ftp:\/\/ftp.utexas.edu\/pub\/ubuntu\/, http:\/\/mirrors.xmission.com\/ubuntu\/, http:\/\/mirrors.usinternet.com\/ubuntu\/archive\/, http:\/\/mirrors.ocf.berkeley.edu\/ubuntu\/\' )/" /etc/apt-fast.conf

packages:
	sudo apt-get -q=2 -y install python-software-properties curl
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
	sudo add-apt-repository -y ppa:git-core/ppa
	sudo add-apt-repository -y "deb http://deb.bitmask.net/debian vivid main"
	sudo add-apt-repository -y ppa:gnome-terminator/nightly-gtk3
	sudo add-apt-repository -y ppa:linrunner/tlp
	wget -O- https://dl.bitmask.net/apt.key | sudo apt-key add -
	sudo apt-get update
	sudo apt-get -qy install \
	abook \
	acpi-call-dkms \
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
	meld \
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
	ranger \
	redshift \
	resolvconf \
	software-properties-common \
	sqlite \
	terminator \
	tlp \
	tmux \
	unrar \
	urlview \
	uuid-dev \
	vim \
	w3m \
	weechat-curses \
	xsel \
	zlib1g-dev \
	zsh
