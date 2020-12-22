FROM ubuntu:20.04

ENV LANG C.UTF-8

RUN apt-get update                                && \
    apt-get --no-install-recommends --yes install    \
      # Build tools:
      ca-certificates=*                              \
      curl=7.68.*                                    \
      git=1:2.25.*                                   \
      gpg=2.2.*                                      \
      gpg-agent=2.2.*                                \
      groff=1.22.*                                   \
      jq=1.6-*                                       \
      unzip=6.0-*                                    \
      # Python build dependencies:
      build-essential=12.8ubuntu1*                   \
      libbz2-dev=1.0.*                               \
      libdb5.3-dev=5.3.*                             \
      libexpat1-dev=2.2.*                            \
      libffi-dev=3.3-*                               \
      libgdbm-dev=1.18.*                             \
      liblzma-dev=5.2.*                              \
      libncurses5-dev=6.2-*                          \
      libncursesw5-dev=6.2-*                         \
      libreadline-dev=8.0-*                          \
      libssl-dev=1.1.*                               \
      libsqlite3-dev=3.31.*                          \
      uuid-dev=2.34-*                                \
      zlib1g-dev=1:1.2.*                          && \
    rm -rf /var/lib/apt/lists/*                   && \
    git config --system advice.detachedHead false

# pyenv:
ENV PYENV_ROOT /root/.pyenv
ENV PATH       ${PATH}:${PYENV_ROOT}/bin:${PYENV_ROOT}/shims
RUN git clone https://github.com/pyenv/pyenv.git \
      --branch v1.2.21                           \
      --depth  1                                 \
      ${PYENV_ROOT}

# Python 3.9:
ENV PYENV_VERSION 3.9.0
RUN pyenv install "${PYENV_VERSION}" && \
    rm -rf /tmp/*                    && \
    python --version

# pipenv:
ENV PIPENV_YES 1
RUN pip install --no-cache-dir --upgrade pip==20.2.4        && \
    pip install --no-cache-dir           pipenv==2020.11.15

# hadolint:
ADD https://github.com/hadolint/hadolint/releases/download/v1.19.0/hadolint-Linux-x86_64 /usr/local/bin/hadolint
RUN chmod 555 /usr/local/bin/hadolint && \
    hadolint --version

# shellcheck:
ADD https://github.com/koalaman/shellcheck/releases/download/v0.7.1/shellcheck-v0.7.1.linux.x86_64.tar.xz /tmp/shellcheck.tar.xz
RUN tar xf /tmp/shellcheck.tar.xz -C /tmp                && \
    mv /tmp/shellcheck-v0.7.1/shellcheck /usr/local/bin/ && \
    rm -rf /tmp/*                                        && \
    shellcheck --version

# Import AWS CLI Team key:
COPY keys/aws-cli.pub /tmp/aws-cli.pub
RUN gpg --import /tmp/aws-cli.pub && \
    rm -rf /tmp/*

# Install AWS CLI:
ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.1.13.zip     /tmp/aws.zip
ADD https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.1.13.zip.sig /tmp/aws.zip.sig
RUN gpg --verify /tmp/aws.zip.sig /tmp/aws.zip && \
    unzip /tmp/aws.zip -d /tmp                 && \
    /tmp/aws/install                           && \
    rm -rf /tmp/*                              && \
    aws --version
