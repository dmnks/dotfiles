#!/bin/bash
# Bootstrap a new system

sudo yum install -y git stow python-pip
sudo pip install pyflakes pep8

# Install the dotfiles
git clone https://github.com/dmnks/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
# There already is a default .bashrc
mv ~/.bashrc ~/.bashrc.orig
stow -v bash vim

# Install Vundle and all plugins
git clone https://github.com/gmarik/Vundle.vim.git \
    ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# Enable autohint on Monospace font
FONTCONFIG=~/.config/fontconfig
mkdir -p $FONTCONFIG
cat << EOF > $FONTCONFIG/fonts.conf
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <match target="pattern">
        <test qual="any" name="family">
            <string>Monospace</string>
        </test>
        <edit mode="assign" name="autohint">
            <bool>true</bool>
        </edit>
    </match>
</fontconfig>
EOF
