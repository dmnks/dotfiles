#!/bin/bash
# Bootstrap a new system

set -o errexit

sudo dnf install -y vim git stow python-pip tmux ctags colordiff tig
sudo pip install flake8 pudb

[ -f ~/.bashrc ] && mv ~/.bashrc{,.orig}
stow -v bin bash vim git tmux fonts pulse
stow -v --no-folding python  # Don't fold pudb

git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -u ~/.vundle +PluginInstall +qall

dconf load /org/gnome/ < gnome.conf

echo
echo "Bootstrap complete!"
