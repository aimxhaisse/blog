---
categories:
- code
date: "2014-05-17T00:00:00Z"
plugin: lightense
title: streaming extempore
---

Lately I've been playing with
[Extempore](http://extempore.moso.com.au/), an environment to play
live music using Scheme and a DSL (xtlang) ; there are
[some](https://www.youtube.com/watch?v=GSGKEy8vHqg)
[cool](http://benswift.me/2013/12/16/new-screencast-asmodeus-redux/)
[screencasts](http://benswift.me/2014/02/17/new-screencast-another-late-christmas/)
on the web that convinced me it was what I wanted to try
next. Unfortunately my laptop is too slow for this, so I wanted to use
my server instead, which has a better CPU (audio processing is CPU
bound).

The idea is to run Extempore inside a
[Docker](https://www.docker.com/) container, connect the Extempore
process to a Jack server with a dummy driver (as there's no easy way
to access the audio card from the container), and then, use VLC and
its plugin for Jack to export the audio stream as HTTP.

The cool thing is that it becomes very easy to share what you are
doing with friends: just open the HTTP link with a decent audio player
(though in my case, it does not worth it). Also, you can easily having
several performers from different places in the world hacking the
current session at the same time.

I've dockerized everything so I can reuse this setup without trouble
on other computers, also, if someone is interested in this approach,
she/he can reuse without it burning too much time.

The workflow becomes:

* start the Docker container,
* start an audio player and connect to the live HTTP stream,
* fire-up Emacs and connect to extempore,
* have fun!

Here's a quick guide to get your hands dirty, assuming you have a
Linux with Docker installed:

## Pull the Container

```bash
docker pull aimxhaisse/docker-extempore
```

## Start the Docker Container

```bash
docker run -p 8080:8080 -p 7099:7099 aimxhaisse/docker-extempore
```

The Docker container has a virtual IP address which is accessible from
the host, as I want to access the port 8080 (to listen) and the port
7099 (to connect my local emacs to extempore) from the outside, I
publish these ports on the host interface.

## Start an Audio Player

Quite straightforward:

```bash
cvlc http://mxs.sbrk.org:8080/
```

### Connect to the Server

Nothing new here: `ctrl+j` to connect, specify the expected host, and
that's it.

## Extra Notes

I plan to keep this Docker image up-to-date with the latest changes
available on Extempore, if it appears to be a lie when you read this
line, do not hesitate to drop me an e-mail.

Among the future changes that I might add:

* Preloading of instruments.xtm to avoid waiting a few minutes before having funm
* A tiny HTTP interface so it can be streamed using a recent web browser,
* Probably some tuning on the outputed stream,
* Some helpers to load samples (by sharing a directory with the container).

## Additional Links

* [docker-extempore](https://index.docker.io/u/aimxhaisse/docker-extempore/)
