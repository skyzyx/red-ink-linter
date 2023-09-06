FROM tenable/terrascan:1.18.3 as terrascan
FROM alpine/terragrunt:1.5.5 as terragrunt
FROM ghcr.io/assignuser/chktex-alpine:v0.2.0 as chktex
FROM dotenvlinter/dotenv-linter:3.3.0 as dotenv-linter
FROM ghcr.io/awkbar-devops/clang-format:v1.0.2 as clang-format
FROM ghcr.io/terraform-linters/tflint-bundle:v0.47.0.0 as tflint
FROM ghcr.io/yannh/kubeconform:v0.6.3 as kubeconfrm
FROM golangci/golangci-lint:v1.54.2 as golangci-lint
FROM hadolint/hadolint:latest-alpine as dockerfile-lint
FROM hashicorp/terraform:1.5.5 as terraform
FROM koalaman/shellcheck:v0.9.0 as shellcheck
FROM mstruebing/editorconfig-checker:2.7.1 as editorconfig-checker
FROM mvdan/shfmt:v3.7.0 as shfmt
FROM rhysd/actionlint:1.6.25 as actionlint
FROM scalameta/scalafmt:v3.7.3 as scalafmt
FROM zricethezav/gitleaks:v8.17.0 as gitleaks
FROM yoheimuta/protolint:0.46.0 as protolint

FROM python:3.11.4-alpine3.17 as base_image

## install alpine-pkg-glibc (glibc compatibility layer package for Alpine Linux)
ARG GLIBC_VERSION='2.34-r0'

# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETARCH

# Base packages
RUN apk add --no-cache \
    bash \
    ca-certificates \
    coreutils \
    curl \
    git \
    git-lfs \
    go \
    jq \
    nodejs-current \
    npm \
    python3-dev \
    zlib \
    ;

# cargo \
# cmake \
# file \
# g++ \
# gcc \
# gnupg \
# icu-libs \
# jpeg-dev \
# krb5-libs \
# libc-dev \
# libcurl \
# libffi-dev \
# libgcc \
# libintl \
# libssl1.1 \
# libstdc++ \
# libxml2-dev \
# libxml2-utils \
# linux-headers \
# lttng-ust-dev \
# make \
# musl-dev \
# net-snmp-dev \
# openjdk11-jre \
# openssh-client \
# openssl-dev \
# py3-pyflakes \
# py3-setuptools \
# readline-dev \
# zlib-dev \

