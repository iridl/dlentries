#! /usr/bin/perl -w
# ------------------
# Updates monthly global GODAS data from CPC using getdatafiles
# ------------------

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

$finaldir="/Data/data5/noaa/nmc/leetma/godas/monthly";

@newfiles = ();

$curmon = `date +%m`;
$curyr = `date +%Y`;
chomp $curmon;
chomp $curyr;

$monprevmon = `date -d "1 month ago" +%m`;
$yrprevmon = `date -d "1 month ago" +%Y`;
chomp $monprevmon;
chomp $yrprevmon;

$lastmon = "$yrprevmon" . "$monprevmon";
chomp $lastmon;

print "$lastmon\n";

if (chdir($finaldir)) {
system("wget -N -r -l1 -e robots=off --no-parent -nd https://ftp.cpc.ncep.noaa.gov/godas/monthly/godas.M.$lastmon.grb");
}
else
{
 print "Unable to change directory.  Stopped monthly GODAS update script\n";
}

exit;
