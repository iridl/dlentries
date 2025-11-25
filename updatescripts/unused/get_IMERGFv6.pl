#!/usr/bin/perl -w

#Script to download ~3 month delayed daily IMERG F v6 data.
#Modified from script get_TARCATv3p0.pl
#Dec. 2020

#require "/home/datag/perl/getdatafiles.pl";
#require "ctime.pl";
#

# /Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDF.06
#
# https://gpm1.gesdisc.eosdis.nasa.gov/data/GPM_L3/GPM_3IMERGDF.06

my $lcldir = '/Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDF.06/';
my $host = 'gpm1.gesdisc.eosdis.nasa.gov';				#http host
my $remotedir = qw(/data/GPM_L3/GPM_3IMERGDF.06/);               #array of directories
@datelist = ();
@newfiles = ();

# assign a two-digit month number for 4 months ago
$monago = `date -d "4 month ago" +%m`;
$monagob = `date -d "4 month ago" +%b`;
$yrago =  `date -d "4 month ago" +%Y`;
chomp $monago;
chomp $monagob;
chomp $yrago;

 print "$yrago $monago\n";

 $remcurmondir = "$yrago" . "/" . "$monago" . "/";
 chomp $remcurmondir;

# 3B-DAY.MS.MRG.3IMERG.%Y%m%d[T]-S000000-E235959.V06.nc4

$checkdiryear = "/Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDF.06/$yrago";
chomp $checkdiryear;

if(-d $checkdiryear){
   print "have $checkdiryear already\n";
}
else {
   print $checkdiryear;
   mkdir($checkdiryear) or die "Couldn't make yearly directory! (1)\n";
}

 $checkdirmon = "/Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDF.06/$yrago/$monago";
 chomp $checkdirmon;

 if(-d $checkdirmon){
    print "have $checkdirmon already\n";
 }
 else {
    print $checkdirmon;
    mkdir($checkdirmon) or die "Couldn't make monthly directory! (1)\n";
 }

   chdir($checkdirmon) or die "Couldn't change local directory! (1)\n";

   $whatdir = `pwd`;
   print "$whatdir\n";

#  get daily files
   my $status = system ("wget -L --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies -r -N -nH -nd -np -A nc4 https://$host$remotedir$remcurmondir");
   $status == 0 or print "wget failed with status $status\n";

exit;
