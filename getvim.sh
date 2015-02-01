#!/bin/bash
# Build the latest vim

REPO=$HOME/.vim_source
STOW=/usr/local/stow

# Install build deps
sudo yum install -y mercurial gcc ncurses-devel python-devel gtk2-devel \
    libSM-devel libXt-devel libXpm-devel

# Prepare the sources
if [ ! -d $REPO ]; then
    hg clone https://vim.googlecode.com/hg/ $REPO
fi
cd $REPO/src || exit 1
make distclean
hg pull
hg update

# Unstow and remove any existing vim
sudo stow -d $STOW -D vim
sudo rm -rf $STOW/vim

# Compile and install into the stow directory
./configure \
    --prefix=$STOW/vim \
    --with-features=huge \
    --enable-pythoninterp \
    --with-compiledby=dmnks &&
make && sudo make install

# Stow it
sudo stow -d $STOW vim

# Use the new vim right now
hash -r
