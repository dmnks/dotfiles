# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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

source /usr/share/git-core/contrib/completion/git-prompt.sh 2>/dev/null
PS1="[${green}\u${off}@${green}\h${off} \W\$(declare -F __git_ps1 &>/dev/null && __git_ps1)]\\$ "

gdiff () { colordiff -u $@ | less -R; }

for script in $HOME/.bashrc.d/*.sh; do
    [ -f $script ] && source $script
done
