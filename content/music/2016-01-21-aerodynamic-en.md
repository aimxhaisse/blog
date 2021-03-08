---
categories:
- music
date: "2016-01-21T00:00:00Z"
icon: music
title: aerodynamic
---

*Also available in [french]({% post_url music/2016-01-21-aerodynamic %}) / également disponible en [français]({% post_url music/2016-01-21-aerodynamic %}).*

The goal of these articles is to explore the relationships between
music and code, by analyzing and recreating the track
[Aerodynamic](https://www.youtube.com/watch?v=L93-7vRfxNs) from *Daft
Punk*.

Unlike classical approaches to generate sound on a computer, we are
going to generate sound by writing text: instead of adding tracks,
instruments, samples… on a timeline, we will see how to express those
in code and how to play music.

At the end of these pages, you should be able to do something like
this:

<iframe id="ytplayer" type="text/html" width="640" height="390" src="https://www.youtube.com/embed/cydH_JAgSfg?autoplay=0&origin=http://mxs.sbrk.org" frameborder="0"></iframe>

I hope it motivates you to join the adventure, as the departure is in
a few minutes! Grab your headphones, get some coffee, and make yourself
comfortable.

Ready? Let's go!

{% assign items = site.categories.aero_en %}
{% include page-reversed-items.html %}
