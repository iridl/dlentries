#! /bin/env perl
 use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";
# run on iridlc4 

# determine current date and assign to $currdate in the form of ddMmmYYYY
# use substr to pick out and assign to variables the day of month, the month abbreviation, and the year
# Use the date command again using $da, $mon, and $yr as input to assemble the daily directory
# names at ESRL (in the form of YYYYmmdd00), and extract the accumulated precipitation forecast
# file for each of the last 7 days using "getdatafiles".

 $currdate = `date -d "0000" +%d%b%Y`;

#$currdate = "13May2013";

 $da = substr($currdate, 0, 2);

 $mon = substr($currdate, 2, 3);

 $yr = substr($currdate, 5, 4);

#print "$da\n";
#print "$mon\n";
#print "$yr\n";

 chdir ("/Data/data21/noaa/esrl/psd/refcst2/ensemblemean") or die "Couldn't chdir to output directory\n"; 

 for($dy = -20; $dy <= 0; $dy++) {

# begin a loop that starts with -5 and goes to zero.  As
# this loops, assign each successive value to $dy

# make a system call to the date command in each step of the loop
# with the date command in the following form:

   $loopyr = `date -d "0000 $da $mon $yr + $dy days" +%Y`;
   $loopyrmo = `date -d "0000 $da $mon $yr + $dy days" +%Y%m`;
   $loopdate = `date -d "0000 $da $mon $yr + $dy days" +%Y%m%d%H`;

print "checking $loopdate\n";

# use loopdate for each folder in the path for getdatafiles

# system("cd /Data/data21/noaa/esrl/psd/refcst2/ensemblemean;/usr/bin/wget -A 'apcp_sfc_??????????_mean.grib2' -N -r -l2 -t3 -e robots=off --no-parent -nd ftp://ftp.cdc.noaa.gov/Projects/Reforecast2/$loopyr/$loopyrmo/$loopdate/mean/latlon/");

#system("cd /Data/data21/noaa/esrl/psd/refcst;/usr/bin/wget -A 'apcp.refcst_ens.grid.??????.????.nc' -N -r -l2 -t3 -e robots=off --no-parent -nd ftp://ftp.cdc.noaa.gov/Public/reforecast/$loopdate/");
 
#system("cd /Data/data21/noaa/esrl/psd/refcst;/usr/bin/wget -A 'apcp.refcst_ens.grid.??????.????.nc' -N -r -l2 -t3 -e robots=off --no-parent -nd ftp://ftp.cdc.noaa.gov/Public/jsw/refcst/$loopdate/");

    foreach $file (getdatafiles("ftp://ftp.cdc.noaa.gov/Projects/Reforecast2/$loopyr/$loopyrmo/$loopdate/mean/latlon/",qr/apcp_sfc_\d\d\d\d\d\d\d\d\d\d_mean.grib2$/)) {


   print "getting $loopdate\n";

  };

 };

exit;
