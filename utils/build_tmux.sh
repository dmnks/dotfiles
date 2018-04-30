#!/bin/bash
# Build and install the latest tmux

set -o errexit

ver="2.7"
build=build/tmux
tarball=tmux-${ver}.tar.gz
stow=/usr/local/stow

# Install build deps
sudo dnf install -y gcc ncurses-devel libevent-devel stow

# Prepare the sources
mkdir -p ${build}
cd ${build}
wget https://github.com/tmux/tmux/releases/download/${ver}/${tarball}
tar xzf ${tarball}
cd tmux-${ver}

# Unstow and remove any existing build
if [ -d ${stow}/tmux ]; then
    sudo stow -d ${stow} -D tmux
    sudo rm -rf ${stow}/tmux
fi

# Compile and install into the stow directory
./configure --prefix=${stow}/tmux
make
sudo make install

# Stow it
sudo stow -d ${stow} tmux

# Use the new tmux right now
hash -r

# Clean up
rm -rf ${build}
