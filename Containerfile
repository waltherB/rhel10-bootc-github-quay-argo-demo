FROM registry.redhat.io/rhel10/rhel-bootc:latest

RUN dnf -y install \
    httpd \
    firewalld \
    jq \
    curl \
    vim-enhanced \
    bash-completion \
    && dnf clean all

COPY app/index.html /var/www/html/index.html
COPY files/motd /etc/motd

RUN systemctl enable httpd
RUN bootc container lint
