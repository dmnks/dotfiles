# DNF stack development image

FROM fedora:29

# Install build deps
RUN dnf install -y dnf-plugins-core && \
    dnf config-manager --setopt=tsflags= --save
RUN dnf install -y \
        check-devel \
        cmake \
        cppunit-devel \
        gcc \
        gcc-c++ \
        gettext \
        glib2-devel \
        gpgme-devel \
        gtk-doc \
        json-c-devel \
        libmodulemd-devel \
        librepo-devel \
        libsmartcols-devel \
        libsolv-devel \
        libsolv-tools \
        libstdc++ \
        make \
        python2-breathe \
        python2-devel \
        python2-nose \
        python2-sphinx \
        python3-breathe \
        python3-devel \
        python3-gobject \
        python3-nose \
        python3-sphinx \
        rpm-devel \
        sqlite-devel \
        swig
# Hack
RUN dnf install -y --allowerasing libmodulemd1-devel
# Install debugging tools
RUN dnf install -y \
        python3-pip \
        python3-ipdb
RUN pip3 install --upgrade pip && pip3 install pudb
# Get rid of the system installations
RUN rpm -e --nodeps \
    libdnf \
    python3-libdnf \
    dnf \
    dnf-data \
    python3-dnf \
    python3-hawkey
RUN ln -s /usr/local/bin/dnf-3 /usr/bin/dnf

# Copy in the source trees
COPY libdnf /libdnf
COPY dnf dnf/

# Build & install them
RUN mkdir -p /build/{libdnf,dnf}
WORKDIR /build/libdnf
RUN cmake /libdnf -DCMAKE_INSTALL_PREFIX=/ -DPYTHON_DESIRED=3 && \
    make && \
    make install
WORKDIR /build/dnf
RUN cmake /dnf -DPYTHON_DESIRED=3 && \
    make && \
    make doc && \
    make install
WORKDIR /build

VOLUME ["/libdnf", "/dnf"]
ENTRYPOINT ["/bin/bash"]
