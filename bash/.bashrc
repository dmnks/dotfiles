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
promptcmd() {
    local status=$?
    local dollar
    [ $status != 0 ] && dollar=$red'$'$off || dollar=$off'$'
    PS1="${green}\u@\h${off}:${cyan}\W${purple}\$(__git_ps1 '(%s)')${dollar} "
}

off="\[$(tput sgr0)\]"
red=$(color 9)
green=$(color 10)
yellow=$(color 11)
blue=$(color 12)
purple=$(color 13)
cyan=$(color 14)

PROMPT_COMMAND=promptcmd
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM=1
GIT_PS1_SHOWSTASHSTATE=1
source /usr/share/git-core/contrib/completion/git-prompt.sh

alias docker='sudo docker'

gdiff () { colordiff -u $@ | less -R; }
dclean() {
    docker rm $(docker ps --filter "status=exited" -qa --no-trunc) 2>/dev/null
    docker rmi $(docker images --filter "dangling=true" -q --no-trunc) \
        2>/dev/null
}

for script in $HOME/.bashrc.d/*.sh; do
    [ -f $script ] && source $script
done

unset color
