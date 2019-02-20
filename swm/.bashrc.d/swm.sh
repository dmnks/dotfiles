podman-dnf() {
    podman run \
        --detach-keys="ctrl-@" \
        -e TERM -it \
        -v=$PWD/dnf:/dnf \
        -v=$PWD/libdnf:/libdnf \
        -it $@ dnf-devel
}
