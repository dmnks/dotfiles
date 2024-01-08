if [ -f /run/.toolboxenv ]; then
    alias tmux="tmux -L $(sh -c 'source /run/.containerenv; echo $name')"
else
    alias tmux="systemd-run --quiet --scope --user tmux"
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
