FROM ubuntu:22.04
# TODO: replace this with a stable version using nixos/nix

RUN apt update -y
RUN apt upgrade -y

WORKDIR /root
RUN apt install -y ca-certificates wget
RUN wget https://apt.kitware.com/kitware-archive.sh
RUN chmod +x kitware-archive.sh
RUN ./kitware-archive.sh

RUN apt update -y
RUN apt upgrade -y

RUN apt install -y git
RUN apt install -y lsb-release wget software-properties-common gnupg
RUN bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"
RUN apt install -y gpg
RUN apt install -y cmake
RUN apt install -y ninja-build
RUN apt install -y gdb
RUN apt install -y perl
RUN apt install -y zsh
#RUN apt install -y pl # SWI-Prolog

# swift dependencies: https://www.swift.org/install/linux/tarball/
RUN  apt install -y
RUN apt install -y binutils
RUN apt install -y git
RUN apt install -y gnupg2
RUN apt install -y libc6-dev
RUN apt install -y libcurl4-openssl-dev
RUN apt install -y libedit2
RUN apt install -y libgcc-11-dev
RUN apt install -y libpython3-dev
RUN apt install -y libsqlite3-0
RUN apt install -y libstdc++-11-dev
RUN apt install -y libxml2-dev
RUN apt install -y libz3-dev
RUN apt install -y pkg-config
RUN apt install -y python3-lldb-13
RUN DEBIAN_FRONTEND=noninteractive apt install -y tzdata
RUN apt install -y unzip
RUN apt install -y zlib1g-dev

RUN wget https://download.swift.org/swift-6.0-branch/ubuntu2204/swift-6.0-DEVELOPMENT-SNAPSHOT-2024-08-22-a/swift-6.0-DEVELOPMENT-SNAPSHOT-2024-08-22-a-ubuntu22.04.tar.gz
RUN tar xzfv swift-6.0-DEVELOPMENT-SNAPSHOT-2024-08-22-a-ubuntu22.04.tar.gz
RUN mv swift-6.0-DEVELOPMENT-SNAPSHOT-2024-08-22-a-ubuntu22.04 /opt/swift
ENV PATH="$PATH:/opt/swift/usr/bin"
RUN swift sdk install https://download.swift.org/swift-6.0-branch/static-sdk/swift-6.0-DEVELOPMENT-SNAPSHOT-2024-07-02-a/swift-6.0-DEVELOPMENT-SNAPSHOT-2024-07-02-a_static-linux-0.0.1.artifactbundle.tar.gz --checksum 42a361e1a240e97e4bb3a388f2f947409011dcd3d3f20b396c28999e9736df36

WORKDIR /

RUN apt remove -y libncurses-dev
RUN apt remove -y ncurses-dev
RUN apt autoremove -y

RUN git config --global --add safe.directory /workspace