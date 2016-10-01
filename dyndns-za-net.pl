#!/usr/bin/perl

# /etc/cron.hourly/1-dyndns-za-net-pl
# root@fadi:~# touch /var/log/dyndns.za.net.hanno-1
# root@fadi:~# chown hanno: /var/log/dyndns.za.net.hanno-1
# root@fadi:~# touch /etc/dyndns.za.net.conf
# root@fadi:~# chown hanno: /etc/dyndns.za.net.conf
# touch /var/log/dyndns.za.net.hanno-1 /etc/dyndns.za.net.conf;  chown hanno: /var/log/dyndns.za.net.hanno-1 /etc/dyndns.za.net.conf
#

use strict;
use warnings;

my $debug;
my $force=shift;
if (defined $force && $force eq "-f") {
  $force="-f";
}

my $alte_ip_adresse;
open EIN, "< /etc/dyndns.za.net.conf";
while (<EIN>) {
  chop;
  $alte_ip_adresse = $_ if m/\d+\.\d+\.\d+\.\d+/;
  print "alte_ip_adresse=$alte_ip_adresse\n" if defined $alte_ip_adresse;
}
$alte_ip_adresse = "0.0.0.0" unless defined $alte_ip_adresse;
print "alte_ip_adresse=$alte_ip_adresse\n";
close EIN;

# exit 0;

#open EIN, "wget -qO-  'http://www.dyndns.co.za/cgi-bin/gnudip.cgi' 
#--post-data='page=login&localaddr=nojava&errormsg=&username=elin&domain=dyndns.za.net&password=`koerperteil elin`&login=Login' 
#|";

my $username="gerd";
my $pass=`/usr/local/bin/koerperteil gerd`;
my $wget;
my $poste="page=login&localaddr=nojava&errormsg=&username=$username&domain=dyndns.za.net&password=$pass&login=Login";
$wget = "wget -qO-  'http://www.dyndns.co.za/cgi-bin/gnudip.cgi' --post-data=\"$poste\" | tee /tmp/1.html";
$wget = "wget -qO-  'http://www.dyndns.co.za/cgi-bin/gnudip.cgi' --post-data=\"$poste\"";
print "$wget\n";

open EIN, "$wget |";

my $los=0;
$poste="";
my $neue_ip_adresse="";

while (<EIN>) { 
  if(m#(<form action="/cgi-bin/gnudip.cgi" method="post">)#g){$los=1};
  if(($los == 1) && m#name="(updateaddr)"\s*value="([^"]*)"#g){$los=0;$neue_ip_adresse="$2";$poste .= "$1=$2"};
  if(($los == 1) && m#name="([^"]*)"\s*value="([^"]*)"#g){$poste .= "$1=$2&"};
  if(($los == 1) && m#(</form>)#g){$los=0;$poste .= "$1"};
}
close EIN;

print "neue_ip_adresse=$neue_ip_adresse\n";
if (defined $debug) {print "poste=$poste\n"};

if (($neue_ip_adresse eq $alte_ip_adresse)) {
  print "Keine Änderung, ";
  if (defined $force) {
    print "dennoch";
  } else {
    print "kein";
  }
  print " Update.\n";
}

my $datum = "";

use POSIX qw(strftime);

$datum = strftime "%Y-%m-%d %H:%M:%S", localtime;
print "$datum\n";

  $wget = "wget -qO-  --post-data=\"$poste\" --referer=http://www.dyndns.co.za/cgi-bin/gnudip.cgi --user-agent='Mozilla/5.0' http://www.dyndns.co.za/cgi-bin/gnudip.cgi";
  print "$wget\n";
  
if (defined($force) || ($neue_ip_adresse ne $alte_ip_adresse)) {

  sleep 7;

  my $logdatei = "/var/log/dyndns.za.net.hanno-1";
  open AUS, ">> $logdatei" or die "Kann $logdatei nicht öffnen.";
  print AUS "$datum\n";
  open EIN, "$wget |";
  while (<EIN>) {
    if (m#(Update done)#) {print AUS;}
    if (m#(Currently Points)#) {print AUS;}
    if (m#(connected to GnuDIP )#) {print AUS;}
  }
  close EIN;
  close AUS;

  open AUS, ">> /etc/dyndns.za.net.conf";
  print AUS "$neue_ip_adresse\n";
  close AUS;
  system "echo $neue_ip_adresse | mailx -r michalmolako\@google.com' -s \"IP-Adresse $datum $neue_ip_adresse\" michalmolako\@wp.pl";
}
my $hostname="fadi";
my $kommando;
$kommando = "echo dyndns-za-net-pl meldet: $neue_ip_adresse | mailx -r 'michalmolako\@yahoo.com' -s \"host=$hostname ip=$neue_ip_adresse date=$datum \" michalmolako\@wp.pl";
print "$kommando\n";
system $kommando;

system "/etc/cron.hourly/1-from-anpassen-sh";

exit 0;

open EIN, "< $0";

while(<EIN>) {
   print "$_";
}
close EIN;

