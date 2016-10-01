#!/bin/bash

GEHEIM=`/usr/local/bin/koerper muralis`
VERZEICHNIS="local"
VERZEICHNIS="hanno"

cat << ENDE | ncftpput -c -u web284 -p $GEHEIM www.muralis.de /$VERZEICHNIS/zeige-die-ip-adresse-des-anrufers.php
<?php
\$ziel = \$_SERVER['REMOTE_ADDR'];
printf( "%s\\n", \$ziel);
?>
ENDE
wget -qO- http://$VERZEICHNIS.muralis.de/zeige-die-ip-adresse-des-anrufers.php

exit 0

ncftpput -u web284 -p $GEHEIM www.muralis.de /local einzelheiten.php
wget -qO- http://local.muralis.de/einzelheiten.php > index.html
ncftpput -u web284 -p $GEHEIM www.muralis.de /local index.html

exit 0

