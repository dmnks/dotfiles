tmdev() {
    NAME=$(basename $PWD)
    tmux new-session -ds "$NAME" -n "code"
    tmux send-keys "vim" C-m
    tmux new-window -t "$NAME" -n "git"
    tmux send-keys "tig status" C-m
    tmux new-window -t "$NAME" -n "build"
    tmux attach -t "$NAME"
}

tmutil() {
    tmux new-session -ds "utils" -n "chat"
    tmux send-keys "weechat" C-m
    tmux new-window -t "utils" -n "wiki"
    tmux send-keys "vim -c 'VimwikiIndex'" C-m
    tmux attach -t "utils"
}
