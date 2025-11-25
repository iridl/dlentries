#!/usr/bin/perl -w

#Script to update forecast data for Models NMME GFDL-CM2p1_v3p1_aer04 MONTHLY
#Modified from script created to download MONTHLY CDAS
#Jul 24, 2012

# Updated with more documentation 25 Jul 2019
# The primary contact person for this model at GFDL is Rich Gudgel, rich.gudgel@noaa.gov .
#
# This model's forecasts are initialized and released monthly.
#
# The data files are downloaded from the following remote ftp locations at GFDL:
#
# ftp://ftp.gfdl.noaa.gov/pub/Oar.Gfdl.Nmme/Vandendool/$month_retrospective_v3.1_aer04/
#
# and 
#
# ftp://ftp.gfdl.noaa.gov/pub/Oar.Gfdl.Nmme/Vandendool/$month_retrospective_v3.1_aer04/additional_variables/
#
# where $month is the lowercase full name of the start month, such as
#
# august_retrospective_v3.1_aer04/
#
# These month-of-year subdirectories contain data files for each variable and each of 10 ensemble members.  Please 
# note that GFDL removes data files from subdirectories of previous start months very quickly.
#
# The data files are downloaded locally on gfs2mon1 to 
# /Data/data23/NMME/GFDL_CM2.1_v3.1_aer04.D/
#
# with month-of-year subdirectories holding the files for each start month but for all years.
#
# The GFDL CM2.1-aer04 forecast dataset in the Data Library is here: 
# http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.GFDL-CM2p1-aer04/.MONTHLY/
#

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $host = 'ftp.gfdl.noaa.gov';				#ftp host
my $remotedir = qw(/pub/Oar.Gfdl.Nmme/Vandendool/);               #array of directories
#my $remotedir = qw(/pub/nmme/Vandendool/);               #array of directories
#my $remotedir = qw(/pub/l1k/Vandendool/);               #array of directories
#my $remotedir = qw(/pub/rgg/Vandendool/);               #array of directories
@datelist = ();
@newfiles = ();

# assign a two-digit month number for current month in which script is run to $curmon
#$curmon = "05";
$curmon = `date +%m`;
chomp $curmon;

# convert two-digit month number to lowercase full month name and assign to %monname
%monname = qw(01 january 02 february 03 march 04 april 05 may 06 june 07 july 08 august 09 september 10 october 11 november 12 december);
$remcurmon = $monname{$curmon};

# convert two-digit month number to 3-letter month abbr. and assign to $nmon

%monabbr = qw(01 Jan 02 Feb 03 Mar 04 Apr 05 May 06 Jun 07 Jul 08 Aug 09 Sep 10 Oct 11 Nov 12 Dec);
$nmon = $monabbr{$curmon};

$localmondir = "$nmon" . ".D";
chomp $localmondir;

$remcurmondir = "$remcurmon" . "_retrospective_v3.1_aer04/";
chomp $remcurmondir;

$addvar = "additional_variables/";
chomp $addvar;

print "$localmondir\n";

print "$remcurmondir\n"; 

# get monthly files

chdir "/Data/data23/NMME/GFDL_CM2.1_v3.1_aer04.D/$localmondir" or die "Couldn't change local directory! (2)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  getdatafiles("ftp://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d01.1x1.precip_ens\d\d.nc$)/);

@newfiles2 = getdatafiles("ftp://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d01.1x1.sst_ens\d\d.nc$)/);

@newfiles3 = getdatafiles("ftp://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d01.1x1.t_ref_ens\d\d.nc$)/);

@newfiles4 = getdatafiles("ftp://$host$remotedir$remcurmondir$addvar",qr/(\d\d\d\d\d\d01.1x1.hght.200hPa_ens\d\d.nc$)/);

@newfiles5 = getdatafiles("ftp://$host$remotedir$remcurmondir$addvar",qr/(\d\d\d\d\d\d01.1x1.mrro_ens\d\d.nc$)/);

@newfiles6 = getdatafiles("ftp://$host$remotedir$remcurmondir$addvar",qr/(\d\d\d\d\d\d01.1x1.mrso_ens\d\d.nc$)/);

@newfiles7 = getdatafiles("ftp://$host$remotedir$remcurmondir$addvar",qr/(\d\d\d\d\d\d01.1x1.t_ref_max_ens\d\d.nc$)/);

@newfiles8 = getdatafiles("ftp://$host$remotedir$remcurmondir$addvar",qr/(\d\d\d\d\d\d01.1x1.t_ref_min_ens\d\d.nc$)/);

@newfiles9 = getdatafiles("ftp://$host$remotedir$remcurmondir$addvar",qr/(\d\d\d\d\d\d01.1x1.hght_200hPa_ens\d\d.nc$)/);


#@newfiles = qw(20120201.1x1.precip_ens01.nc 20120301.1x1.precip_ens01.nc);

#if(@newfiles) {
#
# foreach $fil (@newfiles) {
#    if($fil =~ /(\d\d\d\d\d\d)01.1x1.precip_ens01.nc/) {
#        push(@datelist,$1);
#    }
# }
#
#}  # end if(@newfiles)

exit;
