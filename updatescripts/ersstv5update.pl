#!/usr/bin/perl -w

#Script to update ERSSTv4 extended reconstructed SST data.
#Modified from script created by EKG to download CAMS-OPI v0208 files
#Mar 23, 2017

#modified to use proxy server and not use net::ftp

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

chdir "/Data/data6/noaa/ncdc/ersstv5" or die "Couldn't change local directory!\n";
getdatafiles("ftp://ftp.ncdc.noaa.gov/pub/data/cmb/ersst/v5/netcdf/", qr/(ersst.v5.\d\d\d\d\d\d.nc$)/);

