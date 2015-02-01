#!/bin/bash
# Bootstrap a new system

sudo yum install -y git stow python-pip
sudo pip install pyflakes pep8

# Install the dotfiles
git clone https://github.com/dmnks/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
# There already is a default .bashrc
mv ~/.bashrc ~/.bashrc.orig
stow -v bash vim

# Install Vundle and all plugins
git clone https://github.com/gmarik/Vundle.vim.git \
    ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
