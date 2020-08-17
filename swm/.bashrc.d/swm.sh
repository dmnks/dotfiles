tmux-ide() {
    NAME=$(basename $PWD)
    tmux new-session -ds "$NAME" -n "code"
    tmux send-keys "vim" C-m
    tmux new-window -t "$NAME" -n "git"
    tmux send-keys "tig status" C-m
    tmux new-window -t "$NAME" -n "build"
    tmux attach -t "$NAME"
}
