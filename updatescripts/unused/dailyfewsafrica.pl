#!/usr/bin/perl

#Script to update modified files of FEWS estimated daily precip.
#Modified from script created by EKG to download CAMS-OPI v0208 files
#May 13, 2003

# modified 5 Sep 2005 to use proxy and not use Net::FTP

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;


#open (out, ">outputlog");

 chdir "/Data/data6/noaa/cpc/fews/prcpest/daily";
# script can be run from anywhere on nino

#my $host = 'ftpprd.ncep.noaa.gov';				#ftp host
my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host

#my @dirs = qw(/pub/cpc/fews/newalgo_est/);               #array of directories
my @dirs = qw(/fews/newalgo_est/);               #array of directories

foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)


 getdatafiles("ftp://$host$directory",qr/(all_products.bin.\d\d\d\d\d\d\d\d.gz$)/);

	}						#end directory foreach

exit;
