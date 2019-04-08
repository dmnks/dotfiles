dnf-run() {
    local bin=$1
    shift
    $bin run \
         --detach-keys="ctrl-@" \
         -e TERM -it \
         -v=$PWD/dnf:/dnf \
         -v=$PWD/libdnf:/libdnf \
         -v=$PWD/ci-dnf-stack/dnf-behave-tests:/test \
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
        tmux new-session -ds "devel" -n "code"
        tmux send-keys "vim" C-m
        tmux new-window -t "devel" -n "git"
        tmux send-keys "tig status" C-m
        tmux new-window -t "devel" -n "build"
        tmux attach -t "devel"
        ;;
    esac
}
