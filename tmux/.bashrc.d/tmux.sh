if [ -f /run/.toolboxenv ]; then
    alias tmux="tmux -L $(sh -c 'source /run/.containerenv; echo $name')"
else
    alias tmux="systemd-run --quiet --scope --user tmux"
    export FZF_DEFAULT_OPTS='
        --layout=reverse
        --color="pointer:#cc241d,prompt:#cc241d,marker:#cc241d,spinner:#cc241d"
        --color="hl:#928374,fg+:#ebdbb2,bg+:#3c3836,hl+:#cc241d,header:#928374"
        --color="border:#928374"
    '
fi

workspace() {
    local size
    [ $# == 0 ] && set -- $(dirname $PWD | xargs basename)/$(basename $PWD)
    if [ -z "$TMUX" ]; then
        size=12
    else
        size=11
    fi

    if ! tmux has-session -t "$1" 2>/dev/null; then
        tmux new-session -ds "$1" -n "code" \
                         -x "$(tput cols)" -y "$(tput lines)" "vim"
        tmux new-window -t "$1" -n "git" "tig status"
        tmux split-window -t "$1" -l$size -d
        tmux new-window -t "$1" -n "build"
        tmux new-window -t "$1" -n "debug"
        tmux split-window -t "$1" -l$size -d
        tmux select-window -t ${1}:+1
    fi

    if [ -z "$TMUX" ]; then
        tmux attach -t "$1"
    else
        tmux switch-client -t "$1"
    fi
}
