---
categories:
- aero_en
- music
date: "2016-01-24T00:00:00Z"
icon: music
title: something that rings a bell
disable_listing: true
---

*This article is part of the <a href="/music/2016-01-21-aerodynamic-en.html">Aerodynamic</a> guide.*

We are now going to focus on the first part of the track: `bell`, that
is, the 4 strokes of the bell at the beginning of the track ; here is
what it looks like once imported in *Sonic Visualizer*:

<img data-action="zoom" src="/img/aerodynamic/cloche-sonic-visualizer-1.jpg" />

This is a spectrogram, in abscissa we have time and in ordinate we
have audio frequencies. We can see 4 distinct areas, one for each
stroke. We also see horizontal stripes at different pitches: it
corresponds to the audio frequencies of the bell sound, the more they
tend to be red, the more intense the frequencies are. A musical
instrument generally plays a note which is represented by the most
intense frequency stripe, the other stripes are the *timbre* of an
instrument: each instrument has its own signature which can be more or
less elaborated (for instance, the timbre of a flute is much simpler
than a violin's one). Here, the most intense stripe is at 220 Hz (at
the bottom of the image), that is, the note `:A3`.

A simple version of these 4 bell strokes can be expressed this way in
*Sonic Pi*:

```ruby
use_bpm 123
use_synth :pretty_bell

4.times do
    play :A3
    sleep 8
end
```

Which means:

* use a BPM of 123
* use the instrument `pretty_bell` (one of the bells available in *Sonic Pi*)
* do 4 times what is between `do` and `end` (a block)
* in the block, play the note `A3`, then wait 8 beats

When we execute this code (the `Run` button), we hear a bell stroke
every 8 beats, 4 times.

First problem, the duration of the bell sound isn't the one we are
looking for (it is much shorter than in *Aerodynamic*). The
instruments of *Sonic Pi* can be tweaked with parameters, some of them
manipulate the duration of notes.

If we give another look at the previous spectrogram, we see that the
intensity of each frequency decreases with time: the active
frequencies are at first red (high intensity), then they progressively
become green (low intensity). Moreover, after 8 beats, they are still
slightly active, as if they were actually on 9 beats. These two
charactetistics of the note can be obtained with the `release`
parameter, which increases the duration of a note, and progressively
decreases its intensity :

```ruby
use_synth :pretty_bell
use_synth_defaults release: 9

4.times do
    play :A3
    sleep 8
end
```

We are now closer to Aerodynamic! But that's still not very convincing
because the timbre of the bell from *Sonic Pi* isn't the same as the
one we are looking for. In other terms, the horizontal stripes
produced by *Sonic Pi*'s bell, despite being based on the note `A3`,
are different. Here's what it looks like in *Sonic Visualizer*:

<img src="/img/aerodynamic/cloche-sonic-visualizer-2.jpg" data-action="zoom" />

At the top, we have the bell from *Aerodynamic* ; at the bottom our
version: indeed, we are quite far from it, we are missing a lot of
timbre! We can try to fix this by playing several bells at the same
time, with reduced amplitude on octaves around `A3`, so as to cover a
larger part of the spectrum:

```ruby
use_bpm 123

use_synth :pretty_bell
use_synth_defaults release: 9

4.times do
    play :A1, amp: 0.125
    play :A2, amp: 0.25
    play :A3, amp: 0.75
    play :A4, amp: 0.40
    play :A5, amp: 0.25
    sleep 8
end
```

When we call several times `play` in a row, it plays everything in
parallel, this is the call to `sleep` which introduces the pause,
therefore we have here 4 iterations on:

* a stroke of a bell `:A1` with an amplitude of 12.5%
* a stroke of a bell `:A2` with an amplitude of 25%
* a stroke of a bell `:A3` with an amplitude of 75%
* a stroke of a bell `:A4` with an amplitude of 40%
* a stroke of a bell `:A5` with an amplitude of 25%

This fills some gaps in the spectrogram, it is still far from the
original bell but it is satisfactory.

Finally, we can add some depth and distance with the help of the
`gverb` effect, which we apply around the `play` instructions:

```ruby
use_bpm 123

use_synth :pretty_bell
use_synth_defaults release: 9

4.times do
    with_fx :gverb, room: 20 do
        play :A1, amp: 0.25
    	play :A2, amp: 0.5
        play :A3, amp: 1.5
        play :A4, amp: 0.75
        play :A5, amp: 0.5
 	sleep 8
    end
end
```

The `gverb` effect applies to the block it wraps, we use it here with
the `room` parameter set to 20 (its default value is 10), to increase
the distance effect.

*Sonic Pi* has a collection of audio effects (whose number increases
with each new release), it is possible to browse this collection via
the help at the bottom of *Sonic Pi*, inside the `Fx` pane ; each
effect has its own documentation, with the different possible
parameters:

<img src="/img/aerodynamic/help-fx.png" data-action="zoom" />

<a href="/music/2016-01-25-aerodynamic-makeup-en.html">Next...</a>

<hr />

*This article is part of the <a href="/music/2016-01-21-aerodynamic-en.html">Aerodynamic</a> guide.*
