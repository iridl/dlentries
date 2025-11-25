#!/usr/bin/perl -w

#Script to download data for Models NMME NASA-GEOSS2S MONTHLY
#Modified from script created to download MONTHLY CDAS
# run this on gfs2geo1 and gfs2mon1 
# Feb 13, 2018

# Modified to change remote https site 12 Nov 2019 
# The primary contact person for this model at NASA is Kazumi Nakada, kazumi.nakada@nasa.gov .
#
# More information about this model can be found in the following documentation file:
#
# /Data/data23/NMME/NASA_GEOSS2S.D/Forecast.D/dataset_documentation.txt
#
# This model's forecasts are initialized and released monthly.
#
# The data files are downloaded from the following remote https location at NASA:
#
# https://gmao.gsfc.nasa.gov/gmaoftp/gmaofcst/seasonal/GEOSS2S-2_1/NMME/forecast/monthly/YYYY/mmm/
#
# Where YYYY is the 4-digit year of the NMME forecast start month, and mmm is the lowercase, 3-letter English abbreviation of the NMME forecast start month, for example:
#
# https://gmao.gsfc.nasa.gov/gmaoftp/gmaofcst/seasonal/GEOSS2S-2_1/NMME/forecast/monthly/2018/apr/
#
# These subdirectories contain data files for each variable and each of 10 ensemble members.  The files representing different 
# ensemble members are labelled according to the forecast initialization date and the ensemble member.  Generally, there are 
# 7 ensemble members (4-10) associated with initializations on the last day of the month before the NMME forecast start date 
# (00Z on the first day of the month), and 3 ensemble members (1-3) associated with initializations every 5 previous days 
# (e.g., the 15th, 20th, and 25th days of the month previous to the NMME forecast start date).
#
# The update script uses the last initialization dates in the forecast file names that are downloaded (dated with the last day 
# of the month previous to the NMME forecast start date) to determine the month and year of the NMME forecast start, and writes those to the file 
# /Data/data23/NMME/NASA_GEOSS2S.D/Forecast.D/endmonth.txt
#
# This “endmonth.txt” file is read by the index.tex file for this dataset to specify the end date of the start time grid “S” for this model’s forecast.
#
# Please note that the earliest available NMME forecasts for this model are from the November 2017 start date.  Unlike the other 
# NMME models which have hindcasts ending in 2010, this model includes hindcasts from 1981 to January 2017.  However, this also 
# means that there is a gap of several months between the end of the hindcast period and the start of the forecast period.
#
# The data files are downloaded locally on gfs2mon1 to 
# /Data/data23/NMME/NASA_GEOSS2S.D/Forecast.D/
#
# with month-of-year subdirectories holding the files for each start month, but for all years.
#  
#  The NASA-GEOSS2S forecast dataset in the Data Library is here: 
#  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.NMME/.NASA-GEOSS2S/.FORECAST/.MONTHLY/
#

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $lcldir = '/Data/data23/NMME/NASA_GEOSS2S.D/Forecast.D/'; 
#my $host = 'gmaoftp.gsfc.nasa.gov';				#ftp host
my $host = 'gmao.gsfc.nasa.gov';				#https host
my $remotedir = qw(/gmaoftp/gmaofcst/seasonal/GEOSS2S-2_1/NMME/forecast/monthly/);               #array of directories
#my $remotedir = qw(/gmaoftp/knakada/GEOSS2S-2_1/NMME/forecast/monthly/);               #array of directories
#my $remotedir = qw(/pub/data/zli/GEOSS2S/forecast/);               #array of directories
@datelist = ();
@newfiles = ();

# assign a two-digit month number for current month in which script is run to $curmon
#$curmon = "02";
$curmon = `date +%m`;
$curyr = `date +%Y`;
chomp $curmon;
chomp $curyr;

# define a variable for the previous year for the case when the forecast start month is
# January, but the files (and "$lastdate variable) are dated 27 December of the previous year
$curyrminus1 = $curyr - 1;
chomp $curyrminus1;

# convert two-digit month number to lowercase month abbr. and assign to %monname
%monname = qw(01 jan 02 feb 03 mar 04 apr 05 may 06 jun 07 jul 08 aug 09 sep 10 oct 11 nov 12 dec);
$remcurmon = $monname{$curmon};

# convert two-digit month number to 3-letter month abbr. and assign to $nmon

%monabbr = qw(01 Jan 02 Feb 03 Mar 04 Apr 05 May 06 Jun 07 Jul 08 Aug 09 Sep 10 Oct 11 Nov 12 Dec);
$nmon = $monabbr{$curmon};

$localmondir = "$nmon" . ".D";
chomp $localmondir;

$remcurmondir = "$curyr/" . "$remcurmon/";
chomp $remcurmondir;

print "$localmondir\n";

print "$remcurmondir\n"; 

# get monthly files

chdir "/Data/data23/NMME/NASA_GEOSS2S.D/Forecast.D/$localmondir" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

#https://gmao.gsfc.nasa.gov/gmaoftp/gmaofcst/seasonal/GEOSS2S-2_1/NMME/forecast/monthly/2018/apr/

