---
categories:
- projects
date: "2015-12-11T00:00:00Z"
icon: projects
link: https://github.com/aimxhaisse/dummy-wav2pi
title: dummy wav2pi
---

`Dummy wav2pi` is a failed attempt to convert a WAV to a Sonic Pi
serie of sines. This kind-of works, but this is probably not what you
are looking for.

Example of input:

```
$ ./analyze.py bell.wav

synth :sine, note: :D3, sustain_level: 1.7931, sustain: 1, release: 0
synth :sine, note: :Fs5, sustain_level: 0.564, sustain: 1, release: 0
synth :sine, note: :As5, sustain_level: 0.518, sustain: 1, release: 0
synth :sine, note: :As4, sustain_level: 0.516, sustain: 1, release: 0
synth :sine, note: :Cs4, sustain_level: 0.496, sustain: 1, release: 0
synth :sine, note: :Fs3, sustain_level: 0.495, sustain: 1, release: 0
synth :sine, note: :As3, sustain_level: 0.459, sustain: 1, release: 0
sleep 1

synth :sine, note: :D3, sustain_level: 1.8665, sustain: 1, release: 0
synth :sine, note: :Fs5, sustain_level: 0.452, sustain: 1, release: 0
synth :sine, note: :Cs3, sustain_level: 0.382, sustain: 1, release: 0
synth :sine, note: :Cs4, sustain_level: 0.353, sustain: 1, release: 0
synth :sine, note: :Fs3, sustain_level: 0.352, sustain: 1, release: 0
synth :sine, note: :C4, sustain_level: 0.3443, sustain: 1, release: 0
synth :sine, note: :As4, sustain_level: 0.339, sustain: 1, release: 0
sleep 1

synth :sine, note: :D3, sustain_level: 1.4424, sustain: 1, release: 0
synth :sine, note: :Cs4, sustain_level: 0.295, sustain: 1, release: 0
synth :sine, note: :Fs3, sustain_level: 0.294, sustain: 1, release: 0
synth :sine, note: :C4, sustain_level: 0.2835, sustain: 1, release: 0
synth :sine, note: :Cs3, sustain_level: 0.270, sustain: 1, release: 0
synth :sine, note: :Fs5, sustain_level: 0.247, sustain: 1, release: 0
synth :sine, note: :E4, sustain_level: 0.2046, sustain: 1, release: 0
sleep 1

synth :sine, note: :D3, sustain_level: 0.8096, sustain: 1, release: 0
synth :sine, note: :E4, sustain_level: 0.2086, sustain: 1, release: 0
synth :sine, note: :A3, sustain_level: 0.2063, sustain: 1, release: 0
synth :sine, note: :Cs3, sustain_level: 0.190, sustain: 1, release: 0
synth :sine, note: :C4, sustain_level: 0.1618, sustain: 1, release: 0
synth :sine, note: :Cs4, sustain_level: 0.157, sustain: 1, release: 0
synth :sine, note: :Fs3, sustain_level: 0.157, sustain: 1, release: 0
sleep 1

synth :sine, note: :D3, sustain_level: 0.6013, sustain: 1, release: 0
synth :sine, note: :E4, sustain_level: 0.1420, sustain: 1, release: 0
synth :sine, note: :Cs3, sustain_level: 0.141, sustain: 1, release: 0
synth :sine, note: :A3, sustain_level: 0.1397, sustain: 1, release: 0
synth :sine, note: :Cs4, sustain_level: 0.131, sustain: 1, release: 0
synth :sine, note: :Fs3, sustain_level: 0.131, sustain: 1, release: 0
synth :sine, note: :C4, sustain_level: 0.1185, sustain: 1, release: 0
sleep 1

synth :sine, note: :D3, sustain_level: 0.5005, sustain: 1, release: 0
synth :sine, note: :Cs3, sustain_level: 0.104, sustain: 1, release: 0
synth :sine, note: :C4, sustain_level: 0.0979, sustain: 1, release: 0
synth :sine, note: :Cs4, sustain_level: 0.093, sustain: 1, release: 0
synth :sine, note: :Fs3, sustain_level: 0.093, sustain: 1, release: 0
synth :sine, note: :E4, sustain_level: 0.0806, sustain: 1, release: 0
synth :sine, note: :A3, sustain_level: 0.0786, sustain: 1, release: 0
sleep 1

synth :sine, note: :D3, sustain_level: 0.3227, sustain: 1, release: 0
synth :sine, note: :E4, sustain_level: 0.0795, sustain: 1, release: 0
synth :sine, note: :A3, sustain_level: 0.0787, sustain: 1, release: 0
synth :sine, note: :Cs3, sustain_level: 0.066, sustain: 1, release: 0
synth :sine, note: :C4, sustain_level: 0.0642, sustain: 1, release: 0
synth :sine, note: :Cs4, sustain_level: 0.053, sustain: 1, release: 0
synth :sine, note: :Fs3, sustain_level: 0.053, sustain: 1, release: 0
sleep 1

synth :sine, note: :D3, sustain_level: 0.2078, sustain: 1, release: 0
synth :sine, note: :E4, sustain_level: 0.0775, sustain: 1, release: 0
synth :sine, note: :A3, sustain_level: 0.0768, sustain: 1, release: 0
synth :sine, note: :Cs4, sustain_level: 0.047, sustain: 1, release: 0
synth :sine, note: :Fs3, sustain_level: 0.047, sustain: 1, release: 0
synth :sine, note: :C4, sustain_level: 0.0447, sustain: 1, release: 0
synth :sine, note: :Cs3, sustain_level: 0.035, sustain: 1, release: 0
sleep 1
```

More on [github](https://github.com/aimxhaisse/dummy-wav2pi).
