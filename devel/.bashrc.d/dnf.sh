DNF_PATH=$HOME/projects/dnf
LIBDNF_BUILD=$HOME/projects/libdnf/build
LIBDNF_PATH=$LIBDNF_BUILD/libdnf
LIBDNF_PYTHON_PATH=$LIBDNF_BUILD/python/hawkey

function dnf-load-env() {
    export PYTHONPATH=$LIBDNF_PYTHON_PATH:$PYTHONPATH
    export LD_LIBRARY_PATH=$LIBDNF_PATH:$LD_LIBRARY_PATH
    export GI_TYPELIB_PATH=$LIBDNF_PATH:$GI_TYPELIB_PATH
    export PS1="(dnf)$PS1"
}

function dnf-docker() {
    docker build -t dnf $HOME/.dockerfile/dnf/
    docker run -v$DNF_PATH:/dnf:ro,z -v$LIBDNF_BUILD:/libdnf:ro,z -it $@ dnf
}
