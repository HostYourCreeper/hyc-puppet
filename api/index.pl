#!/usr/bin/perl

use strict;
use warnings;

print "Content-type:text/plain\n\n";

my $action;
my $server;
$ENV{'REQUEST_URI'} =~ /^\/([a-z]+)\/([a-z0-9\.]+)/;
($action,$server) = ($1,$2);

if($action eq "revoke") {
  print `sudo /usr/sbin/puppetca --revoke $server`;
} elsif($action eq "clean") {
  print `sudo /usr/sbin/puppetca --clean $server`;
} else {
  print "Bad action";
}
