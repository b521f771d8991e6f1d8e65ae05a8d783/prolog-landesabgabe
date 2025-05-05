FROM swift:windowsservercore-ltsc2022 AS development

RUN rustup toolchain install stable-x86_64-pc-windows-gnu
RUN rustup default stable-x86_64-pc-windows-gnu

FROM development AS build

WORKDIR /workspace
COPY . .


FROM swift:windowsservercore-ltsc2022 AS run