---
categories:
- code
- news
date: "2012-08-23T00:00:00Z"
title: backup files with hdup
---

## Introduction

This article details how backups work at [sbrk.org](http://sbrk.org)
this is a reminder but it may be helpful for anyone needing backups
with similar needs ; critics are welcomed.

## Requirements

The server has the following characteristics:

- no dedicated backup partition (too bad),
- a 100go ftp to store important backups, which is only accessible from the server,
- a hard drive of 2to, half of it can be used for backups, which is cool,
- several users are on the server.

I've splitted backups into two parts:

- SQL backups
- File backups

## SQL backups

I'm aware of two ways to backup MySQL databases:

- copying files from `/var/lib/mysql` but it requires to stop the server
  to ensure integrity (if mysql writes to these files during a backup, the
  backup may be corrupted),
- mysqldump, which is slower but ensures integrity and doesn't require
  to stop the server.

Here that's quite simple, a daily cron simple performs a mysqldump of
all databases, the result is stored in an archive. Archives older than
30 days can be removed.

A trick to easily handle old files is to name files with the
current number of the month, so there are automatically overwritten:

```bash
mysqldump --all-databases -uroot -ppassword | gzip > $(date +%m).tar.gz
```

We don't have huge databases so this works fine (with big databases
it's more efficient to have differencial backups, but I prefer to keep
things simple and easy, when the FTP will run out of space maybe I'll
consider a better solution).

These backups are stored on the 100go ftp which is only accessible
from the server itself, users are trusted, the ftp is trusted as much
as the server, and the access to the ftp is only known to root users,
so I don't consider encryption relevant.

## File backups

This is more tricky as many things have to be handled here: encryption
for user backups, monthly snapshots, incremental weekly and daily
backups. This imply the usage of a tool, I've chosen [hdup](http://www.miek.nl/projects/hdup/) as it's
simple to use.

Because of the 100go ftp backup and of the need of different
encryption policies, I've decided to split backups into three parts:

- A backup for files that are required to ensure the integrity of the
  server, basically `/etc/`, `/usr/`, `/boot/`, `/bin/`, `/lib/`,
  `/lib32/`, `/lib64/`, `/opt/`, `/root/`, `/sbin/`. This backup is
  quite small so it can be pushed on the ftp. No need for encryption
  because this backup won't leave the server (the ftp is only accessible
  from the server).

- A backup for everything that is not included in the previous backup,
  same here, no need for encryption as the backups will stay on the
  server (homes, www, mails, ...). I see this backup more as a bonus in
  case of the traditional "Whoopsie-daisy, I've deleted the wrong
  directory" than a way to recover from hardware crashes.

