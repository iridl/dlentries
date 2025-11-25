#!/usr/bin/perl -w

#Script to update ERSSTv4 extended reconstructed SST data.
#Modified from script created by EKG to download CAMS-OPI v0208 files
#Mar 23, 2017

#modified to use proxy server and not use net::ftp

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;

#open (out, ">outputlog");

 chdir "/Data/data6/noaa/ncdc/ersstv4" or die "Couldn't change local directory!\n";
# script can be run from anywhere on nino

my $host = 'ftp.ncdc.noaa.gov';				#ftp host

my @dirs = qw(/pub/data/cmb/ersst/v4/netcdf/);               #array of directories

foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)

  getdatafiles("ftp://$host$directory",qr/(ersst.v4.\d\d\d\d\d\d.nc$)/);

}  #end directory foreach

	exit;

