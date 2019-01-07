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

alias gdiff='git diff --no-index --'

###############################################################################
# Functions
###############################################################################

setup_ps1() {
    local c_red=$(tput setaf 9)
    local c_green=$(tput setaf 10)
    local c_yellow=$(tput setaf 11)
    local c_blue=$(tput setaf 12)
    local c_purple=$(tput setaf 13)
    local c_cyan=$(tput setaf 14)
    local c_off=$(tput sgr0)
    c_dollar() {
        [ $? -eq 0 ] && tput sgr0 || tput setaf 9
    }
    PS1="\[${c_green}\]-> \[${c_cyan}\]\W"
    PS1+="\[${c_purple}\]\$(__git_ps1 \"(%s)\")"
    PS1+="\[\$(c_dollar)\]\$\[${c_off}\] "
    export PS1
}

podman-clean() {
    local cnts=$(podman ps -a --format="{{.ID}}" --filter=status=exited)
    local imgs=$(podman images --filter=dangling=true 2>/dev/null)
    [ -n "$cnts" ] && podman rm $cnts
    [ -n "$imgs" ] && podman rmi $imgs || true
}

###############################################################################
# Environment
###############################################################################

setup_ps1
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

export EDITOR=vim
