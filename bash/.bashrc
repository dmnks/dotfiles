# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions

# If not running interactively, go with the distro defaults
[ -z "$PS1" ] && return

###############################################################################
# Sources
###############################################################################

source /usr/share/git-core/contrib/completion/git-prompt.sh

###############################################################################
# Aliases
###############################################################################

alias docker='sudo docker'
alias gdiff='git diff --no-index --'

###############################################################################
# Functions
###############################################################################

promptcmd() {
    local status=$?
    local c_red="\[$(tput setaf 9)\]"
    local c_green="\[$(tput setaf 10)\]"
    local c_yellow="\[$(tput setaf 11)\]"
    local c_blue="\[$(tput setaf 12)\]"
    local c_purple="\[$(tput setaf 13)\]"
    local c_cyan="\[$(tput setaf 14)\]"
    local c_off="\[$(tput sgr0)\]"
    if [ $status != 0 ]; then
        local c_dollar=$c_red
    else
        local c_dollar=$c_off
    fi
    __git_ps1 "${c_green}\u@\h${c_off}:${c_cyan}\W${c_purple}" \
        "${c_dollar}\$${c_off} " "(%s)"
}

dclean() {
    local cnts=$(docker ps --filter "status=exited" -qa --no-trunc)
    local imgs=$(docker images --filter "dangling=true" -q --no-trunc)
    [ -n "$cnts" ] && docker rm $cnts
    [ -n "$imgs" ] && docker rmi $imgs || true
}

###############################################################################
# Environment
###############################################################################

PROMPT_COMMAND=promptcmd
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWSTASHSTATE=1

###############################################################################
# Misc
###############################################################################

if [ -d $HOME/.bashrc.d ]; then
    for script in $HOME/.bashrc.d/*.sh; do
        [ -f $script ] && source $script
    done
fi
