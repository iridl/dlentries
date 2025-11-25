#!/usr/bin/perl -w

#Script to update pentad olr values. 
#June 7, 2005
#modified to use proxy server rather than net::ftp or wget

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

  chdir "/Data/data8/noaa/cpc/olr";
# script can be run from anywhere on nino

my $ldir = '/Data/data8/noaa/cpc/olr/';  #base directory for olr 
my $host = 'nomad1.ncep.noaa.gov';				#ftp host
my @dirs = qw(/pub/cpc/olr/pentad/);               #array of directories

foreach $directory (@dirs) {

  getdatafiles("http://$host$directory",qr/(pent.olra?.y2\d\d\d$)/);

# getdatafiles("ftp://$host$directory",qr/(pent.olra?.y2\d\d\d$)/);

  system("make olr");

  system("make olra");
}

exit;

