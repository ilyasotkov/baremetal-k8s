FROM ubuntu:18.04

WORKDIR /baremaetal-k8s

RUN apt update -y \
        && apt install -y \
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
                unzip

COPY ./requirements.txt .
RUN /usr/bin/python -m pip install pip -U \
        && python -m pip install -r requirements.txt

ENV TERRAFORM_VERSION 0.12.0
RUN curl -o ./terraform.zip \
        https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.14.3/bin/linux/amd64/kubectl \
    && chmod a+x kubectl && cp kubectl /usr/local/bin/kubectl

COPY ./docker-entrypoint.sh /usr/bin/
COPY . .
