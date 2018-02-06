#!/bin/bash

WORK=/tmp
DEST=/tmp/blupdate
BLISTS=/etc/dansguardian/lists/blacklists/
CP=/bin/cp
RM=/bin/rm
MKDIR=/bin/mkdir
CAT=/bin/cat
TAR=/bin/tar
RSYNC=/usr/bin/rsync
WGET=/usr/bin/wget
ECHO=/bin/echo

$RSYNC -arq rsync://ftp.ut-capitole.fr/blacklist/dest/phishing /etc/dansguardian/lists/blacklists/
$RSYNC -arq rsync://ftp.ut-capitole.fr/blacklist/dest/malware /etc/dansguardian/lists/blacklists/
$RSYNC -arq rsync://ftp.ut-capitole.fr/blacklist/dest/marketingware /etc/dansguardian/lists/blacklists/

cd $WORK
$MKDIR -p $DEST

$CAT <<-EOF | $WGET -q -i -
    http://squidguard.mesd.k12.or.us/blacklists.tgz
    http://www.shallalist.de/Downloads/shallalist.tar.gz
EOF
#    ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/phishing.tar.gz
#    ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/malware.tar.gz
#    ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/marketingware.tar.gz

#$CAT <<-EOF | while read WORKFILE; do $TAR -C $DEST -xf $WORK/$WORKFILE; done;
#    phishing.tar.gz
#    malware.tar.gz
#    marketingware.tar.gz
#EOF

WORKFILE=blacklists.tgz
BLDIR=blacklists
CATEGORIES=`$CAT <<-EOF | while read CATEGORY; do $ECHO -n "./$BLDIR/$CATEGORY "; done;
    spyware
    suspect
EOF`
$TAR -C $DEST -xf $WORK/$WORKFILE --xform "s/\.\/$BLDIR\///" $CATEGORIES

WORKFILE=shallalist.tar.gz
BLDIR=BL
CATEGORIES=`$CAT <<-EOF | while read CATEGORY; do $ECHO -n "$BLDIR/$CATEGORY "; done;
    adv
    costtraps
    drugs
    hacking
    tracker
    warez
EOF`
$TAR -C $DEST -xf $WORK/$WORKFILE --xform "s/$BLDIR\///" $CATEGORIES

$RSYNC -arq $DEST/ $BLISTS

$CAT <<-EOF | while read WORKFILE; do $RM -rf $WORKFILE; done;
    blacklists.tgz
    shallalist.tar.gz
    $DEST
EOF
#    phishing.tar.gz
#    malware.tar.gz
#    marketingware.tar.gz

/etc/init.d/dansguardian reload >&/dev/null

exit 0
