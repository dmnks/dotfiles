#!/bin/bash
# Build the latest vim

REPO=$HOME/.vim_source

# install build deps
sudo yum install -y mercurial gcc ncurses-devel python-devel gtk2-devel \
    libSM-devel libXt-devel libXpm-devel

# prepare the sources
if [ ! -d $REPO ]; then
    hg clone https://vim.googlecode.com/hg/ $REPO
fi
cd $REPO/src || exit 1
sudo make uninstall
make distclean
hg pull
hg update

# compile and install
./configure \
    --with-features=huge \
    --enable-pythoninterp \
    --with-compiledby=dmnks &&
make && sudo make install
