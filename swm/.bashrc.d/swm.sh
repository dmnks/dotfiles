dnf-container() {
    podman run \
         --detach-keys="ctrl-@" \
         -e TERM -it \
         -v=$PWD/dnf:/dnf \
         -v=$PWD/libdnf:/libdnf \
         -v=$PWD/ci/dnf-behave-tests:/test \
         -it $@ dnf-devel
}

tmux-init() {
    case $1 in
    "utils")
        tmux new-session -ds "utils" -n "chat"
        tmux send-keys "weechat" C-m
        tmux new-window -t "utils" -n "wiki"
        tmux send-keys "vim -c 'VimwikiIndex'" C-m
        tmux attach -t "utils"
        ;;
    "devel")
        local name=$2
        tmux new-session -ds "$name" -n "code"
        tmux send-keys "vim" C-m
        tmux new-window -t "$name" -n "git"
        tmux send-keys "tig status" C-m
        tmux new-window -t "$name" -n "build"
        tmux attach -t "$name"
        ;;
    esac
}
