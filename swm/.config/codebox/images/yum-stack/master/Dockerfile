# YUM stack development image

FROM registry.access.redhat.com/rhel7
ARG BASEURL
ARG OPTURL
ARG CHECKOUT

RUN sed -i '/tsflags=nodocs/d' /etc/yum.conf

# Set up repos
RUN echo -e "[base]\nname=base\nbaseurl=$BASEURL\ngpgcheck=0\n" \
    > /etc/yum.repos.d/rhel.repo
RUN echo -e "[optional]\nname=optional\nbaseurl=$OPTURL\ngpgcheck=0" \
    >> /etc/yum.repos.d/rhel.repo

# Set up EPEL
RUN yum install -y \
        https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install useful stuff
RUN yum install -y \
        bash-completion \
        git \
        ipython \
        less \
        man-db \
        man-pages \
        python-ipdb \
        python-pip \
        sudo \
        time \
        tree \
        wget \
        which \
        yum-utils
RUN rpm -e --nodeps yum
RUN rm -rf /var/cache/yum
RUN pip install --upgrade pip && pip install pudb

# Use the YUM checkout mounted from the host
ENV PATH=$CHECKOUT/bin:$PATH \
    PYTHONPATH=$CHECKOUT:$PYTHONPATH
RUN ln -s $CHECKOUT/etc/yum.conf /etc/yum.conf
RUN ln -s $CHECKOUT/etc/version-groups.conf /etc/yum/version-groups.conf

CMD /bin/bash
