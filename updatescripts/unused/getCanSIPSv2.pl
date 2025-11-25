#!/usr/bin/perl -w

#Script to update Models NMME CanSIPSv2 from which GEM-NEMO and CanCM4i output is derived 
# Sep 04, 2019
#
# The primary contact person at CMC for this model is Bill Merryfield, bill.merryfield@canada.ca . Benoit Archambault, benoit.archambault2@canada.ca .
# Other contact persons at CMC for this model include Benoit Archambault, benoit.archambault2@canada.ca , Manuel Ferreira, manuel.ferreira@canada.ca , 
# and Nicole Bois, nicole.bois@canada.ca .
#
# This model's forecasts are initialized and released monthly, typically on the first day of each month, or the last day of the previous month.
#
# The data files are downloaded from the following remote http location at CMC:
#
# http://collaboration.cmc.ec.gc.ca/cmc/cmoi/GRIB/NMME/1p0deg/
# 
# As of August 2019, CanSIPSv2, GEM-NEMO, and CanCM4i have taken the place of CMC's previous NMME models, Cansips, CMC1-CanCM3, and CMC2-CanCM4, 
# which were discontinued after the July 2019 start.
#
# Every month there is a separate file for each variable, each containing all 20 ensemble members.  The data files are downloaded locally on gfs2mon1 to 
# /Data/data23/NMME/CanSIPSv2.D/Forecast.D/ 
# 
# The CanSIPSv2 forecast dataset in the Data Library is placed here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanSIPSv2/.FORECAST/.MONTHLY/
#
# However, the datasets most relevant to users are the GEM-NEMO and CanCM4i datasets, which each draw their 10 ensemble members from the 20-member 
# CanSIPSv2 forecast entry (CanSIPSv2 members 1-10 for GEM-NEMO and CanSIPSv2 members 11-20 for CanCM4i).   
#
# The CanSIPSv2 files we download include both an initialization date at the very beginning of the file name, which can actually be a day in the previous 
# month, and the NMME start month and year later in the file name. 
#
# The GEM-NEMO dataset entry is placed here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.GEM-NEMO/.FORECAST/.MONTHLY/
#
# The CanCM4i dataset entry is placed here: http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CanCM4i/.FORECAST/.MONTHLY/
#

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $lcldir = '/Data/data23/NMME/CanSIPSv2.D/Forecast.D/'; 
my $host = 'collaboration.cmc.ec.gc.ca';				#http host
#my $remotedir = qw(/cmc/cmoi/GRIB/NMME/1p0deg/forecast/);               #array of directories
my $remotedir = qw(/cmc/cmoi/GRIB/NMME/1p0deg/);               #array of directories

chomp $lcldir;
chomp $host;
chomp $remotedir;

# get monthly files

chdir "/Data/data23/NMME/CanSIPSv2.D/Forecast.D" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_HGT_ISBL_0200_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles2 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_HGT_ISBL_0500_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles3 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_PRATE_SFC_0_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles4 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_PRMSL_MSL_0_\d\d\d\d-\d\d_allmembers.grib2$)/);

#@newfiles5 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_SOILM_DBLL_10cm_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles6 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_TMAX_TGL_2m_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles7 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_TMIN_TGL_2m_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles8 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_TMP_ISBL_0850_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles9 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_TMP_TGL_2m_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles10 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_UGRD_ISBL_0200_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles11 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_UGRD_ISBL_0850_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles12 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_VGRD_ISBL_0200_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles13 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_VGRD_ISBL_0850_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles14 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_nmme_latlon-1x1_WTMP_SFC_0_\d\d\d\d-\d\d_allmembers.grib2$)/);

# 2019073100_cansips_forecast_raw_nmme_latlon-1x1_HGT_ISBL_0200_2019-08_allmembers.grib2
# 2019073100_cansips_forecast_raw_nmme_latlon-1x1_HGT_ISBL_0500_2019-08_allmembers.grib2

exit;
