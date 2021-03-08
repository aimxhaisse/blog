---
categories:
- aero_en
date: "2016-01-26T00:00:00Z"
icon: music
title: electric solo
---

*This article is part of the [Aerodynamic]({% post_url music/2016-01-21-aerodynamic-en %})* guide.

We now move on to the `solo` part of the track, here's what it
looks like once imported in *Sonic Visualizer*:

<img src="/public/img/aerodynamic/solo.png" data-action="zoom" />

Here again, it is a spectrogram with in abcissa the time, and in
ordinate the audio frequencies. We see horizontal stripes composed of
spots (the active audio frequencies): these are the different notes.
They are gathered in several phases, each phase being composed of 3
horizontal lines of a duration of 16 beats. When zooming on one of
these phases, we see it is actually a repetition of notes in the
following fashion:

<img src="/public/img/aerodynamic/solo-notes.png" data-action="zoom" />

We can get the note behind each spots with *Sonic Visualizer*, and
recompose the first beat:

1. play the note `D` during 1/4 beat
1. play the note `Fs` during 1/4 beat
1. play the note `E` during 1/4 beat
1. play the note `Fs` during 1/4 beat

By using an instrument with an electric timbre, we can already have
something not far from what we are looking for in *Sonic Pi*:

```ruby
use_bpm 123

use_synth :zawa
use_synth_defaults attack: 0.05, sustain: 0.15, release: 0.125

live_loop :solo do
    play :D4
    sleep 0.25
    play :Fs3
    sleep 0.25
    play :B3
    sleep 0.25
    play :Fs3
    sleep 0.25
end
```

We configure the *zawa* instrument with the parameters `attack`,
`sustain` and `release`. These parameters are what we call the
envelope of a sound (or `ADSR`) ; they define the way the intensity of
a note evolves with time :

<img src="/public/img/aerodynamic/solo-adsr.png" data-action="zoom" />

Each letter corresponds to one of these sections (**A**ttack,
**D**ecay which we aren't using here, **S**ustain, and
**R**elease). To understand how they impact a note, the easiest way is
to update them in live and hear the difference (again, by editing the
code and by evaluating it with `Run`).

## Factorisation

Instead of asking *Sonic Pi* to play a first note, then make a pause,
then play a second note, then again another pause, …, we can formulate
this in a better way:

```ruby
use_bpm 123

use_synth :zawa
use_synth_defaults attack: 0.05, sustain: 0.15, release: 0.125

notes = [:D4, :Fs3, :B3, :Fs3]

live_loop :solo do
  notes.each do |n|
      play n
      sleep 0.25
  end
end
```

Which means:

* use a BPM of 123, use the *zawa* instrument, setup the *ADSR* of the instrument
* store in the list called `notes` the following notes: *D4*, *Fs3*, *B3* and *Fs3*
* create a live loop in which…
* for each note `n` from the list `notes`…
* play the note `n`, then wait 0.25 beat

We obtain the same thing and we can modify the notes without having to
worry about the code.

## A few steps ahead

By using the same approach, we can get the 32 beats of the `solo`
part:

| Phase | Note 1 | Note 2 | Note 3 | Note 4 |
|-------|--------|--------|--------|--------|
| #1    |  D4    |  Fs3   |  B3    |  Fs3   |
| #2    |  D4    |  Gs3   |  B3    |  Gs3   |
| #3    |  G4    |  B3    |  E4    |  B3    |
| #4    |  E4    |  A3    |  Cs4   |  A3    |
| #5    |  D4    |  Fs4   |  B3    |  Fs4   |
| #6    |  D4    |  Gs4   |  B3    |  Gs4   |
| #7    |  G4    |  B3    |  E4    |  B3    |
| #8    |  E4    |  A3    |  Cs4   |  A3    |

In the same fashion as for notes, we can iterate on a list containing
each of these phases, and play them 4 times each:

```ruby
live_loop :solo do
    use_synth :zawa
    use_synth_defaults attack: 0.05, sustain: 0.15, release: 0.125

    phases = [
        [:D4, :Fs3, :B3, :Fs3],
        [:D4, :Gs3, :B3, :Gs3],
        [:G4, :B3, :E4, :B3],
        [:E4, :A3, :Cs4, :A3],

        [:D4, :Fs4, :B3, :Fs4],
        [:D4, :Gs4, :B3, :Gs4],
        [:G4, :B3, :E4, :B3],
        [:E4, :A3, :Cs4, :A3],
    ]

    phases.each do |notes|
        4.times do
            notes.each do |n|
                play n
                sleep 0.25
            end
        end
    end
end
```

[Next...]({% post_url music/2016-01-27-aerodynamic-everything-en %})

<hr />

*This article is part of the [Aerodynamic]({% post_url music/2016-01-21-aerodynamic-en %})* guide.
