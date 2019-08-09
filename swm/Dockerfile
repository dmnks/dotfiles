# DNF stack development image

FROM registry.fedoraproject.org/fedora:31

ENV LIBDNF_VERSION 0.35.1
ENV DNF_VERSION 4.2.8

RUN sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf

# Install basic packages
RUN dnf install -y \
        bash-completion \
        bzip2 \
        diffutils \
        dnf-plugins-core \
        findutils \
        flatpak-xdg-utils \
        fpaste \
        git \
        gnupg \
        gnupg2-smime \
        hostname \
        iputils \
        jwhois \
        keyutils \
        krb5-libs \
        less \
        lsof \
        man-db \
        man-pages \
        mlocate \
        mtr \
        openssh-clients \
        passwd \
        pigz \
        procps-ng \
        rsync \
        shadow-utils \
        sudo \
        tcpdump \
        time \
        traceroute \
        tree \
        unzip \
        vte-profile \
        wget \
        which \
        words \
        xz \
        zip

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

RUN dnf install -y --allowerasing libmodulemd1-devel

# Install development tools
RUN dnf install -y \
        python3-pip \
        python3-ipdb \
        tito \
        vim
RUN pip3 install --upgrade pip && pip3 install pudb

RUN dnf clean all

# Replace system installations with fake rpmdb entries
RUN rpm -e --nodeps \
    libdnf \
    python3-libdnf \
    dnf \
    dnf-data \
    python3-dnf \
    python3-hawkey
RUN ln -s /usr/local/bin/dnf-3 /usr/bin/dnf
RUN python3 -c "import rpmfluff; \
                b = rpmfluff.SimpleRpmBuild('libdnf', '${LIBDNF_VERSION}', '1'); \
                b.make(); print(b.get_built_rpm('x86_64')); \
                b = rpmfluff.SimpleRpmBuild('dnf', '${DNF_VERSION}', '1', buildArchs=['noarch']); \
                b.make(); print(b.get_built_rpm('noarch'))" \
    | xargs rpm -i --nodeps --justdb

VOLUME /host
WORKDIR /host
CMD /bin/bash
