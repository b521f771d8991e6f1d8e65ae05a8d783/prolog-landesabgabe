FROM node:lts-alpine AS dev

RUN apk update
RUN apk upgrade

RUN apk add git

FROM dev AS build

RUN mkdir /build
RUN mkdir /source

COPY . /source

WORKDIR /source
RUN npm install
RUN npm run build

FROM nginx:stable-alpine AS run

COPY nginx/lxui.conf /etc/nginx/conf.d/
RUN rm /etc/nginx/nginx.conf
COPY nginx/nginx.conf /etc/nginx/nginx.conf

RUN mkdir /usr/share/nginx/html/lxui
COPY --from=build /build /usr/share/nginx/html/lxui

EXPOSE 8080