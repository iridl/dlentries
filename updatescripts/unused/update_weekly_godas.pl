#! /usr/freeware/bin/perl -w
$local="/Data/data5/noaa/nmc/leetma/godas/weekly";
$indextex="/Data/data1/DataCatalog/entries/NOAA/NCEP/EMC/CMB/Pacific/godas";
$prog="/Data/data5/noaa/nmc/leetma/godas/weekly/readdata_godas";

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

chdir "$local";

#foreach $newfile (getdatafiles("ftp://ftpprd.ncep.noaa.gov/pub/cmb/Pacific/godas_pac/",qr/ocn\.\d\d\d\d\d\d\d\d$/)){
foreach $newfile (getdatafiles("ftp://ftp.emc.ncep.noaa.gov/cmb/Pacific/godas_pac/",qr/ocn\.\d\d\d\d\d\d\d\d$/)){

    system("$prog $newfile");

  if($newfile =~ /ocn\.(\d\d\d\d)(\d\d)(\d\d)/){
      $nyr=$1;
      $nmon=$2;
      $nday=$3;
      $newdate="$nyr-$nmon-$nday";
  print "Updating catalog entry to $newdate.\n";
  open(in2,"$indextex/index.tex");
  open(out4,">tmp");
  while(<in2>){
   if(m/endday/){
    s/^.* (julian_day|ymd2rjt)/$nyr $nmon $nday ymd2rjt/;
   }
   print out4;
  }
  close(in2);
  close(out4);
  system("cp $indextex/index.tex index.tex.old; mv tmp $indextex/index.tex");
  system("chmod 644 $indextex/index.tex");
  }
}


