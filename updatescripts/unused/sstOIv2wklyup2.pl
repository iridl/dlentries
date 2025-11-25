#! /usr/freeware/bin/perl -w
$local="/Data/data3/ocean/nmc/RSOIver2/weekly";
$indextex="/Data/data1/DataCatalog/entries/NOAA/NCEP/EMC/CMB/GLOBAL/Reyn_SmithOIv2/weekly";
$gnudate="/ClimateGroup/network/gnu/bin/date";

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";


chdir "$local";

open(in0,"$indextex/index.tex");
 while(<in0>){
  if(m/enddate/){
   $lastdatestuff = $_;
   $lastdatestuff=~m/(\d\d\d\d) (\d\d) (\d\d) ymd2rjt %enddate/;

$plus7 = "+ 7 days";
$nextdate =`$gnudate -d "$2/$3/$1 $plus7" +%Y%m%d`;
$nday =`$gnudate -d "$2/$3/$1 $plus7" +%d`;
$nmon =`$gnudate -d "$2/$3/$1 $plus7" +%b`;
$nmond = `$gnudate -d "$2/$3/$1 $plus7" +%m`;
$nyr =`$gnudate -d "$2/$3/$1 $plus7" +%Y`; 
chomp $nextdate;
chomp $nday;
chomp $nmon;
chomp $nmond;
chomp $nyr;
print "$nextdate\n"; 
  }
 }
close(in0);

$nextfile = "oisst." . $nextdate . ".gz";
chomp $nextfile;
$nextfileuz = "oisst." . $nextdate;
chomp $nextfileuz;
print "$nextfile\n";

#foreach $newfileuz (getdatafiles("ftp://ftpprd.ncep.noaa.gov/pub/cmb/sst/oisst_v2/",qr/oisst\.\d\d\d\d\d\d\d\d.gz$/)){
foreach $newfileuz (getdatafiles("ftp://ftp.emc.ncep.noaa.gov/cmb/sst/oisst_v2/",qr/oisst\.\d\d\d\d\d\d\d\d.gz$/)){
  $check = 1;
  system("./wkupdate $newfileuz") && die "wkupdate_oiv2.f did not run
  correctly -- stopping now";

  system("gzip $newfileuz");
  if($newfileuz eq $nextfileuz){
      $newdate="$nyr-$nmond-$nday";
  print "Updating catalog entry to $newdate.\n";
  open(in2,"$indextex/index.tex");
  open(out4,">tmp");
  while(<in2>){
   if(m/enddate/){
    s/^.* (julian_day|ymd2rjt)/$nyr $nmond $nday ymd2rjt/;
   }
   print out4;
  }
  close(in2);
  close(out4);
  system("cp $indextex/index.tex index.tex.old; mv tmp $indextex/index.tex");
  system("chmod 644 $indextex/index.tex");
  }
 }
#close(IN1);
if(!$check) {
  print "Weekly SST update -- Reynolds and Smith OI v.2\n";
  print "Did not find any new files at the CPC.  Try again later.\n";
}
exit;

