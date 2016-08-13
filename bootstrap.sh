#!/bin/bash
# Bootstrap a new system

set -o errexit

sudo dnf install -y vim git stow python-pip tmux ctags colordiff
sudo pip install flake8 pudb

# Install the dotfiles
mv ~/.bashrc ~/.bashrc.orig  # There's a default .bashrc already
stow -v bash vim git tmux fonts python pulse

# Install Vundle and all plugins
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -u ~/.vundle +PluginInstall +qall

dconf load /org/gnome/ < gnome.conf

echo
echo "Bootstrap complete!"
