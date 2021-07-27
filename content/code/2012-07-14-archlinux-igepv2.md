---
categories:
- code
date: "2012-07-14T00:00:00Z"
title: Archlinux Arm on IGEPv2
---

Just a few notes about the installation of [ArchLinuxARM](http://archlinuxarm.com)
on a IGEPv2 card, this is very easy as tarballs are already provided
to do the job.

## Formatting the SD Card

The first step is to format the SD card, I'm using an 8GB card, I
create two partitions on it, one for the boot in FAT and the other in
EXT to host the root filesystem. Here's a script to do the job, this
is inspired from [a script of Graeme Gregory](http://downloads.angstrom-distribution.org/demo/beaglebone/mkcard.txt).

```bash
#!/usr/bin/env bash
# s. rannou <mxs@sbrk.org>
#
# a script to setup an SD card for IGEPv2 (bender), may be harmful.

device=/dev/sdb

# formats the sd cards into two partitions (boot and rootfs)
function prepare-card {
    echo "erasing partition layout..."
    dd if=/dev/zero of=$device bs=1024 count=1024
    size=$(sudo fdisk -l | grep "Disk ${device}:" | awk '// {print $5; }')
    echo "creating partitions..."
    if [ "$size" -gt 0 ]
    then
        cylinders=$(echo "${size}/255/63/512" | bc)
        {
            echo ,9,0x0C,*
            echo ,,,-
        } | sudo sfdisk -D -H 255 -S 63 -C $cylinders $device

    else
        echo "can't retrieve size of ${device}"
        exit
    fi

    # this is a wrong assumption
    p1="${device}1"
    p2="${device}2"

    echo "formating boot partition..."
    sudo mkfs.vfat -F 32 -n "boot" $p1
    echo "formating rootfs partition..."
    sudo mke2fs -j -L "rootfs" $p2
}

echo -n "ready to nuke ${device}? y/n "
read confirm
if [ "$confirm" = "y" ]
then
    prepare-card
else
    echo "aborted"
fi
```

## Preparing the Partitions

The hard work is already done, we only have to fetch tarballs, extract
the u-boot tarball to the boot partition, then the root tarball to the
root filesystem, and finally to generate an environment for u-boot to
start, here's a script to perform these steps :

```bash
#!/usr/bin/env bash
# s. rannou <mxs@sbrk.org>
#
# a script to install archlinux arm on a formatted sd card for IGEPv2

device=/dev/sdb

# get tarballs from archlinuxarm.org
function dl-archives {
    if ! [ -f IGEPv2-bootloader.tar.gz ]
    then
        wget http://archlinuxarm.org/os/omap/IGEPv2-bootloader.tar.gz
    fi

    if ! [ -f ArchLinuxARM-omap-smp-latest.tar.gz ]
    then
        wget http://archlinuxarm.org/os/ArchLinuxARM-omap-smp-latest.tar.gz
    fi
}

# prepares u-boot on the boot partition
function install-uboot {
    sudo tar -xvf IGEPv2-bootloader.tar.gz -C /mnt/igep-boot
    sudo cp /mnt/igep-root/boot/uImage /mnt/igep-boot/
    sudo mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "IGEP v2 boot script" -d boot.cfg boot.scr
    sudo mv boot.scr /mnt/igep-boot/
}

# prepares the root filesystem
function install-root {
    sudo tar -xvf ArchLinuxARM-omap-smp-latest.tar.gz -C /mnt/igep-root
}

echo -n "ready to nuke ${device}? y/n "
read confirm
if [ "$confirm" = "y" ]
then
    dl-archives
    sudo mkdir -p /mnt/igep-boot /mnt/igep-root
    sudo mount "${device}1" /mnt/igep-boot
    sudo mount "${device}2" /mnt/igep-root
    install-root
    install-uboot
    sudo umount /mnt/igep-boot
    sudo umount /mnt/igep-root
else
    echo "aborted"
fi
```

And here's the boot.cfg file that is required to generate the boot.scr:

```bash
setenv bootargs 'console=ttyO2,115200n8 root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait'
mmc init
fatload mmc 0 0x80300000 uImage
bootm 0x80300000
boot
```

That's it, we are ready to boot.

## First Boot

For the first boot I use a serial adapter with minicom, but you can
also directly use the network as there's an SSH automatically starting
so if you have a DHCP, you know what to do.
