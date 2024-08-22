# TODO install the swift with static support: https://www.swift.org/documentation/articles/static-linux-getting-started.html

FROM fedora:40

RUN dnf update -y
RUN dnf upgrade -y

RUN dnf install -y git
RUN dnf install -y cmake
RUN dnf install -y ninja-build
RUN dnf install -y gcc
RUN dnf install -y gcc-objc
RUN dnf install -y gcc-g++
RUN dnf install -y gcc-objc++
RUN dnf install -y swiftlang
RUN dnf install -y clang-tools-extra
RUN dnf install -y libasan
RUN dnf install -y perl
RUN dnf install -y zsh

RUN git config --global --add safe.directory /workspace