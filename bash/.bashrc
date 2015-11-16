# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
setup_prompt() {
    local reset="\[\033[0m\]"
    local black="\[\033[0;30m\]"
    local red="\[\033[0;31m\]"
    local green="\[\033[0;32m\]"
    local yellow="\[\033[0;33m\]"
    local blue="\[\033[0;34m\]"
    local purple="\[\033[0;35m\]"
    local cyan="\[\033[0;36m\]"
    local white="\[\033[0;37m\]"
    local orange="\[\033[1;31m\]"
    source /usr/share/git-core/contrib/completion/git-prompt.sh
    PS1="$orange\u$blue@$yellow\h$blue: $green\W$blue\$(__git_ps1) $blue\$$reset "
}

setup_prompt
unset setup_prompt
