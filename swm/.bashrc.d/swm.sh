DNF_PATH=$HOME/code/dnf
DNF_PLUGINS_PATH=$HOME/code/dnf-plugins-core/plugins
LIBDNF_PATH=$HOME/code/libdnf
podman-dnf() {
    podman run \
        --detach-keys="ctrl-@" \
        -v=$DNF_PATH:/dnf:ro,z \
        -v=$DNF_PLUGINS_PATH:/plugins:ro,z \
        -v=$LIBDNF_PATH:/libdnf:ro,z \
        -it $@ dnf-devel
}
