#!/usr/bin/perl -w
use strict;

my $arg="";
while (<>) {
  if (1..m#</form>#) {
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(page)"\svalue="([^"]*).*#g;
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(username)"\s*value="([^"]*).*#g;
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(domain)"\s*value="([^"]*).*#g;
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(password)"\s*value="([^"]*).*#g;
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(logonid)"\s*value="([^"]*).*#g;
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(pagetime)"\s*value="([^"]*).*#g;
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(checkval)"\s*value="([^"]*).*#g;
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(localaddr)"\s*value="([^"]*).*#g;
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(errormsg)"\s*value="([^"]*).*#g;
     $arg .= sprintf "%s=%s&", $1, $2 if m#name="(updatehost)"\s*value="([^"]*).*#g;
     $arg .= sprintf "%s=%s",  $1, $2 if m#name="(updateaddr)"\s*value="([^"]*).*#g;
  }
}
printf "%s %s\n",  "POST", "http://dyndns.za.net/cgi-bin/gnudip.cgi HTTP/1.1";
printf "%s: %s\n", "Host", "dyndns.za.net";
printf "%s: %s\n", "User-Agent", "Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.8) Gecko/20100214 Ubuntu/9.10 (karmic) Firefox/3.5.8";
printf "%s: %s\n", "Accept", "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8";
printf "%s: %s\n", "Accept-Language", "de-de,de;q=0.8,en-us;q=0.5,en;q=0.3";
printf "%s: %s\n", "Accept-Encoding", "gzip,deflate";
printf "%s: %s\n", "Accept-Charset", "ISO-8859-1,utf-8;q=0.7,*;q=0.7";
printf "%s: %s\n", "Keep-Alive", "300";
printf "%s: %s\n", "Proxy-Connection", "keep-alive";
printf "%s: %s\n", "Referer", "http://dyndns.za.net/cgi-bin/gnudip.cgi";
printf "%s: %s\n", "Content-Type", "application/x-www-form-urlencoded";
printf "%s: %d\n", "Content-Length", length $arg;
printf "\n";
printf "%s\n", $arg;
# </form>
