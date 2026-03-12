# Build using Hugo image.
FROM hugomods/hugo:0.157.0 as build

COPY . /src
WORKDIR /src
RUN hugo

# Serve using Nginx.
FROM nginx:alpine
COPY --from=build /src/public /usr/share/nginx/html
WORKDIR /usr/share/nginx/html
