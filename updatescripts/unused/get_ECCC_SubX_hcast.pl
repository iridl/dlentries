#!/usr/bin/perl -w
# Script to update Models SubX ECCC GEPS6 hindcasts 
# Modified 11 July 2019 to download GEPS6 hindcasts
# Nov 13 2023 - Migrated to dlupdates - jeff turmelle
#
# The contact person at CMC for this model is Hai Lin, Hai.Lin@canada.ca , Research Scientist, Meteorological Research Division, 
# Environment and Climate Change Canada / Government of Canada, Tel: 514 421-7276
#
# See the documentation.txt file in /Data/SubX/ECCC/GEPS5/documentation.txt for more information
#
# This model's forecasts are initialized and released weekly on Thursdays.  The hindcasts are being released as 
# new forecasts come out, but for starts at least two weeks ahead of the forecast's start date to allow for 
# the hindcast climatology to be calculated as each forecast start comes out.  Hindcast years for GEPS6 range from 1998 to 2017.
#
# The hindcast data files are downloaded from the following remote http location at CMC:
#
# All variables:  https://collaboration.cmc.ec.gc.ca/cmc/ensemble/subX/hindcast/
#
# The ECCC system changed over from GEPS5 to GEPS6 with the 4 July 2019 forecast start.  Unfortunately, ECCC did not provide
# an indication in the files or filenames which files on their site are for GEPS5 and which ones are for 
# GEPS6.  Initially, ECCC provided the earliest GEPS6 hindcast files for 20 June 2019 to 11 July 2019 forecast starts
# in the following location:
#
# http://collaboration.cmc.ec.gc.ca/cmc/ensemble/subX/hindcast6/
#
# However, after that point, they started providing the GEPS6 hindcast files in the same directory that holds the 
# GEPS5 hindcast files:
#
# https://collaboration.cmc.ec.gc.ca/cmc/ensemble/subX/hindcast/
#
# Therefore, to distinguish between GEPS5 and GEPS6 hindcasts in this directory, just know that the "0718" directories
# and those after that date contain GEPS6 hindcast data.  All directories for dates before that hold GEPS5 data.
#
# The data files are downloaded locally to phoenix to /Data/SubX/ECCC/GEPS6/hindcast 
#
# The dataset in the Data Library is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.ECCC/.GEPS6/ 
#
# --------
#
# More information about the SubX project and each of the models can be found here:
#
# http://cola.gmu.edu/kpegion/subx/index.html
#

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my $lcldir = '/Data/SubX/ECCC/GEPS7/hindcast/'; 
my $host = 'collaboration.cmc.ec.gc.ca';				#http host
my $remotedir = '/cmc/ensemble/subX/hindcast/';               #array of directories
@datelist = ();
@newfiles = ();
@newfiles2 = ();
@dates = ();

chomp $lcldir;
chomp $remotedir;

$curdate = `date +%m%d`;
chomp $curdate;

# since forecasts are released weekly, set a start month/day that has a forecast on that weekly schedule
$startdate = "1111"; 
chomp $startdate;

# assign this start month/day to the checkdate variable, which will step forward week by week 
$checkdate = $startdate;
chomp $checkdate;

$plus1 = "+1 week";

$ict = 0;

print "$checkdate\n";

while ($ict < 300) {
    ++$ict;
    print "$ict\n";

    @newfiles = ();

    # need to add year to day & month so that you can use this date in the "date" command
    $checkdatefull = "2021" . "$checkdate";
    chomp $checkdatefull;
    print "$checkdatefull\n";

    $nextdatefull = `date -d "$checkdatefull $plus1" +%Y%m%d`;
    chomp $nextdatefull;
    print "$nextdatefull\n";

    $nextdate = `date -d "$checkdatefull $plus1" +%m%d`;
    chomp $nextdate;
    print "$nextdate\n";

    $nextdate00 = "$nextdate" . "00";
    print "$nextdate00\n";

    $checkdate = $nextdate;
    chomp $checkdate;
    print "$checkdate\n";

    # get weekly files 

    chdir $lcldir or die "Couldn't change local directory! (1)\n";

    $whatdir = `pwd`;
    print "$whatdir\n";


    @newfiles = getdatafiles("https://$host$remotedir$nextdate/",qr/(subX_reforecast_ECCC_\d\d\d\d\d\d\d\d00_m\d\d.tar$)/);

    #subX_reforecast_ECCC_2014022200_m04.tar 
    #hindcast years are 1998 to 2017

    if(@newfiles) {
	foreach $fil (@newfiles) {
	    if($fil =~ /subX_reforecast_ECCC_\d\d\d\d($nextdate00)_m\d\d.tar/) {
		system("tar -xvf $fil");
		print "$fil\n";
	    }
	}
    }

} # end of while loop

exit;