# Copy dependencies files to container
COPY dependencies/* /

# The chown fixes broken uid/gid in ast-types-flow dependency
# (see https://github.com/super-linter/super-linter/issues/3901)
RUN npm install && chown -R "$(id -u)":"$(id -g)" node_modules && bundle install

# Install shellcheck
COPY --from=shellcheck /bin/shellcheck /usr/bin/

# Install Go Linter
COPY --from=golangci-lint /usr/bin/golangci-lint /usr/bin/

# Install Terraform

# Install TFLint
COPY --from=tflint /usr/local/bin/tflint /usr/bin/
COPY --from=tflint /root/.tflint.d /root/.tflint.d

# Install Terrascan
COPY --from=terrascan /go/bin/terrascan /usr/bin/

# Install Terragrunt
COPY --from=terragrunt /usr/local/bin/terragrunt /usr/bin/

# Install editorconfig-checker
COPY --from=editorconfig-checker /usr/bin/ec /usr/bin/editorconfig-checker

# Install hadolint
COPY --from=dockerfile-lint /bin/hadolint /usr/bin/hadolint

# Install shfmt
COPY --from=shfmt /bin/shfmt /usr/bin/

# Install GitLeaks
COPY --from=gitleaks /usr/bin/gitleaks /usr/bin/

# Install actionlint
COPY --from=actionlint /usr/local/bin/actionlint /usr/bin/

# Install Bash-Exec
COPY --chmod=555 scripts/bash-exec.sh /usr/bin/bash-exec

#-------------------------------------------------------------------------------

# Clean to shrink image
RUN find /usr/ -type f -name '*.md' -exec rm {} +

#-------------------------------------------------------------------------------

# Grab small clean image to build python packages
FROM python:3.11.4-alpine3.17 as python_builder
RUN apk add --no-cache bash g++ git libffi-dev
COPY dependencies/python/ /stage
WORKDIR /stage
RUN ./build-venvs.sh

#-------------------------------------------------------------------------------

FROM alpine:3.18.3 as slim

# Label the instance and set maintainer
LABEL com.github.actions.name="GitHub Super-Linter" \
    com.github.actions.description="Lint your code base with GitHub Actions" \
    com.github.actions.icon="code" \
    com.github.actions.color="red" \
    maintainer="GitHub DevOps <github_devops@github.com>" \
    org.opencontainers.image.created=$BUILD_DATE \
    org.opencontainers.image.revision=$BUILD_REVISION \
    org.opencontainers.image.version=$BUILD_VERSION \
    org.opencontainers.image.authors="GitHub DevOps <github_devops@github.com>" \
    org.opencontainers.image.url="https://github.com/super-linter/super-linter" \
    org.opencontainers.image.source="https://github.com/super-linter/super-linter" \
    org.opencontainers.image.documentation="https://github.com/super-linter/super-linter" \
    org.opencontainers.image.vendor="GitHub" \
    org.opencontainers.image.description="Lint your code base with GitHub Actions"

COPY --from=base_image /usr/bin/ /usr/bin/
COPY --from=base_image /usr/local/bin/ /usr/local/bin/
COPY --from=base_image /usr/local/lib/ /usr/local/lib/
COPY --from=base_image /usr/local/share/ /usr/local/share/
COPY --from=base_image /usr/local/include/ /usr/local/include/
COPY --from=base_image /usr/lib/ /usr/lib/
COPY --from=base_image /usr/share/ /usr/share/
COPY --from=base_image /usr/include/ /usr/include/
COPY --from=base_image /lib/ /lib/
COPY --from=base_image /bin/ /bin/
COPY --from=base_image /node_modules/ /node_modules/
COPY --from=base_image /home/r-library /home/r-library
COPY --from=base_image /root/.tflint.d/ /root/.tflint.d/
COPY --from=python_builder /venvs/ /venvs/

ENV TFLINT_PLUGIN_DIR="/root/.tflint.d/plugins"
ENV PATH="${PATH}:/node_modules/.bin"
ENV PATH="${PATH}:/venvs/cfn-lint/bin"
ENV PATH="${PATH}:/venvs/flake8/bin"
ENV PATH="${PATH}:/venvs/isort/bin"
ENV PATH="${PATH}:/venvs/mypy/bin"
ENV PATH="${PATH}:/venvs/pylint/bin"
ENV PATH="${PATH}:/venvs/yamllint/bin"
ENV PATH="${PATH}:/venvs/yq/bin"

# Copy scripts to container
COPY lib /action/lib

# Copy linter rules to container
COPY TEMPLATES /action/lib/.automation

# Pull in libs
COPY --from=base_image /usr/libexec/ /usr/libexec/

# Run to build version file and validate image
RUN ACTIONS_RUNNER_DEBUG=true WRITE_LINTER_VERSIONS_FILE=true IMAGE="${IMAGE}" /action/lib/linter.sh

# Set the entrypoint
ENTRYPOINT ["/action/lib/linter.sh"]

################################################################################
# Grab small clean image to build standard ###############################
################################################################################
FROM slim as standard

# Set up args
ARG GITHUB_TOKEN
# https://docs.docker.com/engine/reference/builder/#automatic-platform-args-in-the-global-scope
ARG TARGETARCH

# Install dotenv-linter
COPY --from=dotenv-linter /dotenv-linter /usr/bin/

# Run to build version file and validate image again because we installed more linters
RUN ACTIONS_RUNNER_DEBUG=true WRITE_LINTER_VERSIONS_FILE=true IMAGE="${IMAGE}" /action/lib/linter.sh
