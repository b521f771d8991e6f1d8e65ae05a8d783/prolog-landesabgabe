FROM node:lts-alpine AS dev

RUN apk update
RUN apk upgrade

RUN apk add git
RUN apk add curl

FROM dev AS build

RUN mkdir /build
RUN mkdir /workspace

COPY . /workspace

WORKDIR /workspace/Sources/lxui
RUN npm install
RUN npm run build

FROM nginx:stable-alpine AS run

COPY Sources/lxui/nginx/lxui.conf /etc/nginx/conf.d/
RUN rm /etc/nginx/nginx.conf
COPY Sources/lxui/nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir /usr/share/nginx/html/lxui
COPY --from=build /build /usr/share/nginx/html/lxui