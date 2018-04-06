function ddnf() {
    dnf_path=$HOME/projects/dnf
    libdnf_path=$HOME/projects/libdnf/build/
    docker build -t dnf $HOME/.dockerfile/dnf/
    docker run -v$dnf_path:/dnf:ro,z -v$libdnf_path:/libdnf:ro,z -it $@ dnf
}
