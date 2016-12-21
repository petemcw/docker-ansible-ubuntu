FROM ubuntu:16.04
MAINTAINER Pete McWilliams

# environment
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/root"
ENV APTLIST \
    apt-utils \
    python-software-properties \
    rsyslog \
    software-properties-common \
    sudo \
    systemd \
    systemd-cron

# packages & configure
RUN \
    apt-get -yqq update && \
    apt-get -yqq install --no-install-recommends --no-install-suggests $APTLIST && \
    apt-get -yqq purge --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc /usr/share/man

RUN \
    add-apt-repository -y ppa:ansible/ansible && \
    apt-get -yqq update && \
    apt-get -yqq install --no-install-recommends --no-install-suggests ansible && \
    apt-get -yqq purge --auto-remove -o APT::AutoRemove::RecommendsImportant=false && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc /usr/share/man

RUN \
    sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf
COPY initctl_faker .
RUN \
    chmod +x initctl_faker && \
    rm -fr /sbin/initctl && \
    ln -s /initctl_faker /sbin/initctl

# ansible inventory file
RUN \
    echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

CMD ["/lib/systemd/systemd"]
