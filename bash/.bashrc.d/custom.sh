export EDITOR=nvim
alias vim=nvim

source ~/.theme/bashrc

accent_color() {
    local arg=$1
    local col=$(dconf read /org/gnome/desktop/interface/accent-color | tr -d \')
    _accent_color $col | cut -d' ' -f$arg
}

export ACCENT_COLOR_BG=$(accent_color 1)
export ACCENT_COLOR_FG=$(accent_color 2)

if which git &>/dev/null; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWSTASHSTATE=1
    alias gdiff='git diff --no-index --'
fi

if which fzf &>/dev/null; then
    source /usr/share/fzf/shell/key-bindings.bash
    export FZF_DEFAULT_OPTS="
        --layout=reverse
        --color='pointer:$ACCENT_COLOR_FG,prompt:$ACCENT_COLOR_FG'
        --color='marker:$ACCENT_COLOR_FG,spinner:$ACCENT_COLOR_FG'
        --color='hl+:$ACCENT_COLOR_FG'
        --color='hl:$THEME_COLOR_DIM1,fg+:$THEME_COLOR_ACTIVE_FG'
        --color='bg+:$THEME_COLOR_ACTIVE_BG,header:$THEME_COLOR_DIM2'
        --color='scrollbar:$THEME_COLOR_DIM4,info:$THEME_COLOR_DIM2,gutter:-1'
        --no-bold
        --info=inline-right
        --scrollbar=█
        --pointer=''
        --header=''
        --border=none
        --padding=1,2
        --no-separator
        --highlight-line
    "
fi

if which eza &>/dev/null; then
    alias ls='eza'
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
