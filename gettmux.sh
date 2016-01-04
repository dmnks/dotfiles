#!/bin/bash
# Build the latest tmux

set -o errexit

ver="2.1"
src=$(mktemp -d)
stow=/usr/local/stow

# Install build deps
sudo dnf install -y gcc ncurses-devel libevent-devel stow

# Prepare the sources
cd $src
wget https://github.com/tmux/tmux/releases/download/$ver/tmux-${ver}.tar.gz
tar xf tmux-${ver}.tar.gz
cd tmux-${ver}

# Unstow and remove any existing build
if [ -d $stow/tmux ]; then
    sudo stow -d $stow -D tmux
    sudo rm -rf $stow/tmux
fi

# Compile and install into the stow directory
./configure --prefix=$stow/tmux
make
sudo make install
rm -rf $src

# Stow it
sudo stow -d $stow tmux

# Use the new tmux right now
hash -r
