#!/bin/bash
# Build the latest vim locally in the $HOME dir

DIR=~/install/vim

# remove any existing build but ask first
if [ -d $DIR ]; then
    echo "A vim install already exists.  Do you wish to overwrite it?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) rm -rf $DIR; break;;
            No ) exit;;
        esac
    done
fi

# install build deps
sudo yum install -y mercurial gcc ncurses-devel python-devel gtk2-devel \
    libSM-devel libXt-devel libXpm-devel

# download the sources
REPO=$(mktemp -d) || exit 1
hg clone https://vim.googlecode.com/hg/ $REPO

# compile and install
cd $REPO/src &&
./configure \
    --prefix=$DIR \
    --with-features=huge \
    --enable-pythoninterp \
    --with-compiledby=dmnks &&
make && make install
rm -rf $REPO
