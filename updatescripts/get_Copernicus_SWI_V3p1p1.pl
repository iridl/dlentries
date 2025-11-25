#!/usr/bin/perl -w

#Script to download real-time daily gridded soil water index (SWI) from Copernicus 
#Modified from script created to download MONTHLY CDAS
#Feb. 08, 2019

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

# /Data/data21/EC/Copernicus/SWI/V3/V3p1p1/daily/2018

my $lcldir = '/Data/data21/EC/Copernicus/SWI/V3/V3p1p1/daily/'; 
my $host = 'land.copernicus.vgt.vito.be';				#http host
#my $remotedir = qw(/PDF/datapool/Vegetation/Soil_Water/SWI_V3/);               #array of directories
my $remotedir = qw(/PDF/datapool/Vegetation/Soil_Water_Index/Daily_SWI_12.5km_Global_V3/);               #array of directories
@datelist = ();
@newfiles = ();

my ($user, $passwd) = get_credential("copernicus_vito");

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

for($dy = -20; $dy <=0; $dy++) {
# begin a loop that starts with -20 and goes to zero. As this loops, assign each day to $dy 

 $loopyr = `date -d "$curday $curmonb $curyr + $dy days" +%Y`;
 $loopmon = `date -d "$curday $curmonb $curyr + $dy days" +%m`;
 $loopmonnopad = `date -d "$curday $curmonb $curyr + $dy days" +%-m`;
 $loopday = `date -d "$curday $curmonb $curyr + $dy days" +%d`;
 $loopdaynopad = `date -d "$curday $curmonb $curyr + $dy days" +%-d`;
 chomp $loopyr;
 chomp $loopmon;
 chomp $loopmonnopad;
 chomp $loopday;
 chomp $loopdaynopad;

 print "$loopyr $loopmon\n";

 $remcurmondir = "$loopyr" . "/" . "$loopmonnopad" . "/" . "$loopdaynopad" ."/" . "SWI_$loopyr$loopmon$loopday" . "1200_GLOBE_ASCAT_V3.1.1/";
 chomp $remcurmondir;

 $filnam = "c_gls_SWI_" . "$loopyr$loopmon$loopday" . "1200_GLOBE_ASCAT_V3.1.1.nc"; 
 chomp $filnam;

 print "$filnam\n";

 $checkdir = "/Data/data21/EC/Copernicus/SWI/V3/V3p1p1/daily/$loopyr";
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

   print "https://$host$remotedir$remcurmondir$filnam\n";

   system ("wget --user=$user --password=$passwd -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedir$remcurmondir$filnam");

 } # end of conditional check on existence of year directory

} # end of for loop

exit;
