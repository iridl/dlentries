#!/usr/bin/perl -w

#Script to update Models NMME COLA-RSMAS-CCSM3 MONTHLY
#Modified from script created to download MONTHLY CDAS
#May 11, 2012
#changed /usr/freeware/bin/perl -w to /usr/bin/perl -w (JdC)

# test this script in home directory

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";
my $texdir = '/Data/data1/DataCatalog/entries/Models/NMME/COLA-RSMAS-CCSM3/MONTHLY/';
my $lcldir = '/Data/data23/NMME/CCSM3.0.D/'; 
#my $host = 'cola.gmu.edu';				#ftp host
my $host = 'decadal.rsmas.miami.edu';				#ftp host
#my $remotedir = qw(/pub/min/HUUG/ccsm3_0_Fcst/);               #array of directories
my $remotedir = qw(/CCSM3_NMME/);               #array of directories
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

chdir "/Data/data23/NMME/CCSM3.0.D/$localmondir" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

$curmondir = "$curmon" . "/";

print "$curmondir\n";

@newfiles =  getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.precip_ens\d\d.nc$)/);

@newfiles2 = getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.sst_ens\d\d.nc$)/);

@newfiles3 = getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.t_ref_ens\d\d.nc$)/);

@newfiles4 = getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.tsmn_ens\d\d.nc$)/);

@newfiles5 = getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.tsmx_ens\d\d.nc$)/);

@newfiles6 = getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.evaporation_ens\d\d.nc$)/);

@newfiles7 = getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.geop200_ens\d\d.nc$)/);

@newfiles8 = getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.runoff_ens\d\d.nc$)/);

@newfiles9 = getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.soilmoist_ens\d\d.nc$)/);

@newfiles10 = getdatafiles("ftp://$host$remotedir$curmondir",qr/(\d\d\d\d\d\d01.1x1.uvel_ens\d\d.nc$)/);

#@newfiles = qw(20120501.1x1.precip_ens01.nc);

if(@newfiles) {

 foreach $fil (@newfiles) {
    if($fil =~ /(\d\d\d\d\d\d)01.1x1.precip_ens01.nc/) {
        push(@datelist,$1);
    }
 }

 print "@newfiles\n";
 print "@datelist\n";

}  # end if(@newfiles)

# index.tex file now uses removeextrausing to set enddate in S grid, so have commented out the section of the
# update script that modifies the enddate in the index.tex file.

# $lastdate = $datelist[-1];

# $yr = substr($lastdate, 0, 4);
# $mo = substr($lastdate, 4, 2);
# chomp $mo;

# print "Updating catalog entry to $lastdate.\n";

#$texmon = $monabbr{$mo};

# print "$texmon\n";
# print "$yr\n";
# print "$lastdate\n";

#%monnum = qw(Jan 01 Feb 02 Mar 03 Apr 04 May 05 Jun 06 Jul 07 Aug 08 Sep 09 Oct 10 Nov 11 Dec 12);

#open(in0,"$texdir/index.tex");
# while(<in0>){
#  if(m/1 (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) (\d\d\d\d) ensotime %enddate/) {
#   $oldmon = $monnum{$1};
#   $texdat = "$2" . "$oldmon";
#  }
# }
#close(in0); 

#chomp $texdat;

#print "$texdat\n";

#if($lastdate > $texdat) {
# open(in1,"$texdir/index.tex");
# open(out1,">tmp");
# while(<in1>){
#  if(m/enddate/){
#   s/^.* ensotime/1 $texmon $yr ensotime/;
#  }
#  print out1;
# }
# close(in1);
# close(out1);
#}  # end if($lastdate > $texdat)

#system("cp $texdir/index.tex index.tex.old; mv tmp $texdir/index.tex");
#system("chmod 644 $texdir/index.tex");


exit;
