---
categories:
- projects
date: "2015-02-16T00:00:00Z"
icon: projects
link: https://github.com/aimxhaisse/collectator
title: collectator
---

`Collectator` is a binary that periodically polls several metrics from a system.


## Usage

    $ ./collectator --help
        Usage of ./collectator:
	      -period=1: refresh period in seconds

## Example

    collectator> time:1420820192 load_avg:0.020000 mem_active:2268284.000000 cpu_user:0.000000 cpu_nice:0.000000 cpu_system:0.125156 cpu_idle:99.874844 cpu_iowait:0.000000 cpu_irq:0.000000 cpu_softirq:0.000000 cpu_guest:0.000000 cpu_guest_nice:0.000000

## Current Metrics

* `time` timestamp in seconds
* `load_avg` load average (1 minute)
* `mem_active` active memory in kb
* `cpu_*` global % CPU usage (using first line from /proc/stats)

## Compile

    go build

## Compile for armv7l

    make

More on [github](https://github.com/aimxhaisse/collectator).
