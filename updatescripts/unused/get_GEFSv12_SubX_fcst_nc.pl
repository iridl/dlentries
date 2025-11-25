#!/usr/bin/perl -w

#Script to update Models SubX EMC GEFSv12 forecasts. The first GEFSv12 forecasts were initialized 30 Sep 2020, and 
#became available on 01 Oct 2020 

#October 1, 2020
#
# The contact person at EMC for this model is Eric Sinsky, eric.sinsky@noaa.gov 
#
# More information about the SubX project and each of the models can be found here:
#
# http://cola.gmu.edu/kpegion/subx/index.html
#
#

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("anonymous");

my $lcldir = '/Data/SubX/EMC/GEFSv12_CPC/netcdf/forecast/';
my $host = 'ftp.cpc.ncep.noaa.gov';
my $remotedir = '/dcollins/SubX/GEFS/';

@datelist = ();
@newfiles1 = ();
@newfiles2 = ();
@newfiles3 = ();
@newfiles20 = ();

chomp $lcldir;
chomp $remotedir;

# find the current date as YYYYmmdd format

$curdate = `date +%Y%m%d`;
chomp $curdate;

# starting from a known date with a forecast, move forward by one day at a time, and check
# for available forecast files as long as the date is after this first specified forecast
# date and before or coincident with the current date.

$startdate = `date -d "$curdate -7 day" +%Y%m%d`;

chomp $startdate;

$checkdate = $startdate;

$plus1 = "+1 day";

# use ict to count number of iterations in while loop & to limit in case of accidental
# infinite loop based upon checkdate error
$ict = 0;

while ($checkdate <= $curdate) {
 ++$ict;
 $nextdate = `date -d "$checkdate $plus1" +%Y%m%d`;
 chomp $nextdate;

 $checkdate = $nextdate; 
 chomp $checkdate;

# get daily files, first checking to see if the new daily directory has been created

 $checkdir = "$lcldir" . "$nextdate";
 chomp $checkdir;

 if(-d $checkdir){
    print "have $checkdir already\n";
 }
 else {
    print $checkdir;
    mkdir($checkdir);
 }

 if(-d $checkdir){
  chdir "$lcldir$nextdate" or die "Couldn't change local directory! (1)\n";

  $whatdir = `pwd`;
  print "$whatdir\n";

  my $day = `date -d $nextdate +%d`;
  chomp $day;
  my $month = `date -d $nextdate +%b`;
  chomp $month;
  my $year = `date -d $nextdate +%Y`;
  chomp $year;
  $month = lc $month;

  @newfiles1 =  system ("wget --ftp-user=$user --ftp-password=$passwd -A '*${day}${month}${year}*.nc' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir/");

 } # end of if check to make sure new directory has been created

} #end of while loop

exit;
