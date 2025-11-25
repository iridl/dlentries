#!/usr/bin/perl

#Script to update modified files of FEWS estimated daily precip.
#Modified from script created by EKG to download CAMS-OPI v0208 files
#May 13, 2003

#modified to use proxy server and not use net::ftp

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;

#open (out, ">outputlog");

 chdir "/Data/data6/noaa/cpc/cmorph/daily" or die "Couldn't change local directory! (1)\n";
# script can be run from anywhere on nino

#my $host = 'ftpprd.ncep.noaa.gov';				#ftp host
my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host

#my @dirs = qw(/pub/precip/global_CMORPH/daily_025deg/);               #array of directories
my @dirs = qw(/precip/global_CMORPH/daily_025deg/);               #array of directories

foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)

# getdatafiles("ftp://$host$directory",qr/(\d\d\d\d\d\d\d\d_dly\-025deg_cpc\+comb.Z$)/);

  getdatafiles("ftp://$host$directory",qr/(CMORPH\+MWCOMB_DAILY\-025DEG_\d\d\d\d\d\d\d\d.Z$)/);

}  #end directory foreach

	exit;

