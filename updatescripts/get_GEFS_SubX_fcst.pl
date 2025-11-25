#!/usr/bin/perl -w
# Script to update Models SubX EMC GEFS forecasts 
# Jan 25, 2018
# Nov 13 2023 - Migrated to dlupdates - jeff turmelle
#
# The contact person at EMC for this model is Eric Sinsky, eric.sinsky@noaa.gov 
#
# See the documentation.txt file in /Data/SubX/EMC/GEFS/forecast/documentation.txt for more information.
#
# The forecasts for this model are initialized and released weekly on Wednesdays.
#
# The data files are downloaded from the following remote ftp locations at EMC:
#
# Priority 1 variables:  ftp://ftp.emc.ncep.noaa.gov/gmb/emc.enspara/subx/com/gens/dev/YYYYmmdd/output_p1/
#
# Priority 2 variables:  ftp://ftp.emc.ncep.noaa.gov/gmb/emc.enspara/subx/com/gens/dev/YYYYmmdd/output_p2/
#
# Priority 3 variables:  ftp://ftp.emc.ncep.noaa.gov/gmb/emc.enspara/subx/com/gens/dev/YYYYmmdd/output_p3/
#
# where YYYYmmdd is the 4-digit year, 2-digit month, and 2-digit day for the forecast initialization dates.
#
# The data files are downloaded locally to phoenix to /Data/SubX/EMC/GEFS/forecast/YYYYmmdd/ 
#
# The dataset in the Data Library is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.EMC/.GEFS/ 
#
# ------
#
# ROMI files based upon EMC GEFS forecasts:
#
# The contact person at Columbia University APAM is Shuguang Wang, sw2526@columbia.edu
#
# The ROMI files are now downloaded from:  http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/
#
# The data files are downloaded locally to phoenix to /Data/SubX/EMC/GEFS/ROMI/
#
# --------
#
# More information about the SubX project and each of the models can be found here:
#
# http://cola.gmu.edu/kpegion/subx/index.html
#
#
use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my ($user, $passwd) = get_credential("anonymous");

my $lcldir = '/Data/SubX/EMC/GEFS/forecast/'; 
my $host = 'ftp.emc.ncep.noaa.gov';				#http host
#my $remotedir = '/gmb/rwobus/subx/com/gens/dev/';               #array of directories
my $remotedir = '/gmb/emc.enspara/subx/com/gens/dev/';               #array of directories
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

# starting from a known date with a forecast, move forward by one week at a time, and check
# for available forecast files as long as the date is after this first specified forecast
# date and before or coincident with the current date.

$startdate = '20180124';
chomp $startdate;

$checkdate = $startdate;

$plus1 = "+1 week";

# use ict to count number of iterations in while loop & to limit in case of accidental
# infinite loop based upon checkdate error
$ict = 0;

#while (($checkdate <= $curdate) && ($ict < 52)) {
while ($checkdate <= $curdate) {
    ++$ict;
    $nextdate = `date -d "$checkdate $plus1" +%Y%m%d`;
    chomp $nextdate;

    $checkdate = $nextdate; 
    chomp $checkdate;

    # get weekly files, first checking to see if the new weekly directory has been created

    $checkdir = $lcldir . "$nextdate";
    chomp $checkdir;

    if(-d $checkdir){
	print "have $checkdir already\n";
    }
    else {
	print $checkdir;
	mkdir($checkdir);
    }

    if(-d $checkdir){
	chdir $checkdir or die "Couldn't change local directory! (1)\n";

	$whatdir = `pwd`;
	print "$whatdir\n";

	@newfiles1 =  system ("wget --ftp-user=$user --ftp-password=$passwd -A '*.grb2' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir$nextdate/output_p1/");

	@newfiles2 =  system ("wget --ftp-user=$user --ftp-password=$passwd -A '*.grb2' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir$nextdate/output_p2/");

	@newfiles3 =  system ("wget --ftp-user=$user --ftp-password=$passwd -A '*.grb2' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir$nextdate/output_p3/");

    } # end of if check to make sure new directory has been created

} #end of while loop

# download ROMI forecast files

#chdir "/Data/SubX/EMC/GEFS/ROMI" or die "Couldn't change local directory! (2)\n";

#$whatdir = `pwd`;
#print "$whatdir\n";

#  EMC_GEFS_2019_02_13.nc
#  http://dynamo.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/

#@newfiles20 = getdatafiles("http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/",qr/(EMC_GEFS_\d\d\d\d_\d\d_\d\d.nc$)/);

exit;
