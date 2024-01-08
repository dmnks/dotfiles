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
    [ $# == 0 ] && set -- $(dirname $PWD | xargs basename)/$(basename $PWD)
    tmux has-session -t "$1" 2>/dev/null && return 0
    tmux new-session -ds "$1" -n "code"
    tmux send-keys -t "$1" "vim" C-m
    tmux new-window -t "$1" -n "git"
    tmux send-keys -t "$1" "tig status" C-m
    tmux new-window -t "$1" -n "build"
    tmux new-window -t "$1" -n "debug"
    tmux select-window -t ${1}:+1
    tmux attach -t "$1"
}
