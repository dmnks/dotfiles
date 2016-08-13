# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

color() {
    echo "\[$(tput setaf $@)\]"
}

off="\[$(tput sgr0)\]"
red=$(color 9)
green=$(color 10)
yellow=$(color 11)
blue=$(color 12)
purple=$(color 13)
cyan=$(color 14)

source /usr/share/git-core/contrib/completion/git-prompt.sh
PS1="${cyan}\u${off}@${green}\h${off} ${yellow}\W${purple}\$(__git_ps1)${off} \\$ "

alias diff="colordiff -u"
diffls() {
    diff $@ | less -R
}

for script in $HOME/.bashrc.d/*.sh; do
    [ -f $script ] && source $script
done
