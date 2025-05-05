FROM swift:rhel-ubi9 AS runtime-environment

FROM runtime-environment AS development

RUN dnf module enable -y nodejs:20
RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN dnf install -y npm cmake git ninja-build gcc gcc-c++ gcc-objc gcc-objc++ gdb wget zsh zip gnustep-base-devel

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin:/root/.cargo/env"
ENV CC=gcc
ENV CXX=g++
ENV OBJC=gcc-objc
ENV OBJCXX=gcc-objc++

RUN cargo install wasm-pack

FROM development AS build
ARG BUILD_VARIANT=debug

WORKDIR /workspace
COPY . .
RUN VARIANT=${BUILD_VARIANT} make init
RUN VARIANT=${BUILD_VARIANT} make all

WORKDIR /artifacts
RUN cp /workspace/.build/${BUILD_VARIANT}/LX .

FROM runtime-environment AS run

WORKDIR /app
COPY --from=build /artifacts/* .
CMD ["/app/LX"]
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/api/status || exit 1