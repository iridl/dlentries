#!/usr/bin/perl -w

#Script to download previous day daily IMERG L v6 data.
#And to account for potential mishaps, checks on all days of current and past months
#Modified from script get_IMERGLv6.pl
#Dec. 2020

#require "/home/datag/perl/getdatafiles.pl";
#require "ctime.pl";
#

# /Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDL.06
#
# https://gpm1.gesdisc.eosdis.nasa.gov/data/GPM_L3/GPM_3IMERGDL.06

my $lcldir = '/Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDL.06/';
my $host = 'gpm1.gesdisc.eosdis.nasa.gov';				#http host
my $remotedir = qw(/data/GPM_L3/GPM_3IMERGDL.06/);               #array of directories
@datelist = ();
@newfiles = ();

# Get current and previous months
$agomon = `date -d "1 month ago" +%m`;
$agomonb = `date -d "1 month ago" +%b`;
$agoyr =  `date -d "1 month ago" +%Y`;
$curmon = `date +%m`;
$curmonb = `date +%b`;
$curyr =  `date +%Y`;
chomp $agomon;
chomp $agomonb;
chomp $agoyr;
chomp $curmon;
chomp $curmonb;
chomp $curyr;

 print "$curyr $curmon\n";

 $remagomondir = "$agoyr" . "/" . "$agomon" . "/";
 chomp $remagomondir;
 $remcurmondir = "$curyr" . "/" . "$curmon" . "/";
 chomp $remcurmondir;

# 3B-DAY-L.MS.MRG.3IMERG.%Y%m%d[T]-S000000-E235959.V06.nc4

#Process current month

$checkdiryear = "/Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDL.06/$curyr";
chomp $checkdiryear;

if(-d $checkdiryear){
   print "have $checkdiryear already\n";
}
else {
   print $checkdiryear;
   mkdir($checkdiryear) or die "Couldn't make yearly directory! (1)\n";
}

 $checkdirmon = "/Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDL.06/$curyr/$curmon";
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

#  get daily files. there is only 1 new one every day but I wget the whole month so that I might catch up files that got delayed
   my $status = system ("wget -L --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies -r -N -nH -nd -np -A nc4 https://$host$remotedir$remcurmondir");
   $status == 0 or print "wget failed with status $status\n";

   #Process past month

   $checkdiryear = "/Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDL.06/$agoyr";
   chomp $checkdiryear;

   if(-d $checkdiryear){
      print "have $checkdiryear already\n";
   }
   else {
      print $checkdiryear;
      mkdir($checkdiryear) or die "Couldn't make yearly directory! (1)\n";
   }

    $checkdirmon = "/Data/data23/NASA/GES_DISC/GPM_L3/GPM_3IMERGDL.06/$agoyr/$agomon";
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

   #  get daily files. there is only 1 new one every day but I wget the whole month so that I might catch up files that got delayed
      my $status = system ("wget -L --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies -r -N -nH -nd -np -A nc4 https://$host$remotedir$remagomondir");
      $status == 0 or print "wget failed with status $status\n";

exit;
