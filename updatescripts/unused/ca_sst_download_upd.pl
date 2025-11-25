#!/usr/bin/env perl
# download script for ca_sst ensemble
# runs anywhere that has a good enough perl, e.g. iridlc3p
use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
$mydir = "/Data/data7/noaa/ncep/cpc/ca_sst/updates";
if (! -e $mydir){
    mkdir $mydir,0777;
}
chdir "$mydir";
getdatafiles ("ftp://ftp.cpc.ncep.noaa.gov/wd51hd/sst/",qr/^casst_ens_...\d\d\d\d$/);

