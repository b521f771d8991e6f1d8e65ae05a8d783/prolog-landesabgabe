FROM swift:bookworm AS development

WORKDIR /tmp
COPY Makefile .
RUN apt update && apt upgrade -y && apt install -y make
RUN make install-debian-packages

ENV PATH="$PATH:/root/.nix-profile/bin:/root/.cargo/bin" \
    CC=gcc CXX=g++ OBJC=gcc OBJCXX=g++

RUN git config --global --add safe.directory /workspace

FROM development AS build
ARG BUILD_VARIANT=debug

WORKDIR /workspace
COPY . .
RUN TARGET=${BUILD_TARGET} make everything

FROM swift:bookworm AS production

WORKDIR /app
COPY --from=build /workspace/LX .

CMD ["/app/LX"]
EXPOSE 1337
HEALTHCHECK CMD curl --fail http://localhost:1337/api/status || exit 1
