FROM fedora:40
# alternative to the nix evironment

RUN dnf update -y
RUN dnf upgrade -y

RUN dnf install -y git
RUN dnf install -y gpg
RUN dnf install -y cmake
RUN dnf install -y ninja-build
RUN dnf install -y gdb
RUN dnf install -y clang-tools-extra
RUN dnf install -y libasan
RUN dnf install -y perl
RUN dnf install -y zsh
RUN dnf install -y pl # SWI-Prolog

# for gnu builds
RUN dnf install -y gcc
RUN dnf install -y gcc-objc
RUN dnf install -y g++
RUN dnf install -y gcc-objc++

#RUN dnf groupinstall "Development Tools" "Development Libraries"

# for fedora builds
RUN yum -y install \
    binutils \
    gcc \
    git \
    libcurl-devel \
    libedit-devel \
    libicu-devel \
    libuuid-devel \
    libxml2-devel \
    python3-devel \
    sqlite-devel \
    unzip

WORKDIR /tmp
RUN curl -O https://download.swift.org/swift-6.0-release/fedora39/swift-6.0-RELEASE/swift-6.0-RELEASE-fedora39.tar.gz
RUN tar xzf swift-6.0-RELEASE-fedora39.tar.gz
RUN mv swift-6.0-RELEASE-fedora39 swift
RUN mv swift /opt
ENV PATH=/opt/swift/usr/bin:"${PATH}"
RUN swift sdk install https://download.swift.org/swift-6.0-release/static-sdk/swift-6.0-RELEASE/swift-6.0-RELEASE_static-linux-0.0.1.artifactbundle.tar.gz --checksum 7984c2cf175bde52ba6ea1fcbe27fc4a148a6237c41c719209c9288ed3ceb652

WORKDIR /

RUN git config --global --add safe.directory /workspace

#RUN /workspace/Dependencies/vcpkg/bootstrap-vcpkg.sh -disableMetrics