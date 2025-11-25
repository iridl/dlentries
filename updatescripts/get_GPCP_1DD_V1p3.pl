#!/usr/bin/perl -w
#
#Script to download NASA GPCP 1DD V1.3 global daily precipitation estimates 
# Feb 19 2020

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

chdir "/Data/data7/nasa/gpcp/1DD/v1p3" or die "Couldn't change directory\n";

# https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-daily/access/2019/gpcp_v01r03_daily_d20190101_c20190407.nc

@newfiles = ();
# @newfilestest = ();

# assign a two-digit month number for current month in which script is run to $curmon

$curmon = `date +%m`;
$curyr = `date +%Y`;
chomp $curmon;
chomp $curyr;

$monprevmon = `date -d "3 month ago" +%m`;
$yrprevmon = `date -d "3 month ago" +%Y`;
chomp $monprevmon;
chomp $yrprevmon;

print "$monprevmon\n";
print "$yrprevmon\n";

$yrmonprevmon = "$yrprevmon" . "$monprevmon";
chomp $yrmonprevmon;

%ndays = qw(01 31 02 28 03 31 04 30 05 31 06 30 07 31 08 31 09 30 10 31 11 30 12 31);
$nday = $ndays{$monprevmon};
chomp $nday;

$mydir = "/Data/data7/nasa/gpcp/1DD/v1p3/" . "$yrprevmon";
chomp $mydir;

print "$mydir\n";

$checkdir = $mydir;
chomp $checkdir;

if(-d $checkdir){
    print "have $checkdir already\n";
}
else {
    print $mydir;
    mkdir($mydir);
}

$ct = 0;
if(-d $checkdir){
  chdir($mydir) or die "Couldn't change local directory! (1)\n";

# check to see if you have the latest month's files already
  $lclct = 0;
  foreach $localfile (<gpcp_v01r03_daily_d*.nc>){
    if($localfile =~ /gpcp_v01r03_daily_d$yrmonprevmon\d\d_c\d\d\d\d\d\d\d\d.nc/) {
      print "$localfile\n";
      ++$lclct;
    }
  }

# if you have all the latest month's files already, end the update script before you try to download
  if($lclct >= $nday) {
    print "Already have all the latest files. Stopping update script.\n";
    exit;
  }

# $testfilstem = "$yrmonprevmon" . "01_c";
# chomp $testfilstem;

## https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-daily/access/2019/gpcp_v01r03_daily_d20190101_c20190407.nc
# @newfilestest = getdatafiles("https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-daily/access/$yrprevmon/",qr/gpcp_v01r03_daily_d$testfilstem\d\d\d\d\d\d\d\d.nc*/);

# if(@newfilestest) {
#   foreach $fil (@newfilestest) {
#     if($fil =~ /gpcp_v01r03_daily_d*.nc/) {
#       $ct = 1;
#     }
#   }
# }    

# if($ct == 1) {
#   print "File for the first day of $monprevmon is available.  Continue downloading.\n";
#
    @newfiles = getdatafiles("https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-daily/access/$yrprevmon/",qr/gpcp_v01r03_daily_d$yrmonprevmon\d\d_c\d\d\d\d\d\d\d\d.nc*/);
    print "downloaded $#newfiles\n";

# } else { 
#   print "No files available for download; stop trying for now\n";
# }

}

exit;

