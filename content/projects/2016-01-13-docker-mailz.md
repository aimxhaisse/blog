---
categories:
- projects
date: "2016-01-13T00:00:00Z"
icon: projects
link: https://github.com/aimxhaisse/docker-mailz
title: docker mailz
---

[Docker Mailz](https://github.com/aimxhaisse/docker-mailz) is an
all-in-one solution to manage mails on a Linux box with a single,
simple, human-readable configuration file.

## Components

* [OpenSMTPD](https://www.opensmtpd.org/)
* [SpamPD](http://spamassassin.apache.org/) (SpamAssassin)
* [Dovecot](http://www.dovecot.org/)
* [Sieve](http://sieve.info/)
* [RoundCube](https://roundcube.net/)

## Setup

    $ cp config.ini.example config.ini
    $ $EDITOR config.ini

## Usage

```
$ make
Mailz, lots of mailz.

All configuration is done via config.ini, enjoy.

spawn            sync configuration and respawn all containers
logs             print containers logs
backup           backup mail data
stop             stop all containers
encrypt          encrypt a password
status           show status of containers
help             print this help
```

## Features

* Multiple users
* SSL
* Webmail
* Antispam
* Backups

## How To

Everything is managed by `config.ini`, if you need:

* to change certificates
* add a user
* update a password
* remove a user
* change your hostname
* …

Edit `config.ini` and `make spawn`.

More on [github](https://github.com/aimxhaisse/docker-mailz).
