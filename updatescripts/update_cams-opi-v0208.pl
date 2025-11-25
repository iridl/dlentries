#!/usr/bin/perl
#Script updates modified CAMS OPI v0208 data files
#EKG 16 Oct 2002
# modified 5 Sep 2005 to use proxy and not use Net::FTP
# modified 13 Sep 2005 to use function from getdatafile

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#open (out, ">outputlog");

chdir "/Data/data5/noaa/cpc/CAMS-OPI-v0208" or die "Couldn't chdir to output directory\n";

#my $host = 'ftpprd.ncep.noaa.gov';				#ftp host
my $host = 'ftp.cpc.ncep.noaa.gov';				#ftp host

#my @dirs = qw(/pub/precip/data-req/cams_opi_v0208/);
my @dirs = qw(/precip/data-req/cams_opi_v0208/);

foreach $directory (@dirs) {				#only one directory of interest, but using old script template (if it ain't broke, don't fix it)

getdatafiles ("ftp://$host$directory",qr/$/ );

}							#end directory foreach

system ("./update_gauge_input");			#start Benno's update script that will handle guage file
