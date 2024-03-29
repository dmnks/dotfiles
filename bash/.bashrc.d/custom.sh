if [ ! -f /run/.toolboxenv ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
    source /usr/share/fzf/shell/key-bindings.bash

    export FZF_DEFAULT_OPTS='
        --layout=reverse
        --color="pointer:#cc241d,prompt:#cc241d,marker:#cc241d,spinner:#cc241d"
        --color="hl:#928374,fg+:#ebdbb2,bg+:#3c3836,hl+:#cc241d,header:#928374"
        --color="border:#928374"
    '

    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWSTASHSTATE=1

    export EDITOR=vim

    alias gdiff='git diff --no-index --'
    alias ls='lsd'
    alias tree='ls --tree'
fi

setup_ps1() {
    local red="\[$(tput setaf 9)\]"
    local green="\[$(tput setaf 10)\]"
    local yellow="\[$(tput setaf 11)\]"
    local blue="\[$(tput setaf 12)\]"
    local purple="\[$(tput setaf 13)\]"
    local cyan="\[$(tput setaf 14)\]"
    local reset="\[$(tput sgr0)\]"

    local toolbox
    local gitps

    dollar() {
        [ $? -eq 0 ] || echo -e "\001$(tput setaf 9)\002"
    }

    if [ -f /run/.toolboxenv ]; then
        toolbox="${purple}󰆧${reset} "
    else
        gitps="\$(__git_ps1 \"${purple}%s \")"
    fi

    PS1="${toolbox}${green}󰁕 \W ${gitps}"
    PS1+="\$(dollar)\$${reset} "

    export PS1
}

setup_ps1
