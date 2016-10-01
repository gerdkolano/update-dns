#!/bin/sh
# update-dns.sh 

grabe() {
 ERG=`dig +short $2` ;
 echo -n \"$ERG\" \\t = \"$2\"  \\t = \"$1\" 
 if [ $ERG = $1 ] ; then
	 echo " gleich"
 else
	 echo " ungleich"
	 echo noip2 -i $1 -c $3
	 touch         /var/log/no-ip-success.log
	 chown nobody: /var/log/no-ip-success.log
	 noip2 -i $1 -c $3
 fi
}

if [ $# -lt 1 ] ; then
	echo ip wie 79.195.189.60 fehlt
	exit 1
fi

SOLL=$1 ; shift

echo \"$SOLL\" \\t = \"geliefert von speedport.ip\"

if [ $# -lt 1 ] ; then
  grabe $SOLL albrecht.hopto.org     /usr/local/etc/no-ip2-uhren.conf
  grabe $SOLL hanno.hopto.org        /usr/local/etc/no-ip2-hanno.conf
else
	case $1 in
	       	albrecht.hopto.org) grabe $SOLL $1     /usr/local/etc/no-ip2-uhren.conf ;;
	       	hanno.hopto.org)    grabe $SOLL $1     /usr/local/etc/no-ip2-hanno.conf ;;
	esac
fi
