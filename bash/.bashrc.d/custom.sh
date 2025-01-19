export EDITOR=nvim
alias vim=nvim

if which git &>/dev/null; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"
    GIT_PS1_SHOWSTASHSTATE=1
    alias gdiff='git diff --no-index --'
fi

accent_color() {
    local arg=$1
    case $(dconf read /org/gnome/desktop/interface/accent-color | tr -d \') in
        blue)   echo '#458588 #83a598' ;;
        teal)   echo '#689d6a #8ec07c' ;;
        green)  echo '#98971a #b8bb26' ;;
        yellow) echo '#d79921 #fabd2f' ;;
        orange) echo '#d65d0e #fe8019' ;;
        red)    echo '#cc241d #fb4934' ;;
        purple) echo '#b16286 #d3869b' ;;
        slate)  echo '#a89984 #ebdbb2' ;;
    esac | cut -d' ' -f$arg
}

if which fzf &>/dev/null; then
    source /usr/share/fzf/shell/key-bindings.bash
    export ACCENT_COLOR_BG=$(accent_color 1)
    export ACCENT_COLOR_FG=$(accent_color 2)
    export FZF_DEFAULT_OPTS="
        --layout=reverse
        --color='pointer:$ACCENT_COLOR_FG,prompt:$ACCENT_COLOR_FG'
        --color='marker:$ACCENT_COLOR_FG,spinner:$ACCENT_COLOR_FG'
        --color='hl+:$ACCENT_COLOR_FG'
        --color='hl:#928374,fg+:#fbf1c7,bg+:#3c3836,header:#7c6f64'
        --color='gutter:-1,scrollbar:#504945,info:#7c6f64'
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
