#!/usr/bin/perl 

#Script to update modified files of FEWS estimated daily precip. for S. Asia
#Modified from script created by EKG to download CAMS-OPI v0208 files
#Feb. 20, 2005

#modified to use proxy server and not use net::ftp 5 Sep 2005

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;


#open (out, ">outputlog");

#chdir "/beluga/data/mbell/cpc/s_asia.d";
chdir "/Data/data6/noaa/cpc/fews/s_asia/RFEv2/daily" or die "Couldn't change local directory! (1)\n";
# script can be run from anywhere on nino

#my $host = 'ftpprd.ncep.noaa.gov';				#ftp host
my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host

#my @dirs = qw(/pub/cpc/fews/S.Asia/data/);               #array of directories
my @dirs = qw(/fews/S.Asia/data/);               #array of directories

foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)

 getdatafiles ("ftp://$host$directory",qr/(cpc_rfe_v2.0_sa_dly.bin.\d\d\d\d\d\d\d\d.gz$)/ );

}							#end directory foreach
	exit;


