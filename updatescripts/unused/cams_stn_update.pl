#! /usr/bin/perl -w
$local="/Data/data5/noaa/cpc/CAMS/station";
$indextexP="/Data/data1/DataCatalog/entries/NOAA/NCEP/CPC/CAMS/station/precipitation";
$indextexT="/Data/data1/DataCatalog/entries/NOAA/NCEP/CPC/CAMS/station/temperature";
$gnudate="/ClimateGroup/network/gnu/bin/date";
$evefiles="/Data/data8/noaa/ncep/eve/datafilesYYYY";

chdir "/Data/data5/noaa/cpc/CAMS/station";

open(in0,"$indextexP/index.tex");
 while(<in0>){
  if(m/enddate/){
   $lastdatestuff = $_;
   $lastdatestuff =~m/(\d\d) (...) (\d\d\d\d) ensotime %enddate/;
   $da = $1;
   $mon = $2;
   $yr = $3;
  }
 }
close(in0);

$plus1 = "+1 month";
$nextdate = `$gnudate -d "$da $mon $yr $plus1" +%Y%m`;
$nmon = `$gnudate -d "$da $mon $yr $plus1" +%b`;
$nrmon = `$gnudate -d "$da $mon $yr $plus1" +%m`;
$nyr = `$gnudate -d "$da $mon $yr $plus1" +%Y`;
chomp $nextdate;
chomp $nmon;
chomp $nrmon;
chomp $nyr;
if($nrmon == 9 ){
 $nextdate = $nyr . '9';
}
print "$nextdate\n";

$newfile = "eve." . $nextdate;
chomp $newfile;
print "$newfile\n";

open(in1,"$local/filelist2");
 while(<in1>){
  if(m/$newfile/){
    print "Monthly CAMS station update\n";
    print "Have already used $newfile.  No need to update. Stopping.\n";
   exit;
  }
 }
close(in1);

open(out3,"|ls $evefiles/eve.* > evelist");
close(out3);

open(in4,"evelist");
 $check = 0;
 while(<in4>){
  print $_;
  if(m/$newfile/){
    print "Monthly CAMS station update\n";
    print "Latest eve file ($newfile) is available\n";
   $check = 1;


   system("cp prec1.direct prec1.direct.old; cp temp1.direct temp1.direct.old");

   system("mv CAMSp1_stn.bin CAMSp1_stn.bin.old; mv CAMSt1_stn.bin CAMSt1_stn.bin.old");

#Put in lines here that check for the beginning of a new year -- when
#the *.direct file adds to its record length by having to add on
#another 12 months' worth of available space.  Check to see if $nmon="Jan",
#then, if so, run the stopgap programs, rename the newly-formed *.direct
#files to prec1.direct and temp1.direct, and continue right on. 

   if($nmon eq "Jan") {
    system("./stopgap_p $evefiles/$newfile; mv prec1.direct.new prec1.direct");
    system("./stopgap_t $evefiles/$newfile; mv temp1.direct.new temp1.direct");
    print "Beginning of new year--running stopgap programs\n";
   }

   system("./updatep1 $evefiles/$newfile; chmod 644 CAMSp1_stn.bin; ./updatet1 $evefiles/$newfile; chmod 644 CAMSt1_stn.bin");

   print "Updating catalog entry to $nextdate.\n";
   open(in2, "$indextexP/index.tex");
    open(out1,">tmpP");
     while(<in2>){
      if(m/enddate/){
       s/^.* ensotime/16 $nmon $nyr ensotime/;
      }
      print out1;
     } 
    close(out1);
   close(in2);

   open(in3, "$indextexT/index.tex");
    open(out2,">tmpT");
     while(<in3>){
      if(m/enddate/){
       s/^.* ensotime/16 $nmon $nyr ensotime/;
      }
      print out2;
     }
    close(out2);
   close(in3);

   system("cp $indextexP/index.tex index.texP.old; mv tmpP $indextexP/index.tex; chmod 644 $indextexP/index.tex");
   system("cp $indextexT/index.tex index.texT.old; mv tmpT $indextexT/index.tex; chmod 644 $indextexT/index.tex");
  open(out6,">>$local/filelist2");
   print out6 "$newfile\n";
  close(out6);
  }
 }
close(in4);

if($check == 0) {
  print "Monthly CAMS station update\n";
  print "Eve file ($newfile) was not yet available.  Try again later.\n";
}
exit;
