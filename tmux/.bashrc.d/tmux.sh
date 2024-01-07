if [ -f /run/.toolboxenv ]; then
    alias tmux="tmux -L $(sh -c 'source /run/.containerenv; echo $name')"
else
    alias tmux="systemd-run --quiet --scope --user tmux"
fi

workspace() {
    [ $# == 0 ] && set -- $(dirname $PWD | xargs basename)/$(basename $PWD)
    tmux new-session -ds "$1" -n "code"
    tmux send-keys "vim" C-m
    tmux new-window -t "$1" -n "git"
    tmux send-keys "tig status" C-m
    tmux new-window -t "$1" -n "build"
    tmux attach -t "$1"
}
