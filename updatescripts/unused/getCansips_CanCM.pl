#!/usr/bin/perl -w

#Script to update Models NMME Cansips and CMC1-CanCM3 and CMC2-CanCM4 forecasts 
#Feb. 23 2015
#
# Updated with more documentation Jul. 25 2019
#
# The primary contact person at CMC for this model is Benoit Archambault, benoit.archambault2@canada.ca .
# Other contact persons at CMC for this model include Manuel Ferreira, manuel.ferreira@canada.ca , and Nicole Bois, nicole.bois@canada.ca .
#
# This model's forecasts are initialized and released monthly, typically on the first day of each month, or the last day of the previous month.
#
# The data files are downloaded from the following remote http location at CMC:
#
# http://collaboration.cmc.ec.gc.ca/cmc/cmoi/GRIB/NMME/1p0deg/
#
# Every month there is a separate file for each variable, each containing all 20 ensemble members.  The data files are downloaded locally on gfs2mon1 to 
# /Data/data23/NMME/Cansips.D/Forecast.D/
# 
# The Cansips forecast dataset in the Data Library is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.Cansips/.FORECAST/.MONTHLY/
#
# However, the datasets most relevant to users are the CMC1-CanCM3 and CMC2-CanCM4 datasets, which each draw their 10 ensemble members from the 20-member 
# Cansips forecast entry (Cansips members 1-10 for CMC1-CanCM3 and Cansips members 11-20 for CMC2-CanCM4).  Previous to the December 2015 start, the two 
# models were provided by CMC as two separate sets of files. From the December 2015 start onward, CMC provided the data in this new file format, in which 
# the data from both models are provided in one grib file, distinguished only by the range of ensemble members they occupy in the grib file.  To ensure 
# continuity of the datasets across the December 2015 start, a new Cansips entry had to be created to read the new grib files containing data from both 
# models, and the two separate model entries for CMC1-CanCM3 and CMC2-CanCM4 had to be rewritten to read the correct ensemble members from the Cansips 
# entry and append those data to the original data at the December 2015 forecast start dividing line.
#
# The Cansips files we download include both an initialization date at the very beginning of the file name, which can actually be a day in the previous 
# month, and the NMME start month and year later in the file name.  The download script we use copies and renames the files to
# exclude the initialization date at the beginning of the original file names.  At the time I was writing the Data Library entry to read these new files, 
# I wasn’t sure how to handle the variable initialization date at the beginning of the file name, which is why I included the renaming step in the i
# download script.  I don’t believe that renaming the files like this is strictly necessary since the initialization date at the beginning of the file 
# name can essentially be treated as a wildcard in the dataset entry, rather than interpolated from the start time grid, which appeared to me to be very 
# difficult to do.  The NMME initialization month and year that appear later in the file names are trivial to interpolate in the dataset entry to create 
# a continuous dataset along the start time grid.
#
# The CMC1-CanCM3 dataset entry is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CMC1-CanCM3/.FORECAST/.MONTHLY/
#
# The CMC2-CanCM4 dataset entry is here: http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.CMC2-CanCM4/.FORECAST/.MONTHLY/
#

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $lcldir = '/Data/data23/NMME/Cansips.D/Forecast.D/'; 
my $host = 'collaboration.cmc.ec.gc.ca';				#http host
my $remotedir = qw(/cmc/cmoi/GRIB/NMME/1p0deg/);               #array of directories
@datelist = ();
@newfiles3 = ();

chomp $lcldir;

# get monthly files

chdir "/Data/data23/NMME/Cansips.D/Forecast.D" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_HGT_ISBL_0200_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles2 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_HGT_ISBL_0500_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles3 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_PRATE_SFC_0_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles4 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_PRMSL_MSL_0_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles5 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_SOILM_DBLL_10cm_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles6 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_TMAX_TGL_2m_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles7 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_TMIN_TGL_2m_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles8 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_TMP_ISBL_0850_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles9 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_TMP_TGL_2m_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles10 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_UGRD_ISBL_0200_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles11 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_UGRD_ISBL_0850_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles12 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_VGRD_ISBL_0200_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles13 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_VGRD_ISBL_0850_\d\d\d\d-\d\d_allmembers.grib2$)/);

@newfiles14 =  getdatafiles("http://$host$remotedir",qr/(\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_WTMP_SFC_0_\d\d\d\d-\d\d_allmembers.grib2$)/);


# @newfiles2 = "2017022800_cansips_forecast_raw_latlon-1x1_HGT_ISBL_0500_2017-03_allmembers.grib2";
# @newfiles3 = "2017022800_cansips_forecast_raw_latlon-1x1_PRATE_SFC_0_2017-03_allmembers.grib2";

if(@newfiles) {
 foreach $fil (@newfiles) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_HGT_ISBL_0200_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_HGT_ISBL_0200_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles\n";
}  # end if(@newfiles)

if(@newfiles2) {
 foreach $fil (@newfiles2) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_HGT_ISBL_0500_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_HGT_ISBL_0500_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles2\n";
}  # end if(@newfiles2)

if(@newfiles3) {
 foreach $fil (@newfiles3) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_PRATE_SFC_0_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_PRATE_SFC_0_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles3\n";
 print "@datelist\n";
}  # end if(@newfiles3)

if(@newfiles4) {
 foreach $fil (@newfiles4) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_PRMSL_MSL_0_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_PRMSL_MSL_0_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles4\n";
}  # end if(@newfiles4)

if(@newfiles5) {
 foreach $fil (@newfiles5) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_SOILM_DBLL_10cm_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_SOILM_DBLL_10cm_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles5\n";
}  # end if(@newfiles5)

if(@newfiles6) {
 foreach $fil (@newfiles6) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_TMAX_TGL_2m_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_TMAX_TGL_2m_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles6\n";
}  # end if(@newfiles6)

if(@newfiles7) {
 foreach $fil (@newfiles7) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_TMIN_TGL_2m_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_TMIN_TGL_2m_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles7\n";
}  # end if(@newfiles7)

if(@newfiles8) {
 foreach $fil (@newfiles8) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_TMP_ISBL_0850_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_TMP_ISBL_0850_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles8\n";
}  # end if(@newfiles8)

if(@newfiles9) {
 foreach $fil (@newfiles9) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_TMP_TGL_2m_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_TMP_TGL_2m_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles9\n";
}  # end if(@newfiles9)

if(@newfiles10) {
 foreach $fil (@newfiles10) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_UGRD_ISBL_0200_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_UGRD_ISBL_0200_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles10\n";
}  # end if(@newfiles10)

if(@newfiles11) {
 foreach $fil (@newfiles11) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_UGRD_ISBL_0850_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_UGRD_ISBL_0850_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles11\n";
}  # end if(@newfiles11)

if(@newfiles12) {
 foreach $fil (@newfiles12) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_VGRD_ISBL_0200_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_VGRD_ISBL_0200_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles12\n";
}  # end if(@newfiles12)

if(@newfiles13) {
 foreach $fil (@newfiles13) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_VGRD_ISBL_0850_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_VGRD_ISBL_0850_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles13\n";
}  # end if(@newfiles13)

if(@newfiles14) {
 foreach $fil (@newfiles14) {
    if($fil =~ /\d\d\d\d\d\d\d\d\d\d_cansips_forecast_raw_latlon-1x1_WTMP_SFC_0_(\d\d\d\d-\d\d)_allmembers.grib2/) {
        system "cp $fil cansips_forecast_raw_latlon-1x1_WTMP_SFC_0_$1_allmembers.grib2";
        push(@datelist,$1);
    }
 }
 print "@newfiles14\n";
}  # end if(@newfiles14)



exit;
