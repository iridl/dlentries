#!/usr/bin/perl
use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

$localdir="/Data/data5/noaa/cpc";

chdir "/Data/data5/noaa/cpc/" or die "Couldn't change local directory! (1)\n";

@newfile = getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/wd52dg/data/indices/",qr/tele_index\.nh$/);

#system("make -f makefile_mako8 nhti.cuf");

if(@newfile) {

 open(in0,"$localdir/tele_index.nh") || die "cannot open: $!";
 while(<in0>){
  $lastdate = $_;
  $lastdate =~ m/^(\d\d\d\d .\d)/;
  $yrmon = $1;
 }
 close(in0);

 print "$yrmon\n";

 open(in1,"$localdir/enddate") || die "cannot open: $!";
 open(out1,">$localdir/tmp") || die "cannot open: $!";
 while(<in1>){
  if(m/^\d\d\d\d .\d/){
   s/^\d\d\d\d .\d/$yrmon/;
  }
  print out1;
 }
 close(in1);
 close(out1);
 system("cp $localdir/enddate $localdir/enddate.old; mv $localdir/tmp $localdir/enddate");
 system("chmod 644 $localdir/enddate");

} # end of if there is an update of tele_index.nh

exit;

