FROM ubuntu:18.04

WORKDIR /baremetal-k8s

RUN apt update -yq \
        && apt install -yq \
                libssl-dev \
                python-dev \
                sshpass \
                apt-transport-https \
                jq \
                ca-certificates \
                curl \
                gnupg2 \
                software-properties-common \
                python-pip \
                rsync \
                unzip \
                git

COPY ansible/ ansible/

ARG KUBESPRAY_VERSION=2.10.4
RUN curl -L -o kubespray.tar.gz \
        https://github.com/kubernetes-sigs/kubespray/archive/v${KUBESPRAY_VERSION}.tar.gz \
        && tar -xvzf kubespray.tar.gz \
        && mv kubespray-${KUBESPRAY_VERSION} /kubespray \
        && rm -f kubespray.tar.gz \
        && rm -f /kubespray/ansible.cfg \
        && cp -r ansible/* /kubespray

RUN /usr/bin/python -m pip install pip -U \
        && python -m pip install -r /kubespray/requirements.txt

ARG TERRAFORM_VERSION=0.12.0
RUN curl -o ./terraform.zip \
        https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip

ARG KUBECTL_VERSION=1.14.3
RUN curl -LO \
        https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && chmod a+x kubectl && cp kubectl /usr/local/bin/kubectl

ARG HELM_VERSION=2.14.1
RUN curl -L -o helm.tar.gz \
        https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
        && tar -xvzf helm.tar.gz \
        && rm -rf helm.tar.gz \
        && chmod 0700 linux-amd64/helm \
        && mv linux-amd64/helm /usr/bin

ARG HELMFILE_VERSION=0.79.0
RUN curl -L -o helmfile \
        https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 \
        && chmod 0700 helmfile \
        && mv helmfile /usr/bin

COPY ./docker-entrypoint.sh /usr/bin/
COPY . .
