# RPM development image
# vi:syntax=dockerfile

FROM registry.fedoraproject.org/fedora:31

RUN sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf

RUN dnf install -y \
        /usr/bin/gdb-add-index \
        audit-libs-devel \
        autoconf \
        automake \
        bash-completion \
        bzip2 \
        bzip2-devel \
        cpio \
        dbus-devel \
        diffutils \
        dnf-plugins-core \
        doxygen \
        dwz \
        elfutils \
        elfutils binutils \
        elfutils-devel \
        elfutils-libelf-devel \
        fakechroot which \
        file \
        file-devel \
        findutils \
        flatpak-xdg-utils \
        fpaste \
        gawk \
        gcc \
        gdb \
        gettext-devel \
        git \
        git-core \
        gnupg \
        gnupg2-smime \
        grep \
        gzip \
        hostname \
        ima-evm-utils-devel \
        iputils \
        jwhois \
        keyutils \
        krb5-libs \
        less \
        libacl-devel \
        libarchive-devel \
        libcap-devel \
        libdb-devel \
        libfaketime \
        libgcrypt-devel \
        libselinux-devel \
        libtool \
        libzstd-devel \
        lmdb-devel \
        lsof \
        lua-devel \
        make \
        man-db \
        man-pages \
        mlocate \
        mtr \
        openssh-clients \
        openssl-devel \
        passwd \
        patch \
        pigz \
        pkgconfig \
        pinentry \
        popt-devel \
        procps-ng \
        pyftpdlib \
        python3-devel \
        readline-devel \
        redhat-rpm-config \
        rpm-build \
        rpm-sign \
        rsync \
        sed \
        shadow-utils \
        sqlite-devel \
        sudo \
        tar \
        tcpdump \
        time \
        traceroute \
        tree \
        unzip \
        valgrind \
        vte-profile \
        wget \
        which \
        words \
        xz \
        xz-devel \
        zip \
        zlib-devel

CMD /bin/bash
