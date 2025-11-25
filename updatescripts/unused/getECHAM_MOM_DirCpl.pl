#!/usr/bin/perl -w

#Script to update Models NMME IRI-ECHAM4p5-DirectCoupled MONTHLY
#Modified from script created to download MONTHLY CDAS
#May 15, 2012

# test this script in home directory

 use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";
my $texdir = '/Data/data1/DataCatalog/entries/Models/NMME/IRI-ECHAM4p5-DirectCoupled/MONTHLY/';
my $lcldir = '/data/dstore4/iri/modelling/daved/BlueFin.D/ECHAM4.5_MOM3DirCpl2.D/EXP.D/TestCpl1b.D/Forecast_FullCoup_TauTaper4_KPPDiur_SfcCurr.D/PutTogPost.D/NMME_AllEns_ForDL.D/'; 
my $host = 'nino.ldeo.columbia.edu';				#ftp host
my $remotedir = qw(/pub/daved/NMME.D/RealTime.D/DirectCoupled.D/);               #array of directories
@datelist = ();
@newfiles = ();

# assign two-digit month number for current month in which script is run to $curmon
$curmon = `date +%m`;
chomp $curmon;

$curdate = `date +%Y%m`;
chomp $curdate;

# convert two-digit month number to 3-letter month abbr. and assign to $nmon
%monabbr = qw(01 Jan 02 Feb 03 Mar 04 Apr 05 May 06 Jun 07 Jul 08 Aug 09 Sep 10 Oct 11 Nov 12 Dec);
$nmon = $monabbr{$curmon};

$localmondir = "$nmon" . ".D";
chomp $localmondir;

print "$curdate\n";
print "$curmon\n";
print "$nmon\n";
print "$localmondir\n";

# get monthly files

chdir "/data/dstore4/iri/modelling/daved/BlueFin.D/ECHAM4.5_MOM3DirCpl2.D/EXP.D/TestCpl1b.D/Forecast_FullCoup_TauTaper4_KPPDiur_SfcCurr.D/PutTogPost.D/NMME_AllEns_ForDL.D/$localmondir" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

#$curmondir = "$curmon" . "/";

#print "$curmondir\n";

@newfiles =  getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d\d\d01.1x1.precip_ens\d\d.dat$)/);

@newfiles2 = getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d\d\d01.1x1.sst_ens\d\d.dat$)/);

@newfiles3 = getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d\d\d01.1x1.t2m_ens\d\d.dat$)/);

#@newfiles = qw(20120501.1x1.precip_ens01.dat);

if(@newfiles) {

 foreach $fil (@newfiles) {
    if($fil =~ /(\d\d\d\d\d\d)01.1x1.precip_ens01.dat/) {
        push(@datelist,$1);
    }
 }

 print "@newfiles\n";
 print "@datelist\n";

 $lastdate = $datelist[-1];

 $yr = substr($lastdate, 0, 4);
 $mo = substr($lastdate, 4, 2);
 chomp $mo;

 print "Updating catalog entry to $lastdate.\n";

$texmon = $monabbr{$mo};

 print "$texmon\n";
 print "$yr\n";
 print "$lastdate\n";

%monnum = qw(Jan 01 Feb 02 Mar 03 Apr 04 May 05 Jun 06 Jul 07 Aug 08 Sep 09 Oct 10 Nov 11 Dec 12);

open(in0,"$texdir/index.tex");
 while(<in0>){
  if(m/1 (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d\d\d\d) ensotime %enddate/) {
   $oldmon = $monnum{$1};
   $texdat = "$2" . "$oldmon";
  }
 }
close(in0); 

chomp $texdat;

print "$texdat\n";

if($lastdate > $texdat) {
 open(in1,"$texdir/index.tex");
 open(out1,">tmp");
 while(<in1>){
  if(m/enddate/){
   s/^.* ensotime/1 $texmon $yr ensotime/;
  }
  print out1;
 }
 close(in1);
 close(out1);
 }  # end if($lastdate > $texdat)

 system("cp $texdir/index.tex index.tex.old; mv tmp $texdir/index.tex");
 system("chmod 644 $texdir/index.tex");

}  # end if(@newfiles)

exit;
