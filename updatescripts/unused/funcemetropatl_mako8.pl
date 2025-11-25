#!/usr/bin/perl -w

#script accesses FUNCEME site and uses runtime date of script to check 
#for amalgamated file that contains data from the previous month (for
#each variable (SST, X pseudo-stress and Y pseudo-stess) and for full
#field and anomaly.

#download each file if found, send the full file name
#as an argument to each fortran program that will process the data file
#and output a binary file for each variable

#use date in file name to update date in index.tex file (will need to
#use a date from a file name assoc. with just one of the variables
#to represent them all.)

use LWP::Simple qw($ua getstore get is_success is_error);
use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;

my $host = 'www3.funceme.br';

my $directory = qw(/pirata/donnees/);

$local="/Data/data3/funceme/tropatl";
$indextex="/Data/data1/DataCatalog/entries/FUNCEME/Tropical_Atlantic/monthly";
$gnudate="/bin/date";

chdir "/Data/data3/funceme/tropatl" or die "Couldn't chdir to output directory\n";

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

 $ua->timeout(100);
 my $respsst = getstore("http://$host$directory$sstfil", 'sst.txt');

 if(is_success($respsst)) {
   print "Successfully retrieved $sstfil as sst.txt\n";
   ++$i;
 } else {
   print "Error $respsst .  Didn't get $sstfil\n";
 }

 $ua->timeout(100);
 my $respssta = getstore("http://$host$directory$sstafil", 'sstanom.txt');

 if(is_success($respssta)) {
   print "Successfully retrieved $sstafil as sstanom.txt\n";
   ++$i;
 } else {
   print "Error $respssta .  Didn't get $sstafil\n";
 }

 $ua->timeout(100);
 my $resppwsx = getstore("http://$host$directory$pwsxfil", 'pwsx.txt');

 if(is_success($resppwsx)) {
   print "Successfully retrieved $pwsxfil as pwsx.txt\n";
   ++$i;
 } else {
   print "Error $resppwsx .  Didn't get $pwsxfil\n";
 }

 $ua->timeout(100);
 my $resppwsxa = getstore("http://$host$directory$pwsxafil", 'pwsxanom.txt');

 if(is_success($resppwsxa)) {
   print "Successfully retrieved $pwsxafil as pwsxanom.txt\n";
   ++$i;
 } else {
   print "Error $resppwsxa .  Didn't get $pwsxafil\n";
 }

 $ua->timeout(100);
 my $resppwsy = getstore("http://$host$directory$pwsyfil", 'pwsy.txt');

 if(is_success($resppwsy)) {
   print "Successfully retrieved $pwsyfil as pwsy.txt\n";
   ++$i;
 } else {
   print "Error $resppwsy .  Didn't get $pwsyfil\n";
 }

 $ua->timeout(100);
 my $resppwsya = getstore("http://$host$directory$pwsyafil", 'pwsyanom.txt');

 if(is_success($resppwsya)) {
   print "Successfully retrieved $pwsyafil as pwsyanom.txt\n";
   ++$i;
 } else {
   print "Error $resppwsya .  Didn't get $pwsyafil\n";
 }

if($i == 6) {
  system("mv sst.r4 sst.r4.old; mv sstanom.r4 sstanom.r4.old; mv pwsx.r4 pwsx.r4.old; mv pwsxanom.r4 pwsxanom.r4.old; mv pwsy.r4 pwsy.r4.old; mv pwsyanom.r4 pwsyanom.r4.old");
  system("./readtropatl_mako8 $nyr $nmondig");  
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

