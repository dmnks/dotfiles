#!/bin/bash
# Build the latest vim locally in the $HOME dir

DIR=~/software/vim
REPO=$DIR/repo
INSTALL=$DIR/install

# if this is the first time this script is being run, install the build deps
# and download the vim's sources
if [ ! -d $DIR ]; then
    mkdir -p $DIR
    # install build deps
    sudo yum install -y mercurial gcc ncurses-devel python-devel gtk2-devel \
        libSM-devel libXt-devel libXpm-devel
    # download the sources
    hg clone https://vim.googlecode.com/hg/ $REPO
fi

cd $REPO/src || exit 1

# pull any changes
hg pull
hg update

# clean up
make distclean
rm -rf $INSTALL

# compile and install
./configure \
    --prefix=$INSTALL \
    --with-features=huge \
    --enable-pythoninterp \
    --with-compiledby=dmnks &&
make && make install
