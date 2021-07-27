---
categories:
- aero_en
- music
date: "2016-01-27T00:00:00Z"
icon: music
title: everything together
disable_listing: true
---

*This article is part of the <a href="/music/2016-01-21-aerodynamic-en">Aerodynamic</a> guide.*

Now that we have all the parts of the track, we'll see how to put
everything together. We already have a glimpse of what live loops are,
as a reminder:

```ruby
live_loop :hej do
    play :C3
    sleep 4
end
```

This defines a live loop called `hej`, which every 4 beats plays the
note `C3`. If we modify this loop in live, for instance by changing
the note, and evaluate everything (via the `Run` button), at the next
iteration, the note changes. In this way, we can control each live
loop independently, and little by little build a track.

## Synchronisation

We can have as many live loops as we want, provided they have a
different name:

```ruby
live_loop :hej do
    play :C3
    sleep 4
end

live_loop :san do
    play :E5
    sleep 1
end
```

Here we have two loops:

* `hej` plays the note *C3* every 4 beats
* `san` plays the note *E5* on every beat

When we evaluate this code, both loops are created at the same time
and so, they are automatically synchronized. But if we create the
second loop a little after the first one, they won't be synchronized
and will be off the beat.

```ruby
live_loop :hej do
    play :C3
    sleep 4
end

sleep 0.3

live_loop :san do
    play :E5
    sleep 1
end
```

This kind of shift can also happen if by mistake, we miscalculate the
value of the sleep (which often happens when live coding) : for
instance, if instead of waiting 1 beat, we wait 1/3 of a beat, we'll
be desynchronized for the rest of the performance.

To avoid these shifts, we can ask *Sonic Pi* to synchronize live
loops, that is, to tell a loop to start when another one starts:

```ruby
live_loop :main do
    sleep 1
end

sleep 0.4

live_loop :hej do
    sync :main

    play :C3
    sleep 4
end

sleep 0.3

live_loop :san do
    sync :main

    play :E5
    sleep 1
end
```

We have introduced a third loop called `main` which fires every beat
but does nothing, we only use it so as to synchronize other loops.

The `sync` keyword synchronizes one loop on another, here, we force
the loops *hej* and *san* to start whenever the loop *main* starts:
no matter the shifts, they'll always start on the main beat.

Another useful keyword is `stop`, which stops a loop: by adding it
inside the *hej* loop and by evaluating everything, it stops to play
the *C3* note every 4 beats ; then, if we add it back, and evaluate,
the *C3* will be heard again, and because the loop is synced on every
beat, we keep synchronization. In this way, we can temporarily enable
/ disable parts of the track.

## Aerodynamic

We finally have all elements to play *Aerodynamic*, here's the
complete code with the necessary loops, in bonus, I've added an extra
live loop called `extra_beat` which may be helpful. Have fun!

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

# Live loops

live_loop :main do
    sleep 4
end

live_loop :funk do
    sync :main

    with_fx :ixi_techno, mix: 0.1, phase: 8, cutoff_min: 90, cutoff_max: 120, res: 0.9, amp: 1 do
        with_fx :bpf, mix: 0, res: 0.00001, centre: :B8, amp: 2 do
            funk
        end
    end
end

live_loop :solo do
    sync :main

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

live_loop :extra_beat do
    sync :main

    32.times do
        tick
        sample :bd_fat, amp: 2 if spread(1, 16).look
        sample :bd_fat, amp: 1.5 if spread(1, 32).rotate(4).look
        synth :cnoise, release: 0.6, cutoff: 130, env_curve: 7, amp: 1 if spread(1, 16).rotate(8).look
        synth :cnoise, release: 0.1, cutoff: 130, env_curve: 7, amp: 0.25 if spread(1, 2).look
        sleep 0.125
    end
end

live_loop :intro do
    stop # remove me if you want bells

    sync :main

    use_synth :pretty_bell
    use_synth_defaults release: 9

    with_fx :level, amp: 0.5 do
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
    end
end
```

<hr />

*This article is part of the <a href="/music/2016-01-21-aerodynamic-en">Aerodynamic</a> guide.*
