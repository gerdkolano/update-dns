#!/usr/bin/perl

# /etc/cron.hourly/1-dyndns-za-net-pl 

use strict;
use warnings;

my $debug;
my $force=shift;
if (defined $force && $force eq "-f") {
  $force="-f";
}

my $MESSAGE="Mit mailx von zoe.xeo an michalmolako\@wp.pl gesendet."
  . "\\n"
  . "§ 1631 Kinder haben ein Recht auf gewaltfreie Erziehung. "
  . "Körperliche Bestrafungen, seelische Verletzungen und "
  . "andere entwürdigende Maßnahmen sind unzulässig."
  . "\\n"
  . "§ 1619 Das Kind ist, solange es dem elterlichen Hausstand angehört und "
  . "von den Eltern erzogen oder unterhalten wird,"
  . "verpflichtet, in einer seinen Kräften und "
  . "seiner Lebensstellung entsprechenden Weise "
  . "den Eltern in ihrem Hauswesen und Geschäft Dienste zu leisten. "
        ;
my $alte_ip_adresse;
open EIN, "< /etc/dyndns.za.net.conf";
while (<EIN>) {
  chop;
  $alte_ip_adresse = $_;
}
print "alte_ip_adresse=$alte_ip_adresse\n";
close EIN;

# exit 0;
my $user = "elin";
$user = "gerd";
$user = "matte";
my $teil;
#$teil = `koerperteil elin`;
#$teil = `koerperteil gerd`;
$teil = `koerperteil matte`;
# print "$teil\n";

open EIN, "wget -qO- 'http://www.dyndns.co.za/cgi-bin/gnudip.cgi' --post-data='page=login&localaddr=nojava&errormsg=&username=$user&domain=dyndns.za.net&password=$teil&login=Login' | tee /tmp/1.html |";

my $los=0;
my $poste="";
my $neue_ip_adresse="";

while (<EIN>) { 
  if(m#(<form action="/cgi-bin/gnudip.cgi" method="post">)#g){$los=1};
  if(($los == 1) && m#name="(updateaddr)"\s*value="([^"]*)"#g){$los=0;
          $neue_ip_adresse="$2";
          $poste .= "$1=$2"};
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

if (defined($force) || ($neue_ip_adresse ne $alte_ip_adresse)) { 

  my $wget = "wget -O-  --post-data=\"$poste\" --referer=http://www.dyndns.co.za/cgi-bin/gnudip.cgi --user-agent='Mozilla/5.0' http://www.dyndns.co.za/cgi-bin/gnudip.cgi";
  print "A071 $wget\n";
  
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
  #system "echo -n $neue_ip_adresse $MESSAGE | mailx -a 'From: <michalmolako\@googlemail.com>' -s \"IP-Adresse $datum $neue_ip_adresse\" michalmolako\@wp.pl";
}
my $hostname="woe";
$hostname = `hostname`;
#system "echo -n /usr/local/bin/dyndns-za-net-ohne-speedport.pl meldet: $neue_ip_adresse $MESSAGE | mailx -a 'From: <michalmolako\@googlemail.com>' -s \"host=$hostname ip=$neue_ip_adresse date=$datum \" michalmolako\@wp.pl";

exit 0;
