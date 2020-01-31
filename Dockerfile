FROM node:13.6.0-alpine

ARG CLOUD_SDK_VERSION=276.0.0
ARG HELM_VERSION=3.0.3

ENV CLOUD_SDK_VERSION=$CLOUD_SDK_VERSION
ENV HELM_VERSION=$HELM_VERSION
ENV HELM_BASE_URL="https://get.helm.sh"
ENV HELM_TAR_FILE="helm-v${HELM_VERSION}-linux-amd64.tar.gz"

ENV PATH /google-cloud-sdk/bin:$PATH

# Install gcloud
RUN apk --no-cache add \
        curl \
        python \
        py-crcmod \
        bash \
        libc6-compat \
        openssh-client \
        git \
        gnupg \
    && curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud --version

# Install Helm
RUN apk add --update --no-cache curl ca-certificates && \
    curl -L ${HELM_BASE_URL}/${HELM_TAR_FILE} |tar xvz && \
    mv linux-amd64/helm /usr/bin/helm && \
    chmod +x /usr/bin/helm && \
    rm -rf linux-amd64

# Cleanup
RUN apk del curl git && \
    rm -f /var/cache/apk/*

VOLUME ["/root/.config"]
