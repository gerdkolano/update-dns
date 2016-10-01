#!/bin/sh

cd /data6/home/hanno/dynamische-adressen-ohne-make
if SOLL=`/usr/local/bin/wie-ist-meine-ip` ; then
  echo \"$SOLL\" \\t = \"liefert der Speedport\"
  while [ "x$SOLL" = x -o "x$SOLL" = "x0.0.0.0" ] ; do
    SOLL=`/usr/local/bin/wie-ist-meine-ip`;
    echo \"$SOLL\"
    sleep 20;
  done
else
  echo Speedport nicht erreichbar.
  exit 1
fi

./gerd.dyndns.za.net-schallehn.dyndns.za.net.sh $SOLL
./hanno.hopto.org-albrecht.hopto.org.sh $SOLL

exit 0
