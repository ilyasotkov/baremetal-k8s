FROM alpine:3.9

RUN apk --no-cache add \
        curl \
        python \
        py-pip \
        bash \
        git \
        openssl \
        tar \
        ca-certificates \
        tzdata \
        jq \
        gnupg

RUN echo "===> Installing sudo to emulate normal OS behavior..."  && \
    apk --update add sudo                                         && \
    \
    \
    echo "===> Adding Python runtime..."  && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi                            && \
    \
    \
    echo "===> Installing Ansible..."  && \
    pip install ansible==2.8.1           && \
    \
    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    pip install --upgrade pywinrm                  && \
    apk --update add sshpass openssh-client rsync  && \
    \
    \
    echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*               && \
    \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts

RUN apk add --no-cache \
        git \
        bash \
        apache2-utils \
        && \
        pip install \
        jmespath

ARG ANSIBLE_VAULT_PASSWORD

# COPY .vault_pass .
# COPY ansible.cfg .
# COPY ssh /root/.ssh
# RUN ansible-vault decrypt /root/.ssh/id_rsa && chmod 0600 /root/.ssh/id_rsa

ENV TERRAFORM_VERSION 0.12.0
RUN curl -o ./terraform.zip \
        https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip

COPY ./docker-entrypoint.sh /usr/bin/
COPY . .

# ENTRYPOINT [ "/bin/bash", "-c" ]
