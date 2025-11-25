#!/usr/bin/perl -w

#Script to update Models SubX ESRL FIMr1p1 forecasts 
#Nov 02, 2017
#
# The contact person at ESRL for this model is Ben Green, ben.green@noaa.gov 
#
# Other related contacts at ESRL include:  Shan Sun, shan.sun@noaa.gov , Bob Lipschutz, robert.c.lipschutz@noaa.gov , Stan Benjamin, stan.benjamin@noaa.gov
#
# See the documentation.txt file in /volume1/DataLibrary/SubX/ESRL/FIMr1p1/documentation.txt for more information.
#
# The forecasts for this model are initialized and released weekly on Wednesdays.  The data providers asked that the previous version of this model, FIMr1.0
# no longer be served via the Data Library, but we still have those data files saved on phoenix.
#
# The data files are downloaded from the following remote ftp locations at ESRL:
#
# All variables:  ftp://gsdftp.fsl.noaa.gov/SubX-ESRL-FIMr1.1/
#
# The data files are downloaded locally to phoenix to /volume1/DataLibrary/SubX/ESRL/FIMr1p1/forecast/ 
#
# The dataset in the Data Library is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.ESRL/.FIMr1p1/ 
#
# ------
#
# ROMI files based upon ESRL FIMr1p1 forecasts:
#
# The contact person at Columbia University APAM is Shuguang Wang, sw2526@columbia.edu
#
# The ROMI files are now downloaded from:  http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/
#
# The data files are downloaded locally to phoenix to /volume1/DataLibrary/SubX/ESRL/FIMr1p1/ROMI/ 
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
#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $lcldir = '/volume1/DataLibrary/SubX/ESRL/FIMr1p1/forecast/'; 
my $host = 'gsdftp.fsl.noaa.gov';				#http host
my $remotedir = qw(/SubX-ESRL-FIMr1.1/);               #array of directories
@datelist = ();
@newfiles = ();
@newfiles20 = ();
@dates = ();

chomp $lcldir;

# get weekly files

chdir "/volume1/DataLibrary/SubX/ESRL/FIMr1p1/forecast" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  system ("wget --ftp-user=$user --ftp-password=$passwd -A 'fim_?????????_m??.zip' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir");

print "@newfiles\n";

@newfiles2 =  system ("wget --ftp-user=$user --ftp-password=$passwd -A '*.nc' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir");

#if(@newfiles) {
# foreach $fil (@newfiles) {
#    if($fil =~ /fim_\d\d[a-z][a-z][a-z]\d\d\d\d_m\d\d.zip/) {
#        system "unzip $fil";
#    }
# }
# print "@newfiles\n";
#}  # end if(@newfiles)

# download ROMI forecast files

  #chdir "/volume1/DataLibrary/SubX/ESRL/FIMr1p1/ROMI" or die "Couldn't change local directory! (2)\n";

  #$whatdir = `pwd`;
  #print "$whatdir\n";

# ESRL_FIMr1p1_2019_02_13.nc
# http://dynamo.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/

  #@newfiles20 = getdatafiles("http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/",qr/(ESRL_FIMr1p1_\d\d\d\d_\d\d_\d\d.nc$)/);

exit;
