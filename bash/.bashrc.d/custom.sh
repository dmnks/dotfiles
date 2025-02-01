export EDITOR=nvim
alias vim=nvim

source ~/.theme/bashrc

if which git &>/dev/null; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWSTASHSTATE=1
    alias gdiff='git diff --no-index --'
fi

if which /usr/bin/fzf &>/dev/null; then
    source /usr/share/fzf/shell/key-bindings.bash
fi

if which lsd &>/dev/null; then
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
    local prompt=${green}

    local toolbox
    local gitps="\$(__git_ps1 \"${purple}%s \")"
    local shlvl=$(( SHLVL - 1 ))
    local level=

    dollar() {
        [ $? -eq 0 ] || echo -e "\001$(tput setaf 9)\002"
    }

    [ -f /run/.toolboxenv ] && toolbox="${purple}󰆧${reset} "
    [ $UID == 0 ] && prompt=${red}
    [ -n "$TMUX" ] && shlvl=$(( shlvl - 1 ))
    [ $shlvl -gt 0 ] && level="${blue}$(printf '%.0s' $(seq 1 $shlvl)) "

    PS1="${toolbox}${prompt}󰁕 \W ${gitps}${level}"
    PS1+="\$(dollar)\$${reset} "

    export PS1
}

setup_ps1
