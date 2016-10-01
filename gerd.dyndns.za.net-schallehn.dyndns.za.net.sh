#!/bin/sh
# update-dns.sh 

grabe() {
 ERG=`dig +short $2` ;
 echo -n   \"$ERG\" \\t = \"$2\"  \\t = \"$1\" 
 logger -i \"$ERG\"     = \"$2\"      = \"$1\" 
 if [ "x$ERG" = "x$1" ] ; then
	 echo " gleich"
 else
	 echo " ungleich"
	 ./update-gerd-socat.sh
	 ./update-schallehn-socat.sh
 fi
}

if [ $# -lt 1 ] ; then
	echo ip wie 79.195.189.60 fehlt
	exit 1
fi

SOLL=$1 ; shift

echo \"$SOLL\" \\t = \"geliefert von speedport.ip\"

grabe "$SOLL" gerd.dyndns.za.net
