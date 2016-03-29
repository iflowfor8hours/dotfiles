#!/bin/bash

cd ..

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
ln -sn ~/dotfiles/.muttrc ~/.muttrc
ln -sn ~/dotfiles/.offlineimaprc ~/.offlineimaprc
ln -sn ~/dotfiles/.taskrc ~/.taskrc
ln -sn ~/dotfiles/.msmtprc ~/.msmtprc
ln -sn ~/dotfiles/.mutt ~/.mutt
ln -sn ~/dotfiles/.ipython ~/.ipython

chmod 600 ~/.msmtprc
