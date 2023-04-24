# Build using Ubuntu.
FROM ubuntu:jammy as build

RUN apt update -q -y && \
    apt install -q -y hugo

COPY . /www
WORKDIR /www
RUN hugo

# Serve using Nginx.
FROM nginx:alpine
COPY --from=build /www/public /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
