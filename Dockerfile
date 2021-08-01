FROM ubuntu:21.04

RUN apt update -q -y && \
    apt install -q -y hugo

WORKDIR /usr/share/blog
ADD . /usr/share/blog

ENTRYPOINT ["hugo", "server", "--bind", "0.0.0.0", "--minify", "--disableLiveReload", "--baseURL", "mxs.sbrk.org"]
