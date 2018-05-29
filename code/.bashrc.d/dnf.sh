DNF_PATH=$HOME/code/dnf
LIBDNF_PATH=$HOME/code/libdnf

function dnf-docker() {
    docker build -t dnf -f $HOME/.dockerfile/dnf $HOME/.dockerfile/
    docker run -v$DNF_PATH:/dnf:ro,z -v$LIBDNF_PATH:/libdnf:ro,z -it $@ dnf
}
