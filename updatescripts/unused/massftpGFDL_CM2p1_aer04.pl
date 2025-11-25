#!/usr/bin/perl -w

#Script to quickly download data for Models NMME GFDL-CM2p1_v3p1_aer04 MONTHLY
#Modified from script created to download MONTHLY CDAS
#Jul 24, 2012

# test this script in home directory

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";

my $lcldir = '/data/dstore4/iri/modelling/datag/NMME_Data.D/GFDL_CM2.1_v3.1_aer04.D/'; 
my $host = 'ftp.gfdl.noaa.gov';				#ftp host
my $remotedir = qw(/pub/rgg/Vandendool/);               #array of directories
@datelist = ();
@newfiles = ();

# assign a two-digit month number for current month in which script is run to $curmon
$curmon = "10";
chomp $curmon;

# convert two-digit month number to lowercase full month name and assign to %monname
%monname = qw(01 january 02 february 03 march 04 april 05 may 06 june 07 july 08 august 09 september 10 october 11 november 12 december);
$remcurmon = $monname{$curmon};

# convert two-digit month number to 3-letter month abbr. and assign to $nmon

%monabbr = qw(01 Jan 02 Feb 03 Mar 04 Apr 05 May 06 Jun 07 Jul 08 Aug 09 Sep 10 Oct 11 Nov 12 Dec);
$nmon = $monabbr{$curmon};

$localmondir = "$nmon" . ".D";
chomp $localmondir;

$remcurmondir = "$remcurmon" . "_retrospective_v3.1_aer04/";
chomp $remcurmondir;

print "$localmondir\n";

print "$remcurmondir\n"; 

# get monthly files

chdir "/data/dstore4/iri/modelling/datag/NMME_Data.D/GFDL_CM2.1_v3.1_aer04.D/$localmondir" or die "Couldn't change
local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  getdatafiles("ftp://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d01.1x1.precip_ens\d\d.nc$)/);

@newfiles2 = getdatafiles("ftp://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d01.1x1.sst_ens\d\d.nc$)/);

@newfiles3 = getdatafiles("ftp://$host$remotedir$remcurmondir",qr/(\d\d\d\d\d\d01.1x1.t_ref_ens\d\d.nc$)/);

#@newfiles = qw(20120201.1x1.precip_ens01.nc 20120301.1x1.precip_ens01.nc);

#if(@newfiles) {
#
# foreach $fil (@newfiles) {
#    if($fil =~ /(\d\d\d\d\d\d)01.1x1.precip_ens01.nc/) {
#        push(@datelist,$1);
#    }
# }
#
#}  # end if(@newfiles)

exit;
