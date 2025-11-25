#! /usr/bin/perl -w
#
 use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

$currdate = `date +%d%b%Y`;
chomp $currdate;

print "$currdate\n";

#$currdate = "16Oct2018";

$da = substr($currdate, 0, 2);
chomp $da;

$mon = substr($currdate, 2, 3);
chomp $mon;

$yr = substr($currdate, 5, 4);
chomp $yr;

chdir "/Data/data21/noaa/ncep/cpc/global/daily" or die "Couldn't change local directory! (1)\n";

for($dy = -2; $dy <= 0; $dy++) { 

 $loopyr = `date -d "$da $mon $yr + $dy days" +%Y`;
 print "checking $loopyr\n";

#foreach $file (getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/precip/PEOPLE/wd52ws/global_temp/",qr/CPC_GLOBAL_T_V0.x_0.5deg.lnx.$loopyr/)) {
# CPC_GLOBAL_T_V0.x_0.5deg.lnx.2018
# print "getting $file\n";

  system ("wget -N -r -l1 -e robots=off --no-parent -nd ftp://ftp.cpc.ncep.noaa.gov/precip/PEOPLE/wd52ws/global_temp/CPC_GLOBAL_T_V0.x_0.5deg.lnx.$loopyr"); 
  print "getting $loopyr\n";

#};

};

exit;
