#!/bin/bash
# Bootstrap a new system

sudo yum install -y git stow python-pip
sudo pip install pyflakes pep8

# Clone the repo
git clone https://github.com/dmnks/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Compile the latest vim
./getvim.sh

# Install the dotfiles
mv ~/.bashrc ~/.bashrc.orig  # There's a default .bashrc already
stow -v bash vim dircolors

# Install Vundle and all plugins
git clone https://github.com/gmarik/Vundle.vim.git \
    ~/.vim/bundle/Vundle.vim
vim -u .vundle +PluginInstall +qall

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

# Solarize gnome-terminal
cat << EOF | dconf load /org/gnome/terminal/legacy/profiles:/
[/]
list=['008b70f0-ffc2-402a-a275-95cd1fc06fc9', 'dd4c8425-8e92-4364-8b3d-8b762d9fdb2f']
default='008b70f0-ffc2-402a-a275-95cd1fc06fc9'

[:008b70f0-ffc2-402a-a275-95cd1fc06fc9]
background-color='#fdfdf6f6e3e3'
use-theme-colors=false
palette=['#070736364242', '#DCDC32322F2F', '#858599990000', '#B5B589890000', '#26268B8BD2D2', '#D3D336368282', '#2A2AA1A19898', '#EEEEE8E8D5D5', '#00002B2B3636', '#CBCB4B4B1616', '#58586E6E7575', '#65657B7B8383', '#838394949696', '#6C6C7171C4C4', '#9393A1A1A1A1', '#FDFDF6F6E3E3']
bold-color-same-as-fg=false
bold-color='#58586e6e7575'
foreground-color='#65657b7b8383'
visible-name='Solarized Light'

[:dd4c8425-8e92-4364-8b3d-8b762d9fdb2f]
background-color='#00002B2B3636'
use-theme-colors=false
palette=['#070736364242', '#DCDC32322F2F', '#858599990000', '#B5B589890000', '#26268B8BD2D2', '#D3D336368282', '#2A2AA1A19898', '#EEEEE8E8D5D5', '#00002B2B3636', '#CBCB4B4B1616', '#58586E6E7575', '#65657B7B8383', '#838394949696', '#6C6C7171C4C4', '#9393A1A1A1A1', '#FDFDF6F6E3E3']
bold-color-same-as-fg=false
bold-color='#9393a1a1a1a1'
foreground-color='#838394949696'
visible-name='Solarized Dark'
EOF

# Use the new dircolors right now
eval `dircolors ~/.dir_colors`
