---
categories:
- code
- news
date: "2013-02-14T00:00:00Z"
plugin: lightense
title: pretty dmesg
---

By default, the date in `dmesg`'s output is a bit cryptic, it is
the number of seconds and milliseconds since the system started:

```bash
$ dmesg | grep CPU0 | head -n 1
[    0.005027] CPU0: Thermal monitoring enabled (TM1)
```

Some versions of dmesg have an option to get a human readable
date:

```bash
$ dmesg -T | grep CPU0
[Sun Jul  1 13:58:18 2012] CPU0: Intel(R) Core(TM) i5-2300 CPU @ 2.80GHz stepping 07
```

Unfortunately some versions don't, as I recently had to work with
those I made a script to perform the conversion:

```bash
#!/usr/bin/env bash
#
# author s. rannou <mxs@sbrk.org>
# converts [seconds.milliseconds] from dmesg output to a pretty date

export uptime=$(cat /proc/uptime | cut -d'.' -f1)
export current_ts=$(date '+%s')

while read line
do
    echo $line | awk '
    match($0, /\[ *([0-9]*). *([0-9]*)\] (.*)/, m) {
	total_secs = m[1] + (ENVIRON["current_ts"] - ENVIRON["uptime"]);
	print "[", strftime("%c", total_secs), "]", m[3]
    }
'
done
```

Now you can just pipe the output of dmesg to the script, to get a
nearly similar output:

```bash
$ dmesg | grep CPU0 | head -n 1 | ./pretty 
[ Sun 01 Jul 2012 01:58:19 PM CEST ] CPU0: Thermal monitoring enabled (TM1)
```

The script discards the milliseconds, so there may be a one second gap
with the pretty output of dmesg versions.
