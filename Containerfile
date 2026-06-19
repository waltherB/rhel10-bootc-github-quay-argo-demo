FROM registry.redhat.io/rhel10/rhel-bootc:latest

# Build-time args (passed from CI)
ARG RHSM_ACTIVATION_KEY
ARG RHSM_ORG

# Register, enable repos, install packages, then unregister and clean entitlement files in one RUN
RUN set -eux; \
    if [ -n "$RHSM_ACTIVATION_KEY" ] && [ -n "$RHSM_ORG" ]; then \
      subscription-manager register --activationkey="$RHSM_ACTIVATION_KEY" --org="$RHSM_ORG" || true; \
      # enable RHEL 10 base and appstream repos for x86_64; adjust names if building different arch
      subscription-manager repos --enable=rhel-10-for-x86_64-baseos-rpms --enable=rhel-10-for-x86_64-appstream-rpms || true; \
    else \
      echo "RHSM_ACTIVATION_KEY or RHSM_ORG not provided - continuing but dnf may fail"; \
    fi; \
    dnf -y install \
      httpd \
      firewalld \
      jq \
      curl \
      vim-enhanced \
      bash-completion \
    && dnf clean all; \
    # Unregister & remove entitlement files so credentials are not present in final image
    if subscription-manager identity >/dev/null 2>&1; then \
      subscription-manager unregister || true; \
      subscription-manager clean || true; \
      rm -rf /etc/pki/entitlement /etc/pki/consumer || true; \
    fi

COPY app/index.html /var/www/html/index.html
COPY files/motd /etc/motd
COPY scripts/vm-status.sh /usr/local/bin/vm-status
COPY scripts/vm-upgrade.sh /usr/local/bin/vm-upgrade
RUN chmod +x /usr/local/bin/vm-status /usr/local/bin/vm-upgrade

RUN systemctl enable httpd
RUN bootc container lint
