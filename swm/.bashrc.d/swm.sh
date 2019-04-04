podman-dnf() {
    podman run \
        --detach-keys="ctrl-@" \
        -e TERM -it \
        -v=$PWD/dnf:/dnf \
        -v=$PWD/libdnf:/libdnf \
        -v=$PWD/ci-dnf-stack/dnf-behave-tests:/test \
        -it $@ dnf-devel
}
