# DNF development image

FROM fedora:29

RUN dnf install -y \
        libstdc++ \
        python3-gobject \
        python3-ipdb \
        python3-pip
RUN pip3 install --upgrade pip && pip3 install pudb
RUN rpm -e --nodeps dnf libdnf
RUN echo "alias dnf='dnf-3 --setopt=pluginpath=/plugins'" >> ~/.bashrc

# Use dnf and libdnf checkouts mounted from the host
ENV PATH=/dnf/bin:$PATH \
    PYTHONPATH=/libdnf/build/python/hawkey:/plugins \
    LD_LIBRARY_PATH=/libdnf/build/libdnf \
    GI_TYPELIB_PATH=/libdnf/build/libdnf

# Create a python namespace package "libdnf" (to emulate proper installation)
WORKDIR /usr/lib64/python3.6/
RUN mkdir libdnf && \
    echo "__path__ = ['/libdnf/build/bindings/python/']; from . import conf" \
        > libdnf/__init__.py
WORKDIR /

VOLUME ["/dnf", "/libdnf", "/plugins"]
ENTRYPOINT ["/bin/bash"]
