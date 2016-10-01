#!/bin/bash

GEHEIM=`/usr/local/bin/koerper muralis`
VERZEICHNIS="local"
VERZEICHNIS="hanno"

cat << ENDE | ncftpput -c -u web284 -p $GEHEIM www.muralis.de /$VERZEICHNIS/einzelheiten.php
<?php
\$ziel = 'http://' . \$_SERVER['REMOTE_ADDR'];
printf( "<meta http-equiv=\"refresh\" content=\"5; URL=%s/\" />", \$ziel);
printf( "<a href='%s'>%s</a><br />", \$ziel, \$ziel);
?>
ENDE
wget -qO- http://$VERZEICHNIS.muralis.de/einzelheiten.php | ncftpput -c -u web284 -p $GEHEIM www.muralis.de /$VERZEICHNIS/index.html

exit 0

ncftpput -u web284 -p $GEHEIM www.muralis.de /local einzelheiten.php
wget -qO- http://local.muralis.de/einzelheiten.php > index.html
ncftpput -u web284 -p $GEHEIM www.muralis.de /local index.html

exit 0

