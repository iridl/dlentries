#!/usr/bin/perl -w

#Script to update TOMS OMI aerosol index values. 
#Modified from script created by EKG to download CAMS-OPI v0208 files
#July 6, 2006

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#use File::Listing;

#open (out, ">outputlog");

chdir "/Data/data6/nasa/gsfc/toms/version8/omi/aerosol";

my $host = 'jwocky.gsfc.nasa.gov';				#ftp host

#Need to add to the @dirs array at the beginning of each year -- new annual
#directories will be added at the GSFC ftp site: "Y2006", etc.

($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

$year += 1900;

@dirs = ();
$yr = 2004;

while ($yr <= $year ) {
  $newdir = "/pub/omi/data/aerosol/Y$yr/";
  push(@dirs,$newdir);
  ++$yr;
}

foreach $directory (@dirs) {		

 getdatafiles("ftp://$host$directory",qr/L3_aersl_omi_\d\d\d\d\d\d\d\d.txt$/);

        }                                               #end directory foreach

exit;
