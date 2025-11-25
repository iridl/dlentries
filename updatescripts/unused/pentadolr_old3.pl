#!/usr/bin/perl -w

#Script to update pentad olr values. 
#June 7, 2005

  chdir "/Data/data8/noaa/cpc/olr";
# script can be run from anywhere on nino

my $ldir = '/Data/data8/noaa/cpc/olr/';  #base directory for olr 
my $host = 'nomad3.ncep.noaa.gov';				#ftp host
my @dirs = qw(pub/cpc/olr/pentad/);               #array of directories

$ENV{"http_proxy"}="http://iriproxy:3128";

  system("cd $ldir;/usr/freeware/bin/wget -A 'pent.olr.y2???' -N -r -l1 -e robots=off --no-parent -nd http://nomad3.ncep.noaa.gov/pub/cpc/olr/pentad/");

  system("make olr");

  system("cd $ldir;/usr/freeware/bin/wget -A 'pent.olra.y2???' -N -r -l1 -e robots=off --no-parent -nd http://nomad3.ncep.noaa.gov/pub/cpc/olr/pentad/");

  system("make olra");

exit;
