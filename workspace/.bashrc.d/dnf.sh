DNF_PATH=$HOME/projects/dnf
LIBDNF_LIBS=$HOME/projects/libdnf/build/libdnf
LIBDNF_PYTHON=$HOME/projects/libdnf/build/python/hawkey

alias dnf="LD_LIBRARY_PATH=$LIBDNF_LIBS \
           GI_TYPELIB_PATH=$LIBDNF_LIBS \
           PYTHONPATH=$LIBDNF_PYTHON $DNF_PATH/bin/dnf-3"
