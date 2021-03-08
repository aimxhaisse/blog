---
categories:
- code
- news
date: "2011-02-26T00:00:00Z"
title: My Laptop is Burning
---

I have a laptop with hybrid ATI GPUs, without the proprietary ATI
driver, the temperature of the laptop is ... very warm : the CPU's
temperature is between 90 and 105 degrees.  This leads to random
crashes, random reboots, and there is this constant sound of fans
running in background.

This article assumes you are using Archlinux with a recent kernel, and
you have a laptop with hybrid GPUs, I'm also using the open source ATI
driver (xf86-video-ati) and KMS is enabled :

```bash
$ uname -a
Linux nibbler 2.6.37-ARCH...
$ lspci | grep VGA 
01:05.0 VGA compatible controller: ATI Technologies Inc M880G [Mobility Radeon HD 4200]
02:00.0 VGA compatible controller: ATI Technologies Inc Redwood [Radeon HD 5600 Series]
$ lsmod  | grep -i radeon
radeon                845112  2 
ttm                    44512  1 radeon
drm_kms_helper         23703  1 radeon
drm                   141488  4 radeon,ttm,drm_kms_helper
i2c_algo_bit            4191  1 radeon
i2c_core               16029  6 videodev,radeon,drm_kms_helper,drm,i2c_piix4,i2c_algo_bit
$
```

## Disabling one GPU

This is probably the best way to win degrees, with this my CPU is
running between 55 and 65 degrees. The first step is to enable
debugfs, by adding the following line to */etc/fstab*:

```bash
none /sys/kernel/debug debugfs defaults 0 0
```

Then, to disable one GPU, simply do the following as root:

```bash
# echo OFF > /sys/kernel/debug/vgaswitcheroo/switch
```

This has to be done before starting X (otherwise it crashes).  You can
append that line to */etc/rc.local* if you want it to be executed at
start-up.

## Changing the governor

Changing the governor can also be a solution, but this has the
inconvenient to slow down the laptop (the frequency of the CPU will be
dynamically changed by the kernel). With it I win about 5/10
degrees. If you don't care of your GPU performances but care about the
CPU, the first solution might be better. More about this can be found
on Archlinux's wiki:
[CPU Frequency Scaling](https://wiki.archlinux.org/index.php/Cpufrequtils).
