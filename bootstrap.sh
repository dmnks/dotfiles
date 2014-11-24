#!/bin/bash
# Bootstrap a new system

# install some goodies
sudo yum install -y python-pip
sudo pip install pyflakes pep8

# install the dotfiles
DOTFILES=~/dotfiles
if [ -f ~/.vimrc ]; then
    mv ~/.vimrc ~/.vimrc.orig
fi
if [ -f ~/.bashrc ]; then
    mv ~/.bashrc ~/.bashrc.orig
fi
ln -s $DOTFILES/vimrc ~/.vimrc
ln -s $DOTFILES/bashrc ~/.bashrc

# install Vundle and all plugins
if [ -d ~/.vim ]; then
    mv ~/.vim ~/.vim.orig
fi
git clone https://github.com/gmarik/Vundle.vim.git \
    ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# configure GNOME
gconftool-2 --set --type string \
    /apps/metacity/window_keybindings/toggle_fullscreen F11
