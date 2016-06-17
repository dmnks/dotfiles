# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

color() {
    echo "\[$(tput setaf $@)\]"
}

reset="\[$(tput sgr0)\]"
black=$(color 0)
red=$(color 1)
green=$(color 2)
yellow=$(color 3)
blue=$(color 4)
purple=$(color 5)
cyan=$(color 6)
white=$(color 7)
orange=$(color 9)

source /usr/share/git-core/contrib/completion/git-prompt.sh
PS1="$orange\u$blue@$yellow\h$blue: $green\W$blue\$(__git_ps1) $blue\$$reset "

alias diff="colordiff -u"

backport() {
    find $2 -name '*.orig' | xargs rm
    git diff $1 | patch -d $2 -p1
}

for script in $HOME/.bashrc.d/*.sh; do
    [ -f $script ] && source $script
done
