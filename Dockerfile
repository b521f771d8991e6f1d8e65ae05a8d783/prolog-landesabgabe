FROM ghcr.io/b521f771d8991e6f1d8e65ae05a8d783/base-tools/trixie-tools:main AS development

FROM development AS build
ARG BUILD_VARIANT=debug

WORKDIR /workspace
COPY . .
RUN VARIANT=${BUILD_VARIANT} make init
RUN VARIANT=${BUILD_VARIANT} npx dotenvx run -- make linux-packages

FROM ghcr.io/b521f771d8991e6f1d8e65ae05a8d783/base-tools/trixie-tools-runtime:main AS run

WORKDIR /tmp
COPY --from=build /workspace/out .
RUN dpkg -i *.deb
RUN apt update && apt upgrade -y && apt install -y curl

WORKDIR /
# TODO remove this
RUN chmod +x /usr/bin/backend

CMD ["/usr/bin/backend"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s  CMD curl --fail http://localhost:1337/api/status | grep -q 👌 || exit 1

