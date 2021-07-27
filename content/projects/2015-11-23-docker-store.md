---
categories:
- projects
date: "2015-11-23T00:00:00Z"
icon: projects
link: https://github.com/aimxhaisse/docker-store
title: docker store
---

`Docker store` provides facilities to quickly setup a data store. It allows to:

- push files via FTP/SFTP
- serve them via HTTP

## Installation

    docker-compose build
    docker-compose up -d

## Adding FTP users

    docker-compose run ftp new-ftp-user <username>
    <enter password twice>	

More on [github](https://github.com/aimxhaisse/docker-store).
