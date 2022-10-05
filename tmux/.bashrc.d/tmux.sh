alias tmux="systemd-run --quiet --scope --user tmux"

tm() {
    NAME=$(basename $PWD)

    tmux new-session -ds "$NAME" -x 255 -n "code"
    tmux send-keys "vim" C-m

    tmux new-window -t "$NAME" -n "git"
    tmux split-window -h -b -l 161
    tmux send-keys "tig status" C-m

    tmux new-window -t "$NAME" -n "build"
    tmux split-window -h -b -l 161

    tmux attach -t "$NAME"
}
