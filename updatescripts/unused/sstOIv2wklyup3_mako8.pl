#! /usr/bin/perl -w
#
# new script to update weekly Reynolds and Smith OIv2 dataset without modifying associated index.tex file
#  9 Dec 2013
#

$local="/Data/data3/ocean/nmc/RSOIver2/weekly";
$gnudate="/bin/date";

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

@datelist = ();
@newfiles = ();

chdir "$local" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

#@newfiles = getdatafiles("ftp://ftp.emc.ncep.noaa.gov/cmb/sst/oisst_v2/",qr/oisst\.\d\d\d\d\d\d\d\d.gz$/);
@newfiles = getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/precip/PORT/sst/oisst_v2/",qr/oisst\.\d\d\d\d\d\d\d\d.gz$/);

if(@newfiles) {
  print "Weekly SST update -- Reynolds and Smith OI v.2\n";
  print "Found new files at the CPC.\n";

  foreach $fil (@newfiles) {
    print "$fil\n";
    system("gzip $fil");
  }

} else {
  print "Weekly SST update -- Reynolds and Smith OI v.2\n";
  print "Did not find new files at the CPC.  Try again later.\n";
}

exit;

