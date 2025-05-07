FROM swift:rhel-ubi9 AS development

WORKDIR /tmp
COPY Makefile .
RUN dnf update -y && dnf install -y make
RUN make install-rhel-packages

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin:/root/.cargo/env"\
    CC=gcc CXX=g++ OBJC=gcc-objc OBJCXX=gcc-objc++

RUN git config --global --add safe.directory /workspace

FROM development AS build
ARG BUILD_VARIANT=debug

WORKDIR /workspace
COPY . .
RUN VARIANT=${BUILD_VARIANT} make everything

FROM swift:rhel-ubi9 AS run

WORKDIR /app
COPY --from=build /workspace/LX .

CMD ["/app/LX"]
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/api/status || exit 1
