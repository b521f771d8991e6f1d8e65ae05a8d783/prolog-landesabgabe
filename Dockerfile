FROM ghcr.io/b521f771d8991e6f1d8e65ae05a8d783/base-tools/debian-tools:main AS development
RUN apt update && apt upgrade -y && apt install -y swi-prolog

FROM development AS build
ARG BUILD_VARIANT=debug

WORKDIR /workspace
COPY . .
RUN VARIANT=${BUILD_VARIANT} make init linux-packages

FROM ghcr.io/b521f771d8991e6f1d8e65ae05a8d783/base-tools/debian-tools-runtime:main AS run

WORKDIR /tmp
COPY --from=build /workspace/output .
RUN dpkg -i *.deb

WORKDIR /

RUN chmod +x /usr/bin/backend
CMD ["/usr/bin/backend"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s  CMD ["/usr/bin/backend", "check"]
