---
categories:
- code
date: "2011-03-24T00:00:00Z"
title: Notes about LUKS
---

Some notes about basic usage with Luks.

## Encrypting a partition

This memo assumes your USB device is `/dev/sdc/`, a 4GB USB key
divided into two partitions of 2GB, a public (`/dev/sdc1`) and a
private one (`/dev/sdc2`, the one that is encrypted). We need to
randomize the content of the private partition so as to start with a
space without predictable patterns in it (such as old files, zeroes,
...).

```bash
$ sudo dd if=/dev/urandom of=/dev/sdc2 bs=1M
```

We can create the encrypted device using luks:

```bash
$ sudo cryptsetup --verify-passphrase --verbose --hash=sha256 \
                  --cipher=aes-cbc-essiv:sha256 --key-size=128 \
                  luksFormat /dev/sdc2
```

And finally map it to `/dev/mapper/`:

```bash
$ sudo cryptsetup luksOpen /dev/sdc2 private
```

This creates the device `/dev/mapper/private/` corresponding to
`/dev/sdc2`, we can use it as an unencrypted device; let's format it
in ext4:

```bash
$ sudo mkfs.ext4 /dev/mapper/private
$ sudo cryptsetup luksClose private
```

Now we have an encrypted partition formated in ext4.

## Mounting the partition

```bash
$ sudo cryptsetup luksOpen /dev/sdc2 private
$ sudo mount /dev/mapper/private /media/usb_private
```

## Unmounting the partition

```bash
$ sudo umount /media/usb_private
$ sudo cryptsetup luksClose private
```
