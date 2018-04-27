DNF_PATH=$HOME/projects/dnf
LIBDNF_PATH=$HOME/projects/libdnf

function dnf-docker() {
    docker build -t dnf -f $HOME/.dockerfile/dnf $HOME/.dockerfile/
    docker run -v$DNF_PATH:/dnf:ro,z -v$LIBDNF_PATH:/libdnf:ro,z -it $@ dnf
}
