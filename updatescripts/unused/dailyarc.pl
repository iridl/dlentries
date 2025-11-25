#!/usr/bin/perl 

#Script to update modified files of FEWS estimated daily precip.
#Modified from script created by EKG to download CAMS-OPI v0208 files
#May 13, 2003
#modified to use proxy server and not use net::ftp        5 Sep 2005

#Archived daily ARC data at CPC (from 01/07/1995 to 2006) are found
#here:  ftp.cpc.ncep.noaa.gov/fews/ARC  (MAB, May 22, 2007)

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;


#open (out, ">outputlog");

#chdir "/beluga/data/mbell/cpc/arc_data/daily_data";
 chdir "/Data/data6/noaa/cpc/fews/arc_data/daily_data";
# script can be run from anywhere on nino

#my $host = 'ftpprd.ncep.noaa.gov';				#ftp host
my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host

#my @dirs = qw(/pub/cpc/fews/AFR_CLIM/DATA/);               #array of directories
my @dirs = qw(/fews/AFR_CLIM/DATA/);               #array of directories

foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)

    getdatafiles("ftp://$host$directory",qr/(all_products.CLIM.bin.\d\d\d\d\d\d\d\d.gz$)/);
}							#end directory foreach

	exit;
