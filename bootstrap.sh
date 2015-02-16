#!/bin/bash
# Bootstrap a new system

set -o errexit

sudo yum install -y git stow python-pip tmux
sudo pip install pyflakes pep8

# Clone the repo
git clone --recursive https://github.com/dmnks/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Compile the latest vim
./getvim.sh

# Install the dotfiles
mv ~/.bashrc ~/.bashrc.orig  # There's a default .bashrc already
stow -v bash vim git tmux fonts dircolors

# Install Vundle and all plugins
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -u ~/.vundle +PluginInstall +qall

# Load the new dircolors right now
eval `dircolors ~/.dir_colors`

echo
echo "Bootstrap complete!"
