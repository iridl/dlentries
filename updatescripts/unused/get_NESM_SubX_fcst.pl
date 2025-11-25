#!/usr/bin/perl -w

#Script to update Models SubX NRL NESM forecasts 
#Nov 02, 2017
#
# The contact person at NRL for this model is Joe Metzger, joe.metzger@nrlssc.navy.mil 
#
# See the documentation.txt file in /volume1/DataLibrary/SubX/NRL/NESM/documentation.txt for more information.
#
# The forecasts for this model are released weekly on Wednesdays.  However, unlike most of the other SubX models, the 
# initializations are for four consecutive days during the week.  Additionally, the initialization time is 12Z instead of 00Z,
# and in some variables, the L = 0.5 day lead is not available -- the first lead for these variables is for L = 1.5
#
# The data files are downloaded from the following remote https locations at NRL:
#
# Priority 1 variables:  https://www7320.nrlssc.navy.mil/nesm/forecast/priority1/ 
#
# Priority 2 variables:  https://www7320.nrlssc.navy.mil/nesm/forecast/priority2/ 
#
# The data files are downloaded locally to phoenix to /volume1/DataLibrary/SubX/NRL/NESM/forecast/ 
#
# The dataset in the Data Library is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.NRL/.NESM/ 
#
# ------
#
# ROMI files based upon NRL NESM forecasts:
#
# The contact person at Columbia University APAM is Shuguang Wang, sw2526@columbia.edu
#
# The ROMI files are now downloaded from:  http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/
#
# The data files are downloaded locally to phoenix to /volume1/DataLibrary/SubX/NRL/NESM/ROMI/ 
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

my ($user, $passwd) = get_credential("subx_navy");

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $lcldir = '/volume1/DataLibrary/SubX/NRL/NESM/forecast/'; 
my $host = 'www7320.nrlssc.navy.mil';				#http host
my $remotedir = '/nesm/forecast';               #array of directories
@datelist = ();
@newfiles1 = ();
@newfiles2 = ();
@newfiles20 = ();

chomp $lcldir;
chomp $remotedir;

# get weekly files

chdir "/volume1/DataLibrary/SubX/NRL/NESM/forecast" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles1 =  system ("wget --user=$user --password=$passwd --no-check-certificate -A '*.nc' -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedir/priority1/");

@newfiles2 =  system ("wget --user=$user --password=$passwd --no-check-certificate -A '*.nc' -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedir/priority2/");

# download ROMI forecast files

  #chdir "/volume1/DataLibrary/SubX/NRL/NESM/ROMI" or die "Couldn't change local directory! (2)\n";

  #$whatdir = `pwd`;
  #print "$whatdir\n";

# NRL_NESM_2019_02_11.nc
# http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/

  #@newfiles20 = getdatafiles("http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/",qr/(NRL_NESM_\d\d\d\d_\d\d_\d\d.nc$)/);

  #print "@newfiles20\n";

exit;
