FROM node:lts-alpine AS development
ARG BUILD_MODE=debug-local

RUN apk update
RUN apk upgrade

RUN apk add git
RUN apk add curl

FROM development AS build
ARG BUILD_MODE

RUN mkdir /build
RUN mkdir /workspace

COPY . /workspace

WORKDIR /workspace/Sources/lxui
RUN npm install
RUN npm run build -- --mode $BUILD_MODE

FROM nginx:stable-alpine AS production
ARG BUILD_MODE

COPY Sources/lxui/nginx/lxui.conf /etc/nginx/conf.d/
RUN rm /etc/nginx/nginx.conf
COPY Sources/lxui/nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir /usr/share/nginx/html/lxui
COPY --from=build /build /usr/share/nginx/html/lxui