#!/usr/bin/perl 

#Script to update monthly OLR.
#Modified from script created by EKG to download CAMS-OPI v0208 files
#May 13, 2003
#modified to use proxy server and not use net::ftp        5 Sep 2005


use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;


#open (out, ">outputlog");

 chdir "/Data/data5/noaa/cpc/olr" or die "Couldn't change local directory \n";
# script can be run from anywhere on geo1/mon1

#my $host = 'ftpprd.ncep.noaa.gov';				#ftp host
my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host

#my @dirs = qw(/pub/precip/data-req/olr/);               #array of directories
my @dirs = qw(/precip/data-req/olr/);               #array of directories

foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)

    getdatafiles("ftp://$host$directory",qr/(olrmonth.bin$)/);
}							#end directory foreach

	exit;
