DNF_PATH=$HOME/code/dnf
LIBDNF_PATH=$HOME/code/libdnf
podman-dnf() {
    podman run \
        --detach-keys="ctrl-@" \
        -v=$DNF_PATH:/dnf:ro,z -v=$LIBDNF_PATH:/libdnf:ro,z \
        -it $@ dnf-workspace
}
