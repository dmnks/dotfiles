# DNF development image

FROM fedora:27

RUN dnf install -y \
        python3-gobject \
        python3-ipdb \
        python3-pip
RUN pip3 install --upgrade pip && pip3 install pudb
RUN rpm -e --nodeps dnf

ENV PATH=/dnf/bin:$PATH \
    PYTHONPATH=/libdnf/python/hawkey \
    LD_LIBRARY_PATH=/libdnf/libdnf \
    GI_TYPELIB_PATH=/libdnf/libdnf
VOLUME ["/dnf", "/libdnf"]
ENTRYPOINT ["/bin/bash"]
