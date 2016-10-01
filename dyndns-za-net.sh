#!/bin/sh

# User-Agent: Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:32.0) Gecko/20100101 
Firefox/32.0
# Referer: http://www.dyndns.co.za/cgi-bin/gnudip.cgi

#  Currently Points to 83.233.106.212
# The computer that connected to GnuDIP has IP address 83.233.106.212
# GnuDIP cannot determine if 83.233.106.212 is the IP address of your
#    <td><input type=text name="updateaddr" 
value="83.233.106.212"></td>

woe-From-angepasst-2015-50-08-18.50.03
#!/bin/sh

# /etc/cron.hourly/1-from-anpassen-sh

sleep 10;

for n in  /var/spool/nullmailer/queue/ * ; do
 if [ -f $n ] ; then
  i=`basename $n`
  mv $n /tmp/nullmailer-$i; 
  perl -pne 's/root\@woe.woe/michalmolako\@wp.pl/' /tmp/nullmailer-$i > 
/tmp/n;
  date +woe-From-angepasst-%Y-%M-%d-%H.%M.%S >> /tmp/n
  cat $0 >> /tmp/n
  mv /tmp/n $n;
 fi;
done


exit 0

for n in  /var/spool/nullmailer/queue/ * ; do echo $n; if [ -f $n ] ; then echo 
$n ; fi; done
