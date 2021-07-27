---
categories:
- code
date: "2010-02-14T00:00:00Z"
title: FreeBSD and Jails
---

The jail system is a specific feature of FreeBSD that adds a level of
security by wrapping a process into a sub-system. Where chroot is
usually used, jails may be welcomed as they also restrict the process
into a closed environment, with a restricted set of devices. This way,
a process running into a jail can't affect processes living outside.

Jails are useful when you can't trust your users or services, if they
take control of the machine, their actions are limited to the jail
(assuming its implementation is safe, this has not always been true in
the past).

## Installation and configuration of the jail

We will create a jail for pure-ftpd, located in `/jails/ftp`:

```bash
root# mkdir /jails/ftp
root# cd /usr/src
root# make buildworld
root# make installworld DESTDIR=/jails/ftp
root# make distribution DESTDIR=jails/ftp
root# echo "devfs /jails/ftp/dev devfs rw 0 0" >> /etc/fstab
```

It's a good idea to mount jails in a separate partition, so that if
someone makes bullshit in one of them, it won't affect the host with a
"filesystem is full". The sub-system is now installed, let's edit its
`rc.conf`:

```bash
root# cat /jails/ftp/rc.conf
hostname="jailftp"
ifconfig_em0="inet 192.168.1.21 netmask 255.255.255.255"
defaultrouter="ip.of.the.host"
clear_tmp_enable="YES"
kern_securelevel_enable="YES"
kern_securelevel="3"
root#
```

Last thing to do is registering the jail in the host by adding some
settings to `rc.confà (the one of the host this time):

```bash
root# tail -n 11 /etc/rc.conf
# jail stuff
jail_enable="YES"
jail_list="ftp"

# jail-ftp related stuff
ifconfig_re0_alias0="inet 192.168.1.21 netmask 255.255.255.0"
ftpd_enable="NO"
jail_ftp_rootdir="/jails/ftp"
jail_ftp_hostname="jailftp"
jail_ftp_ip="192.168.1.21"
jail_ftp_devfs_enable="YES"
jail_ftp_devfs_ruleset="devfsrules_jail"
root# 
```

After rebooting, we can see active jails with jls:

```bash
[mxs@buffout:~/]% jls
JID IP Address Hostname Path
1 192.168.1.21 jailftp /jails/ftp
[mxs@buffout:~/]%
```

An important information here is the ID of the jail (1), which allows
us to launch a command as root inside the jail, let's open a shell
inside the jail, with jexec :

```bash
[mxs@buffout:~/]% sudo jexec 1 tcsh
jailftp# id
uid=0(root) gid=0(wheel) groups=0(wheel),5(operator)
jailftp# 
```

Now we can administrate our jail as if we were on a classic system.

## Installation of a service: pure-ftpd

If you have several jails, it's borring to keep up to date several
trees of ports, it's a good idea to share the port tree of the host by
mouting it into jails.

```bash
[mxs@buffout:~/]% cat /dev/fstab | grep /jails/ftp/
/usr/ports /jails/ftp/usr/ports nullfs ro 0 0
[mxs@buffout:~/]% sudo mount -a
[mxs@buffout:~/]% cd /usr/ports/ftp/pure-ftpd
[mxs@buffout:~/]% sudo make fetch
```

Back in the jail, we can install the port without forgetting to set
`WRKDIRPREFIX` to a directory where we have rights (as `/usr/ports` is
mounted in read-only).

```bash
jailftp# cd /usr/ports/ftp/pure-ftpd
jailftp# make install clean WRKDIRPREFIX=/tmp
```

Once pure-ftpd is compiled and installed, we simply have to create
accounts on the jail to have FTP access. We need set the listening
address/port to the address of the jail:

```bash
jailftp# cat /usr/local/etc/pure-ftpd.conf | grep -i bind
Bind 192.168.1.21,21
jailftp#
```

At this time, we can only connect to the jail from the host system.
FTP uses port 21 to accept connections, and a random range of ports
for passive mode (used once the connection is opened). We need to
restrict the range of ports used by pure-ftpd:

```bash
jailftp# cat usr/local/etc/pure-ftpd.conf | grep -i range
# Port range for passive connections replies. - for firewalling.
PassivePortRange 11000 11004
jailftp#
```

Pure-ftpd is now ready, let's launch it when the jail starts:

```bash
jailftp# echo 'pureftpd_enable="YES"' >> /etc/rc.conf
```

We need to add redirect rules to `/etc/filters/ipnat.rules` so that
when a connection uses ports related to FTP on the host, it's
redirected to the jail:

```bash
[mxs@buffout:~/]% cat /etc/filters/ipnat.rules
# ftpjail
rdr re0 94.23.241.199/32 port 21 -> 192.168.1.21 port 21
rdr re0 94.23.241.199/32 port 11000 -> 192.168.1.21 port 11000
rdr re0 94.23.241.199/32 port 11001 -> 192.168.1.21 port 11001
rdr re0 94.23.241.199/32 port 11002 -> 192.168.1.21 port 11002
rdr re0 94.23.241.199/32 port 11003 -> 192.168.1.21 port 11003
rdr re0 94.23.241.199/32 port 11004 -> 192.168.1.21 port 11004
[mxs@buffout:~/]% cat /etc/rc.conf | grep ipnat
ipnat_enable="YES"
ipnat_rules="/etc/filters/ipnat.rules"
[mxs@buffout:~/]%
```

We can reboot once again, FTP is now accessible from the outside :)

## Rights and user management

Imagine the following situation: you have a www jail with a web
server, and want your users from the host to have a web access. One
solution is to create them a user on the jail and to configure ssh so
they can login from the host to the jail.

But this have several cons: they need to ssh twice to edit their www
account, and they might have tools on the host (emacs?) that are not
installed in the jail, so you need to install it for each jail.

That's ugly.

Another solution is to create them a user on the jail (disabling
authentication), with the same UID as the one on the host, and use
links to provide direct access on the jail.

```bash
[mxs@buffout:~/]% cd
[mxs@buffout:~/]% ln -sf /jails/www/usr/local/www/mxs www
[mxs@buffout:~/]% cd www && do stuff
```