- A backup for each user, encrypted with the user's GPG key. This backup
  can leave the server (as it's encrypted), and contains everything the
  user wants. I have a cron that run on my laptop that rsync my backup
  directory from the server, so I can still recover my files if the server
  has a hardware crash.

To prevent non-root users to access backups that aren't encrypted we
have a nologin user "backup" whose home directory will store backups:

```bash
# useradd -d /home/srv/backup -s /usr/sbin/nologin backup
```

Currently the backups aren't stored on a separated partition, but if
you can, you clearly should do it (the backup partition is then only
mounted during the backup, so even a `rm -rf /` won't affect your
backups if there's no backup running).

## Configuration

Now the hdup configuration is quite straightforward, I've omitted some
parts:

```ini
[global]
# where to put the tar archives
archive dir = /home/srv/backup
date spec = iso
always backup = on
force = no
overwrite = on
proto = /usr/bin/ssh
proto option =  -q -oProtocol=2
user = backup
compression = lzop
compression level = 1
nobackup = .nobackup

# backup for files required to ensure the integrity of the server
[sbrk-global]
dir = /etc,/usr,/boot,/bin,/lib,/lib32,/lib64,/opt,/root,/sbin
exclude = lost\+found
user = backup

# backup for everything else
[sbrk-sensitive]
dir = /var,/home/srv,/home/users,/root
exclude = lost\+found
user = backup

# backup for user mxs
dir = # omitted, that's not public :-)
exclude = lost\+found/
algorithm = gpg
key = FDEFA783
user = mxs
```

Some important notes here, the user directive tells hdup to chown the
backup to the given user. The key and algorithm tell hdup to encrypt
the backup with gpg using the key whose identifier is FDEFA783 (this
can be seen with `gpg --list-keys`). Another note about hdup, every
folder that contains the file .nobackup won't be backed up, so it's a
good idea to create this file in your backup directory to avoid
backuping backups. Monthly snapshots take a lot of time an I don't
care much as I have free space so I use lzop (one of the fastest
compression algorithm around) with the minimal compression settings.

The last thing we need is a cron.

## Cron

To make it easy to administrate, I've written a daily cron that
handles everything (sql backup, monthly snapshot, weekly and daily
incremental backups, push to the ftp, deletion of old backups).

```bash
#!/usr/bin/env bash
# s. rannou <mxs@sbrk.org>
# a script to perform backups with hdup, manages daily/weekly/monthly backup
#
# - $HDUP contains entries that must be daily,weekly and monthly backed, see /etc/hdup/hdup.conf
# - $HDUP_FTP contains entries that must be backed on $FTP_HOST (which is only 100go in our case)
# - all sql databases are backed for 30 days and pushed on $FTP_HOST
#
# this script needs lftp, gzip, hdup, tar, mysqldump, gpg

# mysql access (mysqldump --all-databases is used)
SQL_LOGIN="root_sql_login"
SQL_PW="root_sql_password"

# ftp access
FTP_LOGIN="ftp_login"
FTP_PW="ftp_password"
FTP_HOST="ftp_host"

# hdup sections
HDUP=(sbrk-global sbrk-sensitive sbrk-mxs)
HDUP_FTP=(sbrk-global)

# common settings
BACKUP_DIR=/home/srv/backup
BACKUP_SQL_DIR=/home/srv/backup/sql

echo "--- $(date) backup started"

if [ ! -d $BACKUP_SQL_DIR ]; then
    mkdir -p $BACKUP_SQL_DIR
fi

if [ ! -f $BACKUP_DIR/.nobackup]; then
    touch $BACKUP_DIR/.nobackup
fi

# -- hdup
# monthly backup
for SECTION in ${HDUP[@]}; do
    # if we are the 1st of the month or if there isn't any monthly backup, start a monthly backup
    if [ $(echo "$(date +%d)" | bc) -eq 1 ] || [ $(find "${BACKUP_DIR}/${SECTION}" -name "*monthly.tar*" 2>/dev/null | wc -l) -eq 0 ]; then
	echo "--- $(date) started monthly backup for ${SECTION}"
	hdup -P monthly ${SECTION}
	echo "--- $(date) ended monthly backup for ${SECTION}"
    else
	echo "--- $(date) no monthly backup needed for ${SECTION}"
    fi
done
# weekly backup
for SECTION in ${HDUP[@]}; do
    # if we are the 1,8,15,22 or 29 of the month or if there isn't any weekly backup, start a weekly backup
    if [ $(echo "($(date +%d) + 6) % 7" | bc) -eq 0 ] || [ $(find "${BACKUP_DIR}/${SECTION}" -name "*weekly.tar*" 2>/dev/null | wc -l) -eq 0 ]; then
	echo "--- $(date) started weekly backup for ${SECTION}"
	hdup -P weekly ${SECTION}
	echo "--- $(date) ended weekly backup for ${SECTION}"
    else
	echo "--- $(date) no weekly backup needed for ${SECTION}"
    fi
done
# daily backup
for SECTION in ${HDUP[@]}; do
    echo "--- $(date) started daily backup for ${SECTION}"
    hdup -P daily ${SECTION}
    echo "--- $(date) ended daily backup for ${SECTION}"
done

# -- sql
echo "--- $(date) - backing up all sql databases"
# trick here, the backup is made for 28/29/30 or 31 days using the number of the day
# (1st december will result in /home/srv/backup/sql/backup-1.sql, and so on)
SQL_DEST="${BACKUP_SQL_DIR}/backup-`date +%d`.sql.tar.gz"
mysqldump --all-databases -u${SQL_LOGIN} -p${SQL_PW} | gzip > ${SQL_DEST}
chown backup:backup ${SQL_DEST}
echo "--- $(date) - sql done"

# -- some cleaning
echo "--- $(date) - mr proper started"

# - monthly snapshots older than 6 months
find ${BACKUP_DIR} -name "*monthly.tar*" -mtime +180 -exec rm {} \;
# - weekly snapshots older than 2 months
find ${BACKUP_DIR} -name "*weekly.tar*" -mtime +60 -exec rm {} \;
# - daily snapshots older than 2 weeks
find ${BACKUP_DIR} -name "*daily.tar*" -mtime +14 -exec rm {} \;

echo "--- $(date) - mr proper ended"

# -- ftp
# push a subset of backups on the ftp
# this is a 100go ftp, we only push sbrk-global (should be small) and sql for 30 days
echo "--- $(date) - ftp sql put started"
echo "mirror -e -R ${BACKUP_SQL_DIR} /sql" | lftp ftp://${FTP_LOGIN}:${FTP_PW}@${FTP_HOST}
echo "--- $(date) - ftp sql put ended"

for SECTION in ${HDUP_FTP[@]}; do
    BACKUP_SECTION_DIR=${BACKUP_DIR}/${SECTION}
    echo "--- $(date) - ftp ${SECTION} put started"
    echo "mirror -e -R ${BACKUP_SECTION_DIR} /${SECTION}" | lftp ftp://${FTP_LOGIN}:${FTP_PW}@${FTP_HOST}
    echo "--- $(date) - ftp ${SECTION} put ended"
done

echo "--- $(date) backup ended"
```

Be sure to understand it before using it, then to install it: 

```bash
$EDITOR backup.sh
mv backup.sh /etc/cron.daily
chmod 700 /etc/cron.daily/backup.sh
```

Et voilà!
