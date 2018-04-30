#!/bin/bash
# Build the latest vim

set -o errexit

repo=$HOME/.vim_source
stow=/usr/local/stow

# Install build deps
sudo dnf install -y mercurial gcc ncurses-devel python-devel gtk2-devel \
    libSM-devel libXt-devel libXpm-devel stow

# Prepare the sources
if [ ! -d $repo ]; then
    git clone https://github.com/vim/vim.git $repo
fi
cd $repo/src
[ -f auto/config.mk ] && make distclean

# Unstow and remove any existing build
if [ -d $stow/vim ]; then
    sudo stow -d $stow -D vim
    sudo rm -rf $stow/vim
fi

# Compile and install into the stow directory
./configure \
    --prefix=$stow/vim \
    --with-features=huge \
    --enable-pythoninterp \
    --with-compiledby=dmnks
make
sudo make install

# Stow it
sudo stow -d $stow vim

# Use the new vim right now
hash -r
