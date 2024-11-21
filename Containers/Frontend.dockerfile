FROM node:23-alpine AS dev

EXPOSE 3000

FROM dev as build