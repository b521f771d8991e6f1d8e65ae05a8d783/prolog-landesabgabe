FROM fedora:40
# FROM nixos/nix

RUN dnf update -y
RUN dnf upgrade -y

RUN dnf install -y git
RUN dnf install -y gpg
RUN dnf install -y cmake
RUN dnf install -y ninja-build
RUN dnf install -y swiftlang
RUN dnf install -y musl-devel
RUN dnf install -y gcc 
RUN dnf install -y gcc-objc
RUN dnf install -y gcc-objc++
RUN dnf install -y gdb
RUN dnf install -y clang-tools-extra
RUN dnf install -y libasan
RUN dnf install -y perl
RUN dnf install -y zsh
RUN dnf install -y pl # SWI-Prolog

RUN git config --global --add safe.directory /workspace