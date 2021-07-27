---
categories:
- code
date: "2009-01-24T00:00:00Z"
title: install netsoul on ubuntu
---

There is a pidgin plugin for netsoul, its installation is made for
BSDs, and not well documented for Linux.  As we'll compile the plugin,
we need to get pidgin sources, available in the *pidgin-dev* package:

```bash
sudo apt-get install pidgin-dev
```

Get a copy of the [netsoul plugin](http://sourceforge.net/projects/gaim-netsoul),
then just compile it without forgetting to redefine the `--prefix` location:

```bash
tar -xf gaim-*.tar.gz
cd gaim-netsoul-xxx
./configure --prefix=/usr
make
sudo make install
```
