#!/usr/bin/perl -w

#Script to download real-time daily, dekadal, and monthly TAMSAT TARCAT v3.1 data.
#Modified from script created to download MONTHLY CDAS
#August 3, 2020

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
#

# /Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1
#
# http://gws-access.jasmin.ac.uk/public/tamsat/rfe/data/v3.1/daily/2020/07/
# http://gws-access.jasmin.ac.uk/public/tamsat/rfe/data/v3.1/dekadal/2020/07/
# http://gws-access.jasmin.ac.uk/public/tamsat/rfe/data/v3.1/monthly/2020/07/

my $lcldir = '/Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/';
my $host = 'gws-access.jasmin.ac.uk';				#http host
my $remotedirdly = qw(/public/tamsat/rfe/data/v3.1/daily/);               #array of directories
my $remotedirdek = qw(/public/tamsat/rfe/data/v3.1/dekadal/);               #array of directories
my $remotedirmon = qw(/public/tamsat/rfe/data/v3.1/monthly/);               #array of directories
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

# daily:  rfe2020_06_20.v3.1.nc  /Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/daily/2020/06
# dekadal:  rfe2020_06-dk2.v3.1.nc   /Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/dekad/2020/06
# monthly:  rfe2020_05.v3.1.nc  /Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/monthly/2020/05

 $filnamday = "rfe" . "$loopyr" . "_" . "$loopmon" . "_" . "$loopday" . ".v3.1.nc";
 chomp $filnamday;

 print "$filnamday\n";

 $checkdirdlyyr = "/Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/daily/$loopyr";
 chomp $checkdirdlyyr;

 if(-d $checkdirdlyyr){
    print "have $checkdirdlyyr already\n";
 }
 else {
    print $checkdirdlyyr;
    mkdir($checkdirdlyyr);
 }

 $checkdirdly = "/Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/daily/$loopyr/$loopmon";
 chomp $checkdirdly;

 if(-d $checkdirdly){
    print "have $checkdirdly already\n";
 }
 else {
    print $checkdirdly;
    mkdir($checkdirdly);
 }

 if(-d $checkdirdly){
   chdir($checkdirdly) or die "Couldn't change local daily directory! (1)\n";

   $whatdir = `pwd`;
   print "$whatdir\n";

#  get daily files
   system ("wget -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedirdly$remcurmondir$filnamday");

 } # end if local daily directory exists

#  get dekadal files

 $checkdirdekyr = "/Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/dekad/$loopyr";
 chomp $checkdirdekyr;

 if(-d $checkdirdekyr){
    print "have $checkdirdekyr already\n";
 }
 else {
    print $checkdirdekyr;
    mkdir($checkdirdekyr);
 }

 $checkdirdek = "/Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/dekad/$loopyr/$loopmon";
 chomp $checkdirdek;

 if(-d $checkdirdek){
    print "have $checkdirdek already\n";
 }
 else {
    print $checkdirdek;
    mkdir($checkdirdek);
 }

 if(-d $checkdirdek){
   chdir($checkdirdek) or die "Couldn't change local dekadal directory! (2)\n";

   $whatdekdir = `pwd`;
   print "$whatdekdir\n";

   if($loopday == 10) {
     $filnamdek1 = "rfe" . "$loopyr" . "_" . "$loopmon" . "-dk1.v3.1.nc";
     chomp $filnamdek1;
     system ("wget -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedirdek$remcurmondir$filnamdek1");
   }
   if($loopday == 20) {
     $filnamdek2 = "rfe" . "$loopyr" . "_" . "$loopmon" . "-dk2.v3.1.nc";
     chomp $filnamdek2;
     system ("wget -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedirdek$remcurmondir$filnamdek2");
   }
   if(($loopday >= 28) && ($loopday <= 31)) {
     $filnamdek3 = "rfe" . "$loopyr" . "_" . "$loopmon" . "-dk3.v3.1.nc";
     chomp $filnamdek3;
     system ("wget -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedirdek$remcurmondir$filnamdek3");
   }
 } # end if local dekadal directory exists
} # end of daily for loop

# get monthly files

for($mn = -2; $mn <= -1; $mn++) {
# begin a loop that starts with -2 and goes to zero. As this loops, assign each month to $mn

 $monloopyr = `date -d "$mn month" +%Y`;
 $monloopmon = `date -d "$mn month" +%m`;
 chomp $monloopyr;
 chomp $monloopmon;

 print "$monloopyr $monloopmon\n";

 $monremcurmondir = "$monloopyr" . "/" . "$monloopmon" . "/";

 $checkdirmonyr = "/Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/monthly/$monloopyr";
 chomp $checkdirmonyr;

 if(-d $checkdirmonyr){
    print "have $checkdirmonyr already\n";
 }
 else {
    print $checkdirmonyr;
    mkdir($checkdirmonyr);
 }

 $checkdirmon = "/Data/data21/Reading/Meteorology/TAMSAT/TARCAT/v3p1/monthly/$monloopyr/$monloopmon";
 chomp $checkdirmon;

 if(-d $checkdirmon){
    print "have $checkdirmon already\n";
 }
 else {
    print $checkdirmon;
    mkdir($checkdirmon);
 }

 if(-d $checkdirmon){
   chdir($checkdirmon) or die "Couldn't change local monthly directory! (3)\n";

   $whatmondir = `pwd`;
   print "$whatmondir\n";

   $filnammon = "rfe" . "$monloopyr" . "_" . "$monloopmon" . ".v3.1.nc";
   chomp $filnammon;
   print "$filnammon\n";

   system ("wget -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedirmon$monremcurmondir$filnammon");

 } # end of conditional check on existence of local monthly directory
} # end of monthly for loop

exit;
