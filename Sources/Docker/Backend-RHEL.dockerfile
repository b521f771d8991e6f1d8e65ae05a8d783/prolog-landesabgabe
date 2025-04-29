FROM swift:rhel-ubi9-slim AS runtime-environment
#RUN sudo dnf update -y && dnf upgrade -y && dnf install -y swiftlang zlib-devel

FROM runtime-environment AS development

RUN dnf install -y npm rust cargo cmake git ninja-build gcc gcc-c++ gdb wget zsh zip
# gcc-c++ gcc-objc gcc-objc++ gnustep-base-devel 
# somehow needed for vscode
#RUN dnf install -y awk

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