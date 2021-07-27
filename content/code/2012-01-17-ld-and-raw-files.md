---
categories:
- code
date: "2012-01-17T00:00:00Z"
title: include raw files with ld
---

As far as I know, there's no direct way to include a raw file with ld,
I've been looking for it at many places without success. This may seem
a stupid idea but there are some cases where it can be pretty handy,
for example when you are working on a kernel and want to introduce a
kind of initramfs mechanism. So you have this big file you want to
link with your kernel at some place in memory, but ld will complain
because it doesn't recognize the format.

Well, here's one solution to the problem: generate a second linker
script that contains the content of your raw file using the BYTE
function. Here's a way to do it using hexdump:

```bash
$ cat ramelfs | hexdump -v -e '"BYTE(0x" 1/1 "%02X" ")\n"' > ramelfs.ld
```

That will generate a file that looks like this:

```bash
$ cat ramelfs | more
BYTE(0x09)
BYTE(0x19)
BYTE(0x00)
BYTE(0x00)
BYTE(0x68)
BYTE(0x65)
BYTE(0x6C)
... an so on
```

Now you can include this file in your former linker script, and the
raw file will be present in memory :

```awk

/* extract from a linker.ld, many parts are ommited */

OUTPUT_FORMAT("binary")

SECTIONS {
    .text : {
        kramelfs = .;
        INCLUDE "ramelfs/ramelfs.ld" ;
        kramelfs_end = .;
        . = ALIGN(PAGE_SIZE);
        kcode_end = .;
	/* ... */
    }
}
```

And that's it. If someone is aware of a better solution I'm highly
interested.
