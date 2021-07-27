---
categories:
- code
date: "2009-08-22T00:00:00Z"
title: Boostrapping from the BIOS
---

The BIOS is the first code running on a computer at start-up, it
performs several operations on hardware such as initializations or
tests, before the loading of the operating system. In this article we
will see how the commutation between BIOS and the operating system
occurs.

## Rough Steps

### Startup

Once the BIOS has finished its operations, it looks for a list of
devices to boot on : hard drive, floppy, CD-ROM, ...  This list
depends on your BIOS' configuration, and can be changed.

### Is the device bootable?

On each of these devices, the bios will try to load the first 512
bytes from the device if the media is ready to be read.  Then the BIOS
will look at the offset 510 (decimal), to see if the magic number
00AA55 (16 bits) is present, if so, the media is considered to be
bootable.

### Implementation

Here is an assembly implementation that prints a cup of coffee at
startup:

```nasm
;; A bootstrapper that prints a cup of coffee
 
org     0
jmp     07C0h:start
logo:   db      10,13,10,
"       ~"      ,13,10,
"     _----_"   ,13,10,
"    |-____-|"  ,13,10,
"    |      |"  ,13,10,
"    |      |"  ,13,10,
"    \______/"  ,10,13,10,
"         Niiahhh coffee." ,13,10,0
 
start: 
 push   cs
 pop    ds
 mov    ecx, logo
 
loop: 
 mov    ah, 0x0e        ; print a char
 mov    al, BYTE [ecx]  ; the char
 int    10h
 inc    ecx
 cmp    BYTE [ecx], 0
 jne    loop

hang:
        cli
        hlt
        jmp     hang    ; Infinite loop
 
;; Filling up to 510 bytes with 0
times   510-($-$$) db 0

;; The magic number
dw      0AA55h
```

As performing real stuff in 512 bytes is a hard work, most operating
systems use this sequence to load another bootstrapper.

## Let's Boot!

We just need to create an image and put it on a device, here a floppy.

```bash
$ nasm bootstrap.s -o bootstrap.bin
$ dd if=bootstrap.bin of=path_to_floppy
1+0 records in
1+0 records out
512 bytes (512 B) copied, 6.6279e-05 s, 7.7 MB/s
```

Now you can reboot with the floppy and the BIOS configured to use the
floppy device first.

More about this can be found by reading [OpenBSD's bootstrap](http://www.openbsd.org/cgi-bin/cvsweb/src/sys/arch/i386/boot/Attic/start.S?rev=1.8;content-type=text%2Fplain).
