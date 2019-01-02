FROM alpine:latest

RUN deluser guest ; delgroup users
RUN addgroup -g 985 -S users
RUN adduser -S -G users -u 1000 -s /bin/sh -h /home/mudrii mudrii

#https://github.com/google-cloud-sdk/google-cloud-sdk/releases
#https://github.com/kubernetes/kubernetes/releases
ENV CLOUD_SDK_VERSION 228.0.0
ENV KUBE_VERSION v1.13.1
ENV PATH /google-cloud-sdk/bin:$PATH

RUN apk --no-cache update && \
    apk --no-cache add \
    curl \
    ca-certificates \
    python \
    py-crcmod \
    libc6-compat \
    openssh-client \
    jq && \
    curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    tar xzf google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    rm google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz && \
    ln -s /lib /lib64 && \
    gcloud config set core/disable_usage_reporting true && \
    gcloud config set component_manager/disable_update_check true && \
    gcloud config set metrics/environment github_docker_image && \
    gcloud components install beta  --quiet && \
    rm -rf /google-cloud-sdk/.install/.backup && \
    curl https://storage.googleapis.com/kubernetes-release/release/${KUBE_VERSION}/bin/linux/amd64/kubectl --output /google-cloud-sdk/bin/kubectl && \
    chmod +x /google-cloud-sdk/bin/kubectl && \
    apk --purge del curl

USER mudrii
