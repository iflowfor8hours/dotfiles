#!/bin/bash

echo "This script will delete the default or preconfigured files below, are you sure you want to do that?"
echo "~/.bashrc"
echo "~/.notmuch-config"
echo "~/.vim/"
echo "~/.vimrc"
echo "~/.irssi"
echo "~/.gitconfig"
echo "~/.zshrc"
echo "~/.tmux.conf"
echo "~/.config/redshift.conf"
echo "~/.Xresources"
echo "~/.config/terminator"
echo "~/.config/khal"
echo "~/.muttrc"
echo "~/.offlineimaprc"
echo "~/.taskrc"
echo "~/.msmtprc"
echo "~/.mutt"
echo "~/.ipython"
echo "~/.hgrc"


read -p "Are you sure you want to replace all those files with the symlinked versions in this repo? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
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
fi

chmod 600 ~/.msmtprc


chmod 600 ~/.msmtprc
