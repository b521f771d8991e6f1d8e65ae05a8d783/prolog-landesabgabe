FROM fedora:latest AS development

RUN sudo dnf update && dnf upgrade -y && dnf install swiftlang cmake wget zsh zip gdb git ninja 