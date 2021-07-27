---
categories:
- music
- volca
date: "2017-12-04T00:00:00Z"
icon: music
title: Start multiple Volcas in sync
---

Chaining Volcas together using the sync in/sync out connectors
synchronizes the tempo (i.e: changing the tempo on one Volca will
change the tempo of all Volcas), however this doesn't synchronises the
beat (one Volca can be at 0.42 of a bar of another one).

There is a little hack to get everything in sync, using an extra
mini-jack cable:

1. Chain Volcas together as you would normally do,
2. On the master Volca, plug the extra mini-jack cable to sync-in,
3. Start all Volcas, press play everywhere.

At this point, the master Volca is waiting for something to come in
from the sync-in cable, all other Volcas are waiting for the master
Volca to send a signal, so everything is stuck waiting for something
magical to happen with the sync-in cable.

4. Un-plug the sync-in cable.

The master Volca doesn't wait anymore on this socket, starts playing
and sending signals to other Volcas.
