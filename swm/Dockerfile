# DNF stack development image

FROM fedora:30

# Install build deps
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
        man-db \
        python2-breathe \
        python2-devel \
        python2-nose \
        python2-sphinx \
        python3-behave \
        python3-breathe \
        python3-devel \
        python3-gobject \
        python3-nose \
        python3-rpmfluff \
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
COPY dnf /dnf

# Prepare build environment
RUN mkdir -p /build/{libdnf,dnf}
WORKDIR /build/libdnf
RUN cmake /libdnf -DCMAKE_INSTALL_PREFIX=/ -DPYTHON_DESIRED=3
WORKDIR /build/dnf
RUN cmake /dnf -DPYTHON_DESIRED=3
WORKDIR /test
RUN echo "cmake /build/libdnf && cmake /build/dnf" \
    > /usr/local/bin/prep && chmod +x /usr/local/bin/prep
RUN echo "make -C /build/libdnf install && \
          make -C /build/dnf doc && \
          make -C /build/dnf install" \
    > /usr/local/bin/build && chmod +x /usr/local/bin/build

# Fake rpmdb records
ENV VLIB 0.30.0
ENV VDNF 4.2.2
RUN python3 -c "import rpmfluff; \
                b = rpmfluff.SimpleRpmBuild('libdnf', '${VLIB}', '1'); \
                b.make(); print(b.get_built_rpm('x86_64')); \
                b = rpmfluff.SimpleRpmBuild('dnf', '${VDNF}', '1', \
                                            buildArchs=['noarch']); \
                b.make(); print(b.get_built_rpm('noarch'))" \
    | xargs rpm -i --nodeps --justdb

VOLUME ["/libdnf", "/dnf", "/test"]
ENTRYPOINT ["/bin/bash"]