@newfiles =  system ("wget -A '*1x1_precip_ens*.nc' -o wget_GMAO_log.txt -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles2 =  system ("wget -A '*1x1_sst_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles3 =  system ("wget -A '*1x1_tref_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles4 =  system ("wget -A '*1x1_evap_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles5 =  system ("wget -A '*1x1_h250_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles10 =  system ("wget -A '*1x1_h500_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles6 =  system ("wget -A '*1x1_runoff_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles7 =  system ("wget -A '*1x1_t2mmax_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles8 =  system ("wget -A '*1x1_t2mmin_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles9 =  system ("wget -A '*1x1_mrsov_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles11 =  system ("wget -A '*1x1_taux_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles12 =  system ("wget -A '*1x1_tauy_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles13 =  system ("wget -A '*1x1_h200_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");

 @newfiles14 =  system ("wget -A '*1x1_ssh_ens*.nc' -N -r -l1 -e robots=off --no-check-certificate --no-parent -nd https://$host$remotedir$remcurmondir");


#@newfiles =  getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_precip_ens\d\d.nc$)/);

#@newfiles2 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_sst_ens\d\d.nc$)/);

#@newfiles3 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_tref_ens\d\d.nc$)/);

#@newfiles4 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_evap_ens\d\d.nc$)/);

#@newfiles5 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_h250_ens\d\d.nc$)/);

#@newfiles10 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_h500_ens\d\d.nc$)/);

#@newfiles6 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_runoff_ens\d\d.nc$)/);

#@newfiles7 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_t2mmax_ens\d\d.nc$)/);

#@newfiles8 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_t2mmin_ens\d\d.nc$)/);

#@newfiles9 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_mrsov_ens\d\d.nc$)/);

#@newfiles11 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_taux_ens\d\d.nc$)/);

#@newfiles12 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_tauy_ens\d\d.nc$)/);

#@newfiles13 = getdatafiles("https://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_h200_ens\d\d.nc$)/);

#@newfiles = qw(20150126_1x1_precip_ens04.nc 20150131_1x1_precip_ens05.nc 20150131_1x1_precip_ens06.nc);
#
# 2018-07-26 15:34:04 (9.00 MB/s) - “20180615_1x1_precip_ens01.nc” saved [4713769/4713769]

open(in1,"wget_GMAO_log.txt") || die "Couldn't open wget_GMAO_log.txt for reading: $!";

while(<in1>){
 if(m/saved/){
  if(m/(\d\d\d\d\d\d\d\d)_1x1_precip_ens\d\d.nc/) { 
   push(@datelist,$1);
  } # end if
 } # end if
}  # end while

close(in1);

print "@datelist\n";

@sorteddates = sort by_number @datelist;

$lastdate = $sorteddates[-1];
chomp $lastdate;

if($lastdate =~ m/(\d\d\d\d)(\d\d\d\d)$/) {
 $lastdateyr = $1;
 $lastdatemonda = $2; 
 chomp $lastdateyr;
 chomp $lastdatemonda;
 print "$lastdateyr\n";
 print "$lastdatemonda\n";
}

#translate mmdd in last ensemble member filename (sometimes a date late in the previous month) to latest start month in mm
%datetrans = qw(1227 01 0131 02 0225 03 0327 04 0426 05 0531 06 0630 07 0730 08 0829 09 0928 10 1028 11 1127 12);
$lastdatemon = $datetrans{$lastdatemonda};
chomp $lastdatemon;
print "$lastdatemon\n";

chdir "/Data/data23/NMME/NASA_GEOSS2S.D/Forecast.D" or die "Couldn't change local directory! (2)\n";

# write date of current update month to a file to hold the end date as Mmm YYYY format and read this from index.tex file
if(($lastdatemon == $curmon) && ($lastdateyr == $curyr)) {
 open(out1,">endmonth.txt") || die "Couldn't write to endmonth.txt: $!";
  print out1 "\\begin{ingrid}\n";
  print out1 "$nmon $curyr\n";
  print out1 "\\end{ingrid}\n";
 close(out1);

 open(out2,">fileavailendyr.txt") || die "Couldn't write to fileavailendyr.txt: $!";
  print out2 "\\begin{ingrid}\n";
  print out2 "$curyr\n";
  print out2 "\\end{ingrid}\n";
 close(out2);
} elsif (($lastdatemon == 01) && ($curmon == 01) && ($lastdateyr == $curyrminus1)) {
 open(out1,">endmonth.txt") || die "Couldn't write to endmonth.txt: $!";
  print out1 "\\begin{ingrid}\n";
  print out1 "$nmon $curyr\n";
  print out1 "\\end{ingrid}\n";
 close(out1);

 open(out2,">fileavailendyr.txt") || die "Couldn't write to fileavailendyr.txt: $!";
  print out2 "\\begin{ingrid}\n";
  print out2 "$curyr\n";
  print out2 "\\end{ingrid}\n";
 close(out2);
}

sub by_number {
  if ($a < $b) {
   return -1;
  } elsif ($a == $b) {
   return 0;
  } elsif ($a > $b) {
   return 1;
  }
}

exit;
