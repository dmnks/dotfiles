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
alias docker='sudo docker --config $HOME/.docker'
alias docker-clean='clean_containers "sudo docker"'
alias podman-clean='clean_containers podman'

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
    PS1="\[${c_green}\]"
    [ "$HOSTNAME" != "thinkpad" ] && PS1+="[$HOSTNAME]"
    PS1+="-> \[${c_cyan}\]\W"
    PS1+="\[${c_purple}\]\$(__git_ps1 \"(%s)\")"
    PS1+="\[\$(c_dollar)\]"
    [ "$EUID" != 0 ] && PS1+="\$" || PS1+="#"
    PS1+="\[${c_off}\] "
    export PS1
}

clean_containers() {
    local bin=$1
    local conts=$($bin ps -qa --filter=status=exited --no-trunc)
    local images=$($bin images -q --filter=dangling=true --no-trunc \
                 2>/dev/null)
    [ -n "$conts" ] && $bin rm -f $conts
    [ -n "$images" ] && $bin rmi -f $images || true
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

bind '"\C-o":"mc -u\C-m"'

if [ -d $HOME/.bashrc.d ]; then
    for script in $HOME/.bashrc.d/*.sh; do
        [ -f $script ] && source $script
    done
fi

export EDITOR=vim
