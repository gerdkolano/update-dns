#!/bin/sh

DIR=`dirname $0`
USERNAME=schallehn
NUN=/tmp/$USERNAME.dyndns.za.net-`date +%Y-%m-%d-%H.%M.%S`
TEIL=`/usr/local/bin/koerperteil`
POSTDATA="page=login&localaddr=nojava&errormsg=&username=$USERNAME&domain=dyndns.za.net&password=$TEIL&login=Login"
LENGTH=`echo -n $POSTDATA | wc -c`

(
socat -t8 - TCP4:dyndns.za.net:80 <<EOF
POST http://dyndns.za.net/cgi-bin/gnudip.cgi HTTP/1.1
Host: dyndns.za.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.8) Gecko/20100214 Ubuntu/9.10 (karmic) Firefox/3.5.8
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: de-de,de;q=0.8,en-us;q=0.5,en;q=0.3
Accept-Encoding: gzip,deflate
Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7
Keep-Alive: 300
Proxy-Connection: keep-alive
Referer: http://dyndns.za.net/cgi-bin/gnudip.cgi
Content-Type: application/x-www-form-urlencoded
Content-Length: $LENGTH

$POSTDATA
EOF
) \
| tee $NUN-1-antwort.gz \
| perl -e 'while (<>) {print unless 1../^\r*$/}' \
| gunzip \
| tee $NUN-2-antwort.html \
| $DIR/dyndns.za.net-anal.pl \
| tee $NUN-3-frage.html \
| socat -t8 - TCP4:dyndns.za.net:80 \
| tee $NUN-4-antwort.gz \
| perl -e 'while (<>) {print unless 1../^\r*$/} ' \
| gunzip \
> $NUN-5-antwort.html

