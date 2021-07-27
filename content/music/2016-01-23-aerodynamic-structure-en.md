---
categories:
- aero_en
- music
date: "2016-01-23T00:00:00Z"
icon: music
title: structure
---

*This article is part of the [Aerodynamic]({% post_url music/2016-01-21-aerodynamic-en %})* guide.

Before digging into the track,
[listen to it](https://www.youtube.com/watch?v=L93-7vRfxNs) 3/4 times,
and try to deduct the different parts and imagine how they are
built.

Ready? Let's continue!

Here's what the track looks like once imported in *Sonic Visualizer*:

<img src="/public/img/aerodynamic/structure.png" data-action="zoom" />

It is a common way to visualize a sound, in abscissa we have the time and in
ordinate the volume. We see that the track's length is about 3 minutes and
27 seconds, and that it is composed of the following parts:

1. `bells`
2. `funk`
3. `solo`
4. `funk/solo`
5. `outro`

This cut is somehow arbitrary and could be finer (for instance, the
second part `funk` is actually made of two parts which we can also see
on the picture). We are going to focus on the first 4 parts and forget
about the last, but before starting, we need to get some extra
information about the track.

## The tempo

We need to know the tempo of the track, which we usually express in
terms of `BPM`, that is, the number of <b>B</b>eats <b>P</b>er
<b>M</b>inute. There are different ways to get this value, the
simplest one being to use a software which directly provides its
value, for instance, by importing the track in *Audacity* with the
*Tempo and Beat Tracker* plugin :

<img src="/public/img/aerodynamic/bpm.png" data-action="zoom" />

We can also compute it from the `bells` part of the track, which is
made of 4 strokes of a bell for a duration of **15''6**: if we decide
that each stroke corresponds to 8 beats, we can deduce the BPM in the
way:

- one stroke is **15.6 / 4 = 3.9'**,
- as one stroke is 8 beats, one beat is **3.9 / 8 = 0.4875''**,
- as a result, in *60''*, we have **60 / 0.4875 = 123**, so the BPM
  is 123.

To be sure of this value, we are going to play 4 notes every 8 beats in
*Sonic Pi* with a tempo of 123 BPM:

```ruby
use_bpm 123

4.times do
    play :C3
    sleep 8
end
```

This is rather expressive, and it can be read this way:

* use a `BPM` of 123
* do 4 times what is between `do` and `end` (we call this a block)
* inside the block, play the note `C3`, then wait 8 beats

This looks like the original track from a rhythmic point of view (but not
on the accoustic side since we arbitrarily picked `C3`), to be sure of
this, we can compare this version with the original one in *Audacity*:

<img src="/public/img/aerodynamic/bpm-match.png" data-action="zoom" />

On the upper side we have the original (since it's a stereo track,
there is one line for the left ear, one line for the right ear), on
the bottom side we have our version: it matches, we can continue!

[Next...]({% post_url music/2016-01-24-aerodynamic-something-that-rings-a-bell-en %})

<hr />

*This article is part of the [Aerodynamic]({% post_url music/2016-01-21-aerodynamic-en %})* guide.
