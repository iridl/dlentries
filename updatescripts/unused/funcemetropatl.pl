#!/usr/bin/perl -w

#script accesses FUNCEME site and uses runtime date of script to check 
#for amalgamated file that contains data from the previous month (for
#each variable (SST, X pseudo-stress and Y pseudo-stess) and for full
#field and anomaly.

#download each file if found, send the full file name
#as an argument to each fortran program that will process the data file
#and output a binary file for each variable

#use date in file name to update date in index.tex file (will need to
#use a data from a file name assoc. with just one of the variables
#to represent them all.)

use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;

my $browser = LWP::UserAgent->new();

$local="/Data/data3/funceme/tropatl";
$indextex="/Data/data1/DataCatalog/entries/FUNCEME/Tropical_Atlantic/monthly";
$gnudate="/ClimateGroup/network/gnu/bin/date";

chdir "/Data/data3/funceme/tropatl";

open(in0,"$indextex/index.tex");
 while(<in0>){
   if(m/enddate/){
     $lastdatestuff = $_;
     if($lastdatestuff =~ m/(\d\d) (...) (\d\d\d\d) ensotime %enddate/){
       $da = $1;
       $mon = $2;
       $yr = $3;
     }
   }
 }
close(in0);

$plus1 = "+1 month";
$nmon = `$gnudate -d "$da $mon $yr $plus1" +%b`;
$nyr = `$gnudate -d "$da $mon $yr $plus1" +%Y`;
$nyrabrv = `$gnudate -d "$da $mon $yr $plus1" +%y`;
$nmondig = `$gnudate -d "$da $mon $yr $plus1" +%m`;
chomp $nmon;
chomp $nyr;
chomp $nyrabrv;
chomp $nmondig;

$sstfil = "sst64" . $nyrabrv . "b" . $nmondig;
chomp $sstfil;
$sstafil = "anomt64" . $nyrabrv . "b" . $nmondig;
chomp $sstafil;
$pwsxfil = "pwsx64" . $nyrabrv . "b" . $nmondig;
chomp $pwsxfil;
$pwsxafil = "anomx64" . $nyrabrv . "b" . $nmondig;
chomp $pwsxafil;
$pwsyfil = "pwsy64" . $nyrabrv . "b" . $nmondig;
chomp $pwsyfil;
$pwsyafil = "anomy64" . $nyrabrv . "b" . $nmondig;
chomp $pwsyafil;

$i=0;

$respsst = $browser -> mirror("http://www.funceme.br/demet/pirata/donnees/$sstfil", 'sst.txt');

if($respsst->is_success()) {
  print "Successfully retrieved $sstfil as sst.txt\n";
  ++$i; 
} else {
  print "Didn't get $sstfil\n";
}

$respssta = $browser -> mirror("http://www.funceme.br/demet/pirata/donnees/$sstafil", 'sstanom.txt');

if($respssta->is_success()) {
  print "Successfully retrieved $sstafil as sstanom.txt\n";
  ++$i;
} else {
  print "Didn't get $sstafil\n";
}

$resppwsx = $browser -> mirror("http://www.funceme.br/demet/pirata/donnees/$pwsxfil", 'pwsx.txt');

if($resppwsx->is_success()) {
  print "Successfully retrieved $pwsxfil as pwsx.txt\n";
  ++$i;
} else {
  print "Didn't get $pwsxfil\n";
}

$resppwsxa = $browser -> mirror("http://www.funceme.br/demet/pirata/donnees/$pwsxafil", 'pwsxanom.txt');

if($resppwsxa->is_success()) {
  print "Successfully retrieved $pwsxafil as pwsxanom.txt\n";
  ++$i;
} else {
  print "Didn't get $pwsxafil\n";
}

$resppwsy = $browser -> mirror("http://www.funceme.br/demet/pirata/donnees/$pwsyfil", 'pwsy.txt');

if($resppwsy->is_success()) {
  print "Successfully retrieved $pwsyfil as pwsy.txt\n";
  ++$i;
} else {
  print "Didn't get $pwsyfil\n";
}

$resppwsya = $browser -> mirror("http://www.funceme.br/demet/pirata/donnees/$pwsyafil", 'pwsyanom.txt');

if($resppwsya->is_success()) {
  print "Successfully retrieved $pwsyafil as pwsyanom.txt\n";
  ++$i;
} else {
  print "Didn't get $pwsyafil\n";
}

if($i == 6) {
  system("mv sst.r4 sst.r4.old; mv sstanom.r4 sstanom.r4.old; mv pwsx.r4 pwsx.r4.old; mv pwsxanom.r4 pwsxanom.r4.old; mv pwsy.r4 pwsy.r4.old; mv pwsyanom.r4 pwsyanom.r4.old");
  system("./readtropatl $nyr $nmondig");  
  open(in1,"$indextex/index.tex");
  open(out0,">tmp");
  while(<in1>){
    if(m/enddate/){
      s/^.* ensotime/16 $nmon $nyr ensotime/;
    }
    print out0;
  }
  close(in1);
  close(out0);
  system("cp $indextex/index.tex index.tex.old; mv tmp $indextex/index.tex");
  system("chmod 644 $indextex/index.tex");
}

exit;

