#!/usr/bin/perl -w

#Script to quickly download data for Models NMME NASA-GMAO-062012 MONTHLY
#Modified from script created to download MONTHLY CDAS
#Jul 30, 2012

# test this script in home directory

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $lcldir = '/data/dstore4/iri/modelling/datag/NMME_Data.D/NASA_GMAO_062012.D/'; 
my $host = 'gmaoftp.gsfc.nasa.gov';				#ftp host
my $remotedir = qw(/pub/data/zli/NMME/forecast/);               #array of directories
@datelist = ();
@newfiles = ();

# assign a two-digit month number for current month in which script is run to $curmon
$curmon = "10";
chomp $curmon;

# convert two-digit month number to lowercase month abbr. and assign to %monname
%monname = qw(01 jan 02 feb 03 mar 04 apr 05 may 06 jun 07 jul 08 aug 09 sep 10 oct 11 nov 12 dec);
$remcurmon = $monname{$curmon};

# convert two-digit month number to 3-letter month abbr. and assign to $nmon

%monabbr = qw(01 Jan 02 Feb 03 Mar 04 Apr 05 May 06 Jun 07 Jul 08 Aug 09 Sep 10 Oct 11 Nov 12 Dec);
$nmon = $monabbr{$curmon};

$localmondir = "$nmon" . ".D";
chomp $localmondir;

$remcurmondir = "$remcurmon/";
chomp $remcurmondir;

print "$localmondir\n";

print "$remcurmondir\n"; 

# get monthly files

chdir "/data/dstore4/iri/modelling/datag/NMME_Data.D/NASA_GMAO_062012.D/$localmondir" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

 @newfiles =  getdatafiles("ftp://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_precip_ens\d\d.nc$)/);

 @newfiles2 = getdatafiles("ftp://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_sst_ens\d\d.nc$)/);

 @newfiles3 = getdatafiles("ftp://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d\d\d_1x1_tref_ens\d\d.nc$)/);

##@newfiles = qw(20120201.1x1.precip_ens01.nc 20120301.1x1.precip_ens01.nc);

#if(@newfiles) {

# foreach $fil (@newfiles) {
#    if($fil =~ /(\d\d\d\d\d\d)01.1x1.precip_ens01.nc/) {
#        push(@datelist,$1);
#    }
# }

#}  # end if(@newfiles)

exit;
