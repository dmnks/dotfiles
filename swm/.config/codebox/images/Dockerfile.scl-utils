# SCL-UTILS development image
# vi:syntax=dockerfile

FROM registry.access.redhat.com/ubi8
ARG BASEOS
ARG APPSTREAM

RUN sed -i '/tsflags=nodocs/d' /etc/dnf/dnf.conf

# Set up repos
RUN echo -e "[baseos]\nname=BaseOS\nbaseurl=$BASEOS\ngpgcheck=0\n" \
    > /etc/yum.repos.d/rhel.repo
RUN echo -e "[appstream]\nname=AppStream\nbaseurl=$APPSTREAM\ngpgcheck=0" \
    >> /etc/yum.repos.d/rhel.repo

# Set up EPEL
RUN dnf install -y \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

RUN dnf install -y \
        bash-completion \
        bzip2 \
        cmake \
        diffutils \
        dnf-plugins-core \
        findutils \
        fpaste \
        gcc \
        git \
        gnupg \
        gnupg2-smime \
        hostname \
        iputils \
        keyutils \
        less \
        lsof \
        make \
        man-db \
        man-pages \
        mlocate \
        openssh-clients \
        passwd \
        procps-ng \
        rpm-devel \
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

CMD /bin/bash
