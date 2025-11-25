#!/usr/bin/perl -w

# modified script to explicitly specify variable names, more recent dates, and ensemble members in wget requests on 29 May 2020
#Script to update Models SubX GEOS_v2p1 forecasts 
#Nov 20, 2017
#
# The contact person at NASA for this model is Kazumi Nakada, kazumi.nakada@nasa.gov ,  NASA GSFC GMAO Code 610.1, Phone: 301-614-5843
#
# See the documentation.txt and README files in /volume1/DataLibrary/SubX/NASA/GEOS_V2p1/ for more information
#
# Forecasts for this model are initialized and released every 5 days instead of weekly.
#
# The data files are downloaded from the following remote https locations at NASA GSFC:
#
# Priority 1 variables:  https://gmao.gsfc.nasa.gov/gmaoftp/gmaofcst/subx/GEOS_S2S_V2.1_fcst/pr1/
#
# Other variables:  https://gmao.gsfc.nasa.gov/gmaoftp/gmaofcst/subx/GEOS_S2S_V2.1_fcst/IRI/
#
# The data files are downloaded locally to phoenix to /volume1/DataLibrary/SubX/NASA/GEOS_V2p1/forecast/ 
#
# The dataset in the Data Library is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.GMAO/.GEOS_V2p1/
#
# ------
#
# ROMI files based upon NASA GMAO forecasts:
#
# The contact person at Columbia University APAM is Shuguang Wang, sw2526@columbia.edu
#
# The ROMI files are now downloaded from:  http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/
#
# The data files are downloaded locally to phoenix to /volume1/DataLibrary/SubX/NASA/GEOS_V2p1/ROMI/
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

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $lcldir = '/volume1/DataLibrary/SubX/NASA/GEOS_V2p1/forecast/'; 
#my $host = 'gmaoftp.gsfc.nasa.gov';				#ftp host
my $host = 'gmao.gsfc.nasa.gov';				#https host
#my $remotedir = '/pub/data/dvarier/subx/GEOS_S2S_V2.1_fcst/pr1/';               #remote directory
my $remotedir = '/gmaoftp/gmaofcst/subx/GEOS_S2S_V2.1_fcst/pr1/';               #remote directory
my $remotedir2 = '/gmaoftp/gmaofcst/subx/GEOS_S2S_V2.1_fcst/IRI/';               #remote directory
#my $remotedir3 = '/gmaoftp/gmaofcst/subx/GEOS_S2S_V2.1_fcst/pr3/';               #remote directory
@datelist = ();
@newfiles1 = ();
@newfiles2 = ();
@newfiles3 = ();
@newfiles20 = ();
@dates = ();
@vars1 = ();
@vars2 = ();
@ens = ();

chomp $lcldir;

$curdate = `date +%Y%m%d`;
chomp $curdate;

%monname = qw(01 jan 02 feb 03 mar 04 apr 05 may 06 jun 07 jul 08 aug 09 sep 10 oct 11 nov 12 dec);

@vars1 = qw( mrro mrso pr_sfc rlut_toa rzsm tas_2m ts_sfc ua_200 ua_850 va_200 va_850 zg_200 zg_500 );

@vars2 = qw( cape dlwrf_sfc dswrf_sfc hfls_sfc hfss_sfc huss_850 mrro mrso psl sic snc_sfc snodp stx_sfc sty_sfc 
 swe ta_100 ta_10 ta_30 ta_50 tasmax_2m tasmin_2m tdps_2m ua_100 ua_10 ua_30 ua_50 uas_10m ulwrf_sfc uswrf_sfc 
 va_100 va_10 va_30 va_50 vas_10m vq300 wap_500 zg_10 zg_30 zg_50 zg_850 );

@ens = qw( m01 m02 m03 m04 );

# starting from a known date with a forecast, move forward by five days at a time, and check
# for available forecast files as long as the date is after this first specified forecast
# date and before or coincident with the current date.

# get files available for approx. pentad starts

chdir "/volume1/DataLibrary/SubX/NASA/GEOS_V2p1/forecast" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

$startdate = '20200521';
chomp $startdate;

$checkdate = $startdate;

$plus5 = "+5 days";

$ict = 0;

while ($checkdate <= $curdate) {
  ++$ict;
  $nextdate = `date -d "$checkdate $plus5" +%Y%m%d`;
  chomp $nextdate;

  if ($nextdate > $curdate) {
    exit;
  }

  $nextyr = `date -d "$checkdate $plus5" +%Y`;
  $nextmon = `date -d "$checkdate $plus5" +%m`;
  $nextday = `date -d "$checkdate $plus5" +%d`;

  chomp $nextyr;
  chomp $nextmon;
  chomp $nextday;

  $nextmonb = $monname{$nextmon};
  chomp $nextmonb;

  print "$nextdate\n";
  print "$nextyr\n";
  print "$nextmon\n";
  print "$nextmonb\n";
  print "$nextday\n";

  $loopdate = "$nextday" . "$nextmonb" . "$nextyr";
  chomp $loopdate;
  print "$loopdate\n";


  foreach $var1 (@vars1) {
    foreach $en (@ens) { 
      $filnom1 = "$var1" . "_GMAOGEOS_" . "$loopdate" . "_00z_d01_d45_" . "$en" . ".nc";
      chomp $filnom1;
      print "$filnom1\n";
      @newfiles1 =  system ("wget -A '*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$filnom1");
    }
  }

  foreach $var2 (@vars2) {
    foreach $en (@ens) { 
      $filnom2 = "$var2" . "_GMAOGEOS_" . "$loopdate" . "_00z_d01_d45_" . "$en" . ".nc";
      chomp $filnom2;
      print "$filnom2\n";
      @newfiles2 =  system ("wget -A '*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir2$filnom2");
    }
  }
 
  $checkdate = $nextdate; 
  chomp $checkdate;

}


# download ROMI forecast files

  #chdir "/volume1/DataLibrary/SubX/NASA/GEOS_V2p1/ROMI" or die "Couldn't change local directory! (2)\n";

  #$whatdir = `pwd`;
  #print "$whatdir\n";

# GMAO_GEOS_V2p1_2019_02_17.nc
# http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/

  #@newfiles20 = getdatafiles("http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/",qr/(GMAO_GEOS_V2p1_\d\d\d\d_\d\d_\d\d.nc$)/);

exit;


