---
categories:
- aero_en
- music
date: "2016-01-25T00:00:00Z"
icon: music
title: a bit of makeup
disable_listing: true
---

*This article is part of the <a href="/music/2016-01-21-aerodynamic-en.html">Aerodynamic</a> guide.*

*Daft Punk* is known for its usage of samples: several tracks from the
Discovery album are built from samples of disco songs from the 80s.
*Aerodynamic* is not exempted from this rule as the `funk` part of the
track is built from another track from the band *Sister Sledge*,
[Il macquillage lady](https://www.youtube.com/watch?v=tJWPZuFsdrk),
more precisly from this chunk:

<center>
   <audio controls="controls">
      <source src="/misc/il-macquillage-lady.wav" type="audio/wav" />
   </audio>
</center>

The extract's duration is 7.78' and contains 16 beats, so it is at `60/ (7.780 * 16)`
BPM, that is 123.4 BPM, this is not far from the one of *Aerodynamic*
which is at 123 BPM. We will see how to go from this sample, to
something that looks like:

<center>
   <audio controls="controls">
       <source src="/misc/funk.wav" type="audio/wav" />
   </audio>
</center>

We can hear some similarities, but it is rather difficult to imagine
how everything is pieced together, even after several hearings.

## Preparation of the extract

We'll start by preparing and cutting *Sister Sledge*'s extract,
then by picking chunks (samples) we are interested in so as to
rebuild the funk from *Daft Punk*.

Once the [original extract](/misc/il-macquillage-lady.wav) and
[the one from the Daft Punk](/misc/funk.wav) downloaded, we can
load them in *Sonic Pi* with the `load_sample` instruction and play
them in this way:

```ruby
maquillage = "~/il-macquillage-lady.wav"
load_sample maquillage
sample maquillage
```

Which means:

* put in `maquillage` the path to the audio file
* load the audio file in *Sonic Pi* with `load_sample`
* play this audio file with `sample`

As previously seen, *Aerodynamic* has a tempo of 123 BPM, which is not
the case of the extract of the *Sister Sledge*, we have to stretch it
so it is exactly at 123 BPM:

```ruby
use_bpm 123

maquillage = "~/il-maquillage-lady.wav"
load_sample maquillage
sample maquillage, beat_stretch: 16
```

The call to `use_bpm` is now familiar, `beat_stretch` is somehow
magic: it stretches the sample so its duration is exactly of 16
beats at 123 BPM, exactly like *Aerodynamic*. Now, we can play
a sample from this extract with the help of the `start` and `finish`
parameters:

```ruby
use_bpm 123

maquillage = "~/il-maquillage-lady.wav"
load_sample maquillage
sample maquillage, beat_stretch: 16, start: 0.0, finish: 1/16.0
```

`start` an `finish` are indices (their value is between 0.0 and 1.0):

- 0.0 is the beginning of the extract
- 1.0 is the end of the extract

As the extract's duration is 16 beats, we are here playing the first
beat by going from 0.0 to 1/16.0. Some other examples:

* `start: 6.0 / 16.0`: start to play at beat 6
* `start: 2.5 / 16.0`: start to play at beat 2.5
* `finish: 0.5 / 16.0`: stop playing at beat 0.5

This way we can extract the samples used by *Aerodynamic* and find the
corresponding ones in *Il Macquillage Lady*.

## Let's funk

To simplify the task, here's a *Sonic Pi* function which will help
us:

```ruby
use_bpm 123

maquillage = "~/il-macquillage-lady-sample.wav"
load_sample maquillage

aerodynamic = "~/funk.wav"
load_sample aerodynamic

define :sample_chunk do |what, beat, dur, delay|
    beat = beat / 16.0
    dur = dur / 16.0
    sample what, beat_stretch: 16, start: beat, finish: beat + dur
	sleep delay
end

sample_chunk(maquillage, 4.0, 1.0, 0.0)
```

The `define` instruction creates a new keyword in *Sonic Pi* ; here we
create a keyword called `sample_chunk` which takes the following 4
parameters:

* `what` : the sample to be played
* `beat` : the beat of the sample to play
* `dur` : the duration of the sample
* `delay` : the time to pause before continuing

So, if we want to play the extract from *Il Macquillage Lady* at beat
4 for a duration of 1 beat, we can do:

```ruby
sample_chunk(maquillage, 4.0, 1.0, 0.0)
```

Another example, play the first semi-beat of the extract *Aerodynamic*
and wait two beats:

```ruby
sample_chunk(aerodynamic, 0.0, 0.5, 2.0)
```

We can now easily play any sample from both extracts! After several
hours of listenings and hacking, here's what we can obtain:

```ruby
use_bpm 123

maquillage = "~/il-macquillage-lady.wav"
aerodynamic = "~/funk.wav"

load_sample maquillage
load_sample aerodynamic

define :sample_chunk do |what, beat, dur, delay|
    beat = beat / 16.0
    dur = dur / 16.0
    sample what, beat_stretch: 16, start: beat, finish: beat + dur
    sleep delay
end

define :funk do
    # sample_chunk(aerodynamic, 0.0, 4.0, 4.0)

    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.75)
    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)

    # sample_chunk(aerodynamic, 4.0, 4.0, 4.0)

    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)

    # sample_chunk(aerodynamic, 8.0, 4.0, 4.0)

    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.75)
    sample_chunk(maquillage, 0.0, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)

    # sample_chunk(aerodynamic, 12.0, 4.0, 4.0)

    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.25, 0.0)
    sample_chunk(maquillage, 2.5, 1.0, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.25, 0.25)
    sample_chunk(maquillage, 3.5, 0.5, 0.5)
    sample_chunk(maquillage, 8.5, 0.5, 0.5)
    sample_chunk(maquillage, 2.5, 1.0, 1.0)
    sample_chunk(maquillage, 7.5, 0.5, 0.5)
end

funk
```

Everything is in a new instruction called `funk`, we simply invoke it
without parameters. An extra note here: if we sum the values of the
delay parameter, we obtain 16 beats, which is reassuring since the
original extract is 16 beats.

## A bit of makeup

Something is missing when we compare this to the *Daft Punk*'s
version, there's a cyclic effect every 8 beats, which can be obtained
via the `ixi_techno` effect of *Sonic Pi*:

```ruby
live_loop :funk do
    with_fx :ixi_techno, mix: 0.1, phase: 8, cutoff_min: 90 do
        funk
    end
end
```

`live_loop` is a new keyword which wraps a block in a loop: at the end
of the block, we go back at the beginning by taking into account
changes inside the block. This is handy because in this way, we can
live edit the content of the loop and experiment easily. Each time a
modification is made inside the loop, *Sonic Pi*'s buffer has to be
re-evaluated (by clicking on `Run`) to take into account changes.

For instance, we can inspect the influence of the `mix` parameter
this way:

* start by evaluating everything with `Run`
* change the value of `mix` to 0.5
* evaluate a second time with `Run`

On the next iteration of the loop, we hear the modification. This
approach is powerful as it allows to live edit a track and to
make it evolves bit by bit!

<a href="/music/2016-01-26-aerodynamic-solo-en.html">Next...</a>

<hr />

*This article is part of the <a href="/music/2016-01-21-aerodynamic-en.html">Aerodynamic</a> guide.*
