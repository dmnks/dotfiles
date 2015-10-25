#!/bin/bash
# Bootstrap a new system

set -o errexit

sudo yum install -y git stow python-pip tmux ack
sudo pip install flake8

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

# Configure GNOME

# Solarize gnome-terminal.  Note that the latest version already has Solarized
# presets built in but we have to specify the colors manually when setting the
# theme via dconf anyway.
GTPROFILE=":b1dcc9dd-5262-4d8d-a863-c897e6d979b9"
GTDIR="/org/gnome/terminal/legacy/profiles:/$GTPROFILE"
# Use the custom powerline font due to vim-airline
GTFONT="DejaVu Sans Mono for Powerline 11"
GTPALETTE="['rgb(7,54,66)', 'rgb(220,50,47)', 'rgb(133,153,0)',
            'rgb(181,137,0)', 'rgb(38,139,210)', 'rgb(211,54,130)',
            'rgb(42,161,152)', 'rgb(238,232,213)', 'rgb(0,43,54)',
            'rgb(203,75,22)', 'rgb(88,110,117)', 'rgb(101,123,131)',
            'rgb(131,148,150)', 'rgb(108,113,196)', 'rgb(147,161,161)',
            'rgb(253,246,227)']"
GTBG="rgb(0,43,54)"
GTFG="rgb(131,148,150)"
dconf write $GTDIR/use-system-font false
dconf write $GTDIR/font "'$GTFONT'"
dconf write $GTDIR/palette "$GTPALETTE"
dconf write $GTDIR/use-theme-colors false
dconf write $GTDIR/background-color "'$GTBG'"
dconf write $GTDIR/foreground-color "'$GTFG'"

echo
echo "Bootstrap complete!"
echo "Restart gnome-terminal to apply all changes."
