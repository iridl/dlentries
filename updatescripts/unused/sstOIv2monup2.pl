#! /usr/freeware/bin/perl -w
#$mondir="pub/cmb/sst/oimonth_v2";
$local="/Data/data3/ocean/nmc/RSOIver2/monthly";
$indextex="/Data/data1/DataCatalog/entries/NOAA/NCEP/EMC/CMB/GLOBAL/Reyn_SmithOIv2/monthly";
$gnudate="/ClimateGroup/network/gnu/bin/date";

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

chdir "/Data/data3/ocean/nmc/RSOIver2/monthly";

open(in0,"$indextex/index.tex");
 while(<in0>){
  if(m/enddate/){
   $lastdatestuff = $_; 
   if($lastdatestuff=~m/(\d\d) (...) (\d\d\d\d) ensotime %enddate/){
   $da = $1;
   $mon = $2;
   $yr = $3;
}
  }
 }
close(in0);

$plus1 = "+1 month";
$nextdate =`$gnudate -d "$da $mon $yr $plus1" +%Y%m`;
$nmon =`$gnudate -d "$da $mon $yr $plus1" +%b`;
$nyr =`$gnudate -d "$da $mon $yr $plus1" +%Y`; 
chomp $nextdate;
chomp $nmon;
chomp $nyr;
print "$nextdate\n"; 

$nextfile = "oiv2mon." . $nextdate . ".gz";
chomp $nextfile;
$nextfileuz = "oiv2mon." . $nextdate;
chomp $nextfileuz;
print "$nextfile\n";

open(in4,"$local/filelist");
 while(<in4>){
  if(m/$nextfileuz/){
    print "Monthly SST update -- Reynolds and Smith OI v.2\n";
    print "Already have $newfile.  No need to update.  Stopping.\n";
   exit;
  }
 }
close(in4);

#foreach $newfileuz (getdatafiles("ftp://ftpprd.ncep.noaa.gov/pub/cmb/sst/oimonth_v2/",qr/oiv2mon\.\d\d\d\d\d\d.gz$/)){
foreach $newfileuz (getdatafiles("ftp://ftp.emc.ncep.noaa.gov/cmb/sst/oimonth_v2/",qr/oiv2mon\.\d\d\d\d\d\d.gz$/)){

#continue here with commands that follow once the file
#has been obtained from the CPC website.  For example,
#now run the fortran program that updates the binary
#data files, and then update the appropriate index.tex
#files, etc.
  system("./monupdate $newfileuz");
  $check="1";
  system("gzip $newfileuz");
  if($newfileuz eq $nextfileuz){
#     $nyr=$1;
#     $nmond=$2;
#     $newdate="$nyr-$nmond";
  print "Updating catalog entry to $nextdate.\n";
  open(in2,"$indextex/index.tex");
  open(out4,">tmp");
  while(<in2>){
   if(m/enddate/){
    s/^.* ensotime/16 $nmon $nyr ensotime/;
   }
   print out4;
  }
  close(in2);
  close(out4);
  system("cp $indextex/index.tex index.tex.old; mv tmp $indextex/index.tex");
  system("chmod 644 $indextex/index.tex");
  system("/hosts/omarkov/usr2/alexeyk/local/xHSST/mkxHSST2.sh $nmon $nyr");
  }
}
if(!$check) {
  print "Monthly SST update -- Reynolds and Smith OI v.2\n";
  print "Did not find $nextfile at the CPC.  Try again later.\n";
}
exit;

