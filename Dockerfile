FROM alpine:3.9

RUN apk --no-cache add \
        curl \
        python \
        bash \
        git \
        openssl \
        tar \
        ca-certificates \
        tzdata \
        jq \
        gnupg

ENV TF_VERSION 0.12.0
RUN curl -o ./terraform.zip \
        https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip \
        && unzip terraform.zip \
        && mv terraform /usr/bin \
        && rm -rf terraform.zip
