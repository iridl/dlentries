#!/usr/bin/perl -w

#Script to update Models SubX RSMAS CCSM4 forecasts 
#Nov 02, 2017
#
# The contact person at RSMAS for this model is Dug Hong Min, dmin@rsmas.miami.edu .
#
# The other contact person at RSMAS associated with this model is Ben Kirtman, bkirtman@rsmas.miami.edu .
#
# See the documentation.txt file in /volume1/DataLibrary/SubX/RSMAS/CCSM4/documentation.txt for more information.
#
# The forecasts for this model are initialzed weekly on Sundays, but may be released up to two or three days later.   
#
# The data files are downloaded from the following remote ftp locations at RSMAS:
#
# Priority 1 variables:  ftp://decadal.rsmas.miami.edu/forecast/priority1/ 
#
# Priority 2 variables:  ftp://decadal.rsmas.miami.edu/forecast/priority2/ 
#
# The data files (both priority 1 and priority 2) are downloaded locally to phoenix to /volume1/DataLibrary/SubX/RSMAS/CCSM4/forecast/priority1/ 
#
# The dataset in the Data Library is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.RSMAS/.CCSM4/ 
#
# ------
#
# ROMI files based upon NRL NESM forecasts:
#
# The contact person at Columbia University APAM is Shuguang Wang, sw2526@columbia.edu
#
# The ROMI files are now downloaded from:  http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/
#
# The data files are downloaded locally to phoenix to /volume1/DataLibrary/SubX/RSMAS/CCSM4/ROMI/ 
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
require "$libdir/credentials.pl";

#require "ctime.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my ($user, $passwd) = get_credential("subx_ccsm4");

my $lcldir = '/Data/SubX/RSMAS/CCSM4/'; 
my $host = 'decadal.rsmas.miami.edu';				#ftp host
my $remotedir = '/../../raid6/dmin/CPC_DATA/CCSM4/forecast';               #array of directories
@datelist = ();
@newfiles1 = ();
@newfiles2 = ();
@newfiles3 = ();
@newfiles20 = ();

chomp $lcldir;
chomp $remotedir;

# get weekly files

chdir $lcldir . "forecast/priority1/" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles1 =  system ("wget --ftp-user=$user --ftp-password=$passwd -A '*.nc' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir/priority1/");

@newfiles2 =  system ("wget --ftp-user=$user --ftp-password=$passwd -A '*.nc' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir/priority2/");

exit;
