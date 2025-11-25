#!/usr/bin/perl -w

#Script to download real-time dekadal TAMSAT TARCAT v2.0 data. Daily v2.0 is no longer updated. 
#Modified from script created to download MONTHLY CDAS
#Feb. 12, 2019

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#

# /Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v2p0
#
# http/www.tamsat.org.uk/public_data/2019/02

my $lcldir = '/Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v2p0/'; 
my $host = 'www.tamsat.org.uk';				#http host
my $remotedir = qw(/public_data/);               #array of directories
@datelist = ();
@newfiles = ();

# assign a two-digit month number for current month in which script is run to $curmon
#$curmon = "07";
$curday = `date +%d`;
$curmon = `date +%m`;
$curmonb = `date +%b`;
$curyr =  `date +%Y`;
chomp $curday;
chomp $curmon;
chomp $curmonb;
chomp $curyr;

for($dy = -30; $dy <=0; $dy++) {
# begin a loop that starts with -30 and goes to zero. As this loops, assign each day to $dy 

 $loopyr = `date -d "$curday $curmonb $curyr + $dy days" +%Y`;
 $loopmon = `date -d "$curday $curmonb $curyr + $dy days" +%m`;
 $loopday = `date -d "$curday $curmonb $curyr + $dy days" +%d`;
 chomp $loopyr;
 chomp $loopmon;
 chomp $loopday;

 print "$loopyr $loopmon\n";

 $remcurmondir = "$loopyr" . "/" . "$loopmon" . "/";
 chomp $remcurmondir;

# rfe2019_01-dk1.nc

 $checkdir = "/Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v2p0/$loopyr/$loopmon";
 chomp $checkdir;

 if(-d $checkdir){
    print "have $checkdir already\n";
 }
 else {
    print $checkdir;
    mkdir($checkdir);
 }

 if(-d $checkdir){
   chdir($checkdir) or die "Couldn't change local directory! (1)\n";

   $whatdir = `pwd`;
   print "$whatdir\n";

#  get dekadal files
   if($loopday == 10) {
     $filnamdek1 = "rfe" . "$loopyr" . "_" . "$loopmon" . "-dk1.nc"; 
     chomp $filnamdek1;
     system ("wget -N -r -l1 -e robots=off --no-parent -nd http://$host$remotedir$remcurmondir$filnamdek1");
   }
   if($loopday == 20) {
     $filnamdek2 = "rfe" . "$loopyr" . "_" . "$loopmon" . "-dk2.nc";
     chomp $filnamdek2;
     system ("wget -N -r -l1 -e robots=off --no-parent -nd http://$host$remotedir$remcurmondir$filnamdek2");
   }
   if(($loopday >= 28) && ($loopday <= 31)) {
     $filnamdek3 = "rfe" . "$loopyr" . "_" . "$loopmon" . "-dk3.nc";
     chomp $filnamdek3;
     system ("wget -N -r -l1 -e robots=off --no-parent -nd http://$host$remotedir$remcurmondir$filnamdek3");
   }

 } # end of conditional check on existence of year & month directory

} # end of for loop

exit;
