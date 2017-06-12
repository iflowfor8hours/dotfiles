SHELL := /bin/bash

DIR=$(pwd)

ubuntu: update dev_packages git vim dotFiles customBins shutter omz
	sudo apt-get install -qy tmux
	# remmina preferred remote desktop client
	sudo ln -sf /usr/bin/remmina /usr/bin/rdp
	# system tray when trying to run apps on dwm that need a tray
	# preferred terminal emulator
	sudo apt-get install -y xbindkeys
	# xdotool - move mouse programmatically
	sudo apt-get install -y xdotool
	# screensaver
	sudo apt-get install -q -y build-essential libx11-dev libxinerama-dev sharutils suckless-tools
	# dependencies for display battery and cpu temp
	sudo apt-get install -y acpi lm-sensors
	sudo apt purge notify-osd
	sudo apt install -y i3 dunst

shutter:
	sudo apt-get install -y libnet-dbus-glib-perl libimage-exiftool-perl libimage-info-perl shutter

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

save-my-eyes: update
	sudo apt-get install -y gtk-redshift

power-management:
	# dependencies for display battery and cpu temp
	sudo apt-get install -y tlp powertop acpi lm-sensors
	sudo tlp bat
	sudo powertop

forticlient_vpn_ubuntu: update
	sudo apt-get install -y lib32gcc1 libc6-i386
	sudo dpkg -i ./pkgs/forticlient-sslvpn_4.4.2323-1_amd64.deb

update:
	sudo apt-get update -y
	sudo apt-get install -f -y

macbookpro_keyboard:
	echo 2 | sudo tee /sys/module/hid_apple/parameters/fnmode
	echo 0 | sudo tee /sys/module/hid_apple/parameters/iso_layout
	echo 1 | sudo tee /sys/module/hid_apple/parameters/swap_opt_cmd
	xmodmap ~/.xmodmaprc

dotFiles:
	for f in .*; do test -f $$f && ln -sf "$$(pwd)/$$f" ~/$$f; done
	ln -sf $$(pwd)/.xinitrc ~/.xsessionrc
	ln -sf $$(pwd)/.i3 ~/.i3
	- unlink .i3/.i3
	ln -sf $$(pwd)/xchat-config/.xchat2 ~/.xchat2

dev_packages: update
	sudo apt-get install -y ack-grep python python-pip python-dev curl xbindkeys vim vim-common git tig subversion git-svn iotop iftop htop tree nethogs zsh
	sudo pip install virtualenvwrapper

vim: dev_packages
	sudo apt-get install -q=2 -y vim-nox exuberant-ctags cmake python-dev
	@if [ ! -e ~/.vim/.mine ]; then echo "Deleting existing vim configuration"; rm -fr ~/.vim/ ~/.vimrc; fi
	-@ln -sn $$(pwd)/.vimrc ~/.vimrc; true
	-@ln -sn $$(pwd)/.vim ~/.vim; true

update_vim_plugins:
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

customBins:
	if [ ! -d ~/bin/ ]; then \
		mkdir ~/bin/; \
	fi
	@ln -sf $$(pwd)/bin/* ~/bin/
	@sudo ln -sf /home/rramirez/.dotfiles/bin/trackpad-toggle.sh /usr/bin/trackpad-toggle.sh

sshConfig:
	pushd ssh; for f in *; do ln -sf "$$(pwd)/$$f" ~/.ssh/$$f; done; popd
	chmod 600 ~/.ssh/id_rsa

docker: update
	- sudo apt-get purge -y docker.io
	wget -qO- https://get.docker.com/ | sh
	sudo pip install docker-compose
	sudo bash -c "curl -L https://github.com/docker/machine/releases/download/v0.5.4/docker-machine_linux-amd64 > /usr/local/bin/docker-machine && \
	  sudo chmod +x /usr/local/bin/docker-machine"

docker-ubuntu-1610:
	sudo apt-get update
	sudo apt-get install docker-engine -qy
	sudo systemctl enable docker.service
	sudo systemctl start docker.service
	pip install docker-compose
	sudo usermod -aG docker matt

virtualenvwrapper:
	- sudo apt-get remove python-pip
	sudo easy_install pip
	- sudo pip uninstall virtualenvwrapper
	sudo pip install virtualenvwrapper
	echo "export WORKON_HOME=~/Envs"
	echo "mkdir -p $WORKON_HOME"
	echo "source /usr/local/bin/virtualenvwrapper.sh"
	echo "mkvirtualenv env_name"

adobeSourceCodeProFont:
	wget https://github.com/adobe-fonts/source-code-pro/archive/1.017R.zip \
		&& unzip 1.017R.zip \
		&& sudo mkdir -p /usr/share/fonts/truetype/source-code-pro \
		&& sudo cp source-code-pro-1.017R/TTF/*.ttf /usr/share/fonts/truetype/source-code-pro \
		&& rm 1.017R.zip \
		&& rm -fr source-code-pro-1.017R

install-i3-window-manager:
	#sudo bash -c 'echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" >> /etc/apt/sources.list'
	sudo apt-get update
	sudo apt-get --allow-unauthenticated install sur5r-keyring
	sudo apt-get update
	sudo apt-get install i3 xautolock gnome-screensaver -qy

ruby-dev:
	rm -fr ~/.rbenv
	git clone https://github.com/rbenv/rbenv.git ~/.rbenv
	sudo apt-get install -y libssl-dev libreadline-dev zlib1g-dev
	mkdir -p ~/.rbenv/plugins
	git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins
	git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

sysdig:
	curl -s https://s3.amazonaws.com/download.draios.com/stable/install-sysdig | sudo bash

install-golang:
	sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable
	sudo apt-get update
	sudo apt-get install golang

apt-fast-setup:
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
	# Man page installation
	sudo bash -c "cp /tmp/apt-fast/man/apt-fast.8 /usr/share/man/man8 && \
		gzip -f9 /usr/share/man/man8/apt-fast.8 && \
		cp /tmp/apt-fast/man/apt-fast.conf.5 /usr/share/man/man5 && \
		gzip -f9 /usr/share/man/man5/apt-fast.conf.5"
	# configure ubuntu apt mirrors
	sudo sed -r -i.bak "s/#MIRRORS=\( 'none' \)/MIRRORS=( 'http:\/\/mirrors.wikimedia.org\/ubuntu\/, ftp:\/\/ftp.utexas.edu\/pub\/ubuntu\/, http:\/\/mirrors.xmission.com\/ubuntu\/, http:\/\/mirrors.usinternet.com\/ubuntu\/archive\/, http:\/\/mirrors.ocf.berkeley.edu\/ubuntu\/\' )/" /etc/apt-fast.conf

packages: update
	sudo apt-get -y install python-software-properties curl
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
	sudo apt-key fingerprint 0EBFCD88
	sudo add-apt-repository \
	   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
	   $(lsb_release -cs) \
	   stable"
	sudo add-apt-repository -y ppa:git-core/ppa
	sudo add-apt-repository -y "deb http://deb.bitmask.net/debian vivid main"
	sudo add-apt-repository -y ppa:gnome-terminator/nightly-gtk3
	sudo add-apt-repository -y ppa:linrunner/tlp
	wget -O- https://dl.bitmask.net/apt.key | sudo apt-key add -
	sudo apt-get -y install \
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
	zsh \
