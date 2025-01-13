FROM node:lts-alpine AS dev

RUN apk update
RUN apk upgrade

RUN apk add git

FROM dev AS build

RUN mkdir /build
RUN mkdir /source

COPY Sources/lxui /source

WORKDIR /source
RUN npm install
RUN npm run build

FROM httpd:alpine AS run
# TODO