.PHONY: fast ubuntu test directories manual_steps arch_packages common_packages ubuntu_packages sysdig osx_fonts osx_packages taskwarrior power_management update linux_keyboard minidot dotfiles vim virtualenvwrapper disable_services adobefont ruby_dev sysdig install_golang ubuntu_packages
SHELL := /bin/bash

DIR=$(pwd)

fast: minidot keyboard

ubuntu: directories dev_packages apt_fast_setup ubuntu_packages keyboard adobefont vim dotfiles virtualenvwrapper ruby_dev sysdig disable_services install_golang taskwarrior power_management manual_steps

test: directories dev_packages apt_fast_setup ubuntu_packages keyboard adobefont vim dotfiles virtualenvwrapper install_golang taskwarrior manual_steps

directories:
	@mkdir -p ${HOME}/.logs
	@mkdir -p ${HOME}/projects
	@mkdir -p ${HOME}/workspace
	@mkdir -p ${HOME}/bin
	@mkdir -p ${HOME}/media
	@mkdir -p ${HOME}/dev
	@mkdir -p ${HOME}/Mail/fastmail
	@mkdir -p ${HOME}/Mail/.mutt/mailboxes
	@mkdir -p ${HOME}/Mail/temporary/search
	@mkdir -p ${HOME}/Mail/.offlineimap
	@mkdir -p ${HOME}/.config/offlineimap/
	@mkdir -p ${HOME}/.logs/msmtp
	@mkdir -p ${HOME}/.mutt/temp
	@touch ${HOME}/.logs/msmtp/fastmail.log
	@touch ${HOME}/.config/offlineimap/matt.iflowfor8hours.info


manual_steps:
	echo "install npm/node, virtualbox/vagrant, configure your stuff from the secrets repo"
	echo "Add your password to ${HOME}/.config/offlineimap/matt.iflowfor8hours.info"
	echo "Setup your vpn credentials"
	echo "setup backups! rsync -avhW --progress --exclude-from=/var/tmp/ignorelist /home/${USER}/ /media/${USER}/${TARGET}/${USER}/"
	echo "Install keybase \
		authy \
		aws tools \
		aws credentials \
		git crypt \
		ansible \
		gcloud tools \
		kubectl \
		minikube"

arch_packages:
	yay -Syu diff-so-fancy \
		pyenv


common_packages:
	sudo pacman -Syu abook \
		ack \
		ansible \
		autojump \
		cmake \
		curl \
		docker \
		git \
		htop \
		jq \
		mc \
		mutt \
		neovim \
		nmap \
		python3 \
		pyenv \
		ranger \
		readline \
		ruby \
		task \
		tmux \
		tig \
		tmux \
		tree \
		unrar \
		vim \
		weechat \
		wget \
		xbindkeys \
		xcape \
		zsh \
		zsh-autosuggestions \
		zsh-completions

osx_fonts:
	brew tap caskroom/fonts
	brew cask install \
		font-sourcecodepro-nerd-font \
		font-sourcecodepro-nerd-font-mono \
		font-hack-nerd-font \
		font-hack-nerd-font-mono

osx_packages:
	brew install \
		ack \
		autojump \
		caskroom/cask/alfred \
		caskroom/cask/firefox \
		caskroom/cask/karabiner-elements \
		caskroom/cask/vagrant \
		caskroom/cask/virtualbox \
		cmake \
		curl \
		docker-ce \
		diff-so-fancy \
		git \
		go \
		hh \
		htop \
		jq \
		kubectl \
		links \
		mc \
		mutt \
		neovim \
		netdata \
		nmap \
		pstree \
		ranger \
		rbenv \
		readline \
		ruby \
		ruby-build \
		task \
		tmate \
		tmux \
		tree \
		unrar \
		vim \
		wget \
		zsh \
		zsh-completions

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
	sudo apt-get -y -q=2 install tlp powertop acpi lm-sensors
	sudo tlp bat
	sudo powertop --auto-tune

update:
	sudo apt-get update -y
	sudo apt-get install -f -y


linux_keyboard:
	sudo bash -c '[ -d /etc/default ] \
		echo XKBMODEL=\"pc105\"\ XKBLAYOUT=\"us\"\ XKBVARIANT=\"\"\ XKBOPTIONS=\"ctrl:nocaps\"\
		BACKSPACE=\"guess\" > /etc/default/keyboard'
	rm -rf ${HOME}/.Xmodmap
	ln -sn $(PWD)/.Xmodmap ${HOME}/.Xmodmap


minidot:
	rm -rf ${HOME}/.bashrc
	rm -rf ${HOME}/.vim
	rm -rf ${HOME}/.vimrc
	rm -rf ${HOME}/.gitconfig
	rm -rf ${HOME}/.zshrc
	rm -rf ${HOME}/.tmux.conf
	rm -rf ${HOME}/.config/nvim
	ln -sn $(PWD)/.bashrc ${HOME}/.bashrc
	ln -sn $(PWD)/.vim ${HOME}/.vim
	ln -sn $(PWD)/.vimrc ${HOME}/.vimrc
	ln -sn $(PWD)/.gitconfig ${HOME}/.gitconfig
	ln -sn $(PWD)/.zshrc ${HOME}/.zshrc
	ln -sn $(PWD)/.tmux.conf ${HOME}/.tmux.conf
	ln -sn $(PWD)/.config/nvim ${HOME}/.config/nvim

dotfiles:
	rm -rf ${HOME}/.bashrc
	rm -rf ${HOME}/.notmuch-config
	rm -rf ${HOME}/.vim
	rm -rf ${HOME}/.vimrc
	rm -rf ${HOME}/.irssi
	rm -rf ${HOME}/.gitconfig
	rm -rf ${HOME}/.zshrc
	rm -rf ${HOME}/.tmux.conf
	rm -rf ${HOME}/.config/redshift.conf
	rm -rf ${HOME}/.Xresources
	rm -rf ${HOME}/.config/terminator
	rm -rf ${HOME}/.config/khal
	rm -rf ${HOME}/.muttrc
	rm -rf ${HOME}/.offlineimaprc
	rm -rf ${HOME}/.taskrc
	rm -rf ${HOME}/.msmtprc
	rm -rf ${HOME}/.mutt
	rm -rf ${HOME}/.ipython
	rm -rf ${HOME}/.hgrc
	ln -sn $(PWD)/.bashrc ${HOME}/.bashrc
	ln -sn $(PWD)/.notmuch-config ${HOME}/.notmuch-config
	ln -sn $(PWD)/.vim ${HOME}/.vim
	ln -sn $(PWD)/.vimrc ${HOME}/.vimrc
	ln -sn $(PWD)/.gitconfig ${HOME}/.gitconfig
	ln -sn $(PWD)/.zshrc ${HOME}/.zshrc
	ln -sn $(PWD)/.tmux.conf ${HOME}/.tmux.conf
	ln -sn $(PWD)/redshift.conf ${HOME}/.config/redshift.conf
	ln -sn $(PWD)/.Xresources ${HOME}/.Xresources
	ln -sn $(PWD)/.config/terminator ${HOME}/.config/terminator
	ln -sn $(PWD)/.config/khal ${HOME}/.config/khal
	ln -sn $(PWD)/.muttrc ${HOME}/.muttrc
	ln -sn $(PWD)/.offlineimaprc ${HOME}/.offlineimaprc
	ln -sn $(PWD)/.taskrc ${HOME}/.taskrc
	ln -sn $(PWD)/.msmtprc ${HOME}/.msmtprc
	ln -sn $(PWD)/.mutt ${HOME}/.mutt
	ln -sn $(PWD)/.ipython ${HOME}/.ipython
	ln -sn $(PWD)/.hgrc ${HOME}/.hgrc
	chsh -s /bin/zsh

vim:
	@if [ -e /usr/bin/apt-get ]; then sudo apt-get -y -q=2 install vim-nox exuberant-ctags cmake python-dev; fi
	@if [ -e /usr/local/bin/brew ]; then brew install vim neovim ctags cmake; fi
	@if [ ! -e ${HOME}/.vim/.mine ]; then echo "Deleting existing vim configuration"; rm -fr ${HOME}/.vim ${HOME}/.vimrc; fi
	-@ln -sn $(PWD)/.vimrc ${HOME}/.vimrc; true
	-@ln -sn $(PWD)/.vim ${HOME}/.vim; true

virtualenvwrapper:
	- sudo apt-get remove -y python-pip
	sudo easy_install pip
	- sudo pip uninstall virtualenvwrapper
	sudo pip install virtualenvwrapper
	echo "export WORKON_HOME=${HOME}/dev/venvs"
	echo "mkdir -p $WORKON_HOME"
	echo "source /usr/local/bin/virtualenvwrapper.sh"
	echo "mkvirtualenv env_name"

disable_services:
	sudo /bin/bash -c "systemctl disable bluetooth.service \
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
	curl -O -L https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip \
		&& unzip 1.017R.zip \
		&& sudo mkdir -p /usr/share/fonts/TTF/ \
		&& sudo cp source-code-pro-1.017R/TTF/SourceCode* /usr/share/fonts/TTF/ \
		&& sudo chmod -R 444 /usr/share/fonts/TTF/SourceCode* \
		&& rm 1.017R.zip \
		&& rm -fr source-code-pro-1.017R

ruby_dev:
	rm -fr ${HOME}/.rbenv
	git clone https://github.com/rbenv/rbenv.git ${HOME}/.rbenv
	sudo apt-get install -y -q=2 libssl-dev libreadline-dev zlib1g-dev
	mkdir -p ${HOME}/.rbenv/plugins
	git clone git://github.com/sstephenson/ruby-build.git ${HOME}/.rbenv/plugins
	git clone https://github.com/sstephenson/ruby-build.git ${HOME}/.rbenv/plugins/ruby-build
	cd ${HOME}/.rbenv && src/configure && make -C src
	bash -c "PATH=\"${HOME}/.rbenv/bin:${PATH}\" && rbenv init - && rbenv install 2.3.1 && rbenv global 2.3.1"

sysdig:
	curl -s https://s3.amazonaws.com/download.draios.com/stable/install-sysdig | sudo bash

decrypt_private:
	openssl aes-256-cbc -d -a -salt -in .zshrc.private.enc -out .zshrc.private

encrypt_private:
	openssl aes-256-cbc -a -salt -in .zshrc.private -out .zshrc.private.enc

install_golang:
	sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
	sudo apt-get update
	sudo apt-get install -y golang

ubuntu_packages:
	echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
	sudo apt-get -q=2 -y install python-software-properties apt-transport-https curl software-properties-common resolvconf tzdata
	ln -fs /usr/share/zoneinfo/US/Eastern /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable"
	sudo add-apt-repository -y ppa:git-core/ppa
	sudo add-apt-repository -y "deb http://deb.bitmask.net/debian vivid main"
	sudo add-apt-repository -y ppa:gnome-terminator/nightly-gtk3
	sudo add-apt-repository -y ppa:linrunner/tlp
	curl -fsSL https://dl.bitmask.net/apt.key | sudo apt-key add -
	sudo apt-get update
	sudo apt-get -qy --no-install-recommends install \
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
		ranger \
		redshift \
		terminator \
		tlp \
		tmux \
		unrar \
		urlview \
		uuid-dev \
		vim \
		w3m \
		xsel \
		zsh
