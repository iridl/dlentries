#!/usr/bin/perl -w

#Script to update Models NMME NCAR-CESM1 MONTHLY
#Aug 25, 2016

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

#$gnudate="/ClimateGroup/network/gnu/bin/date";
my $lcldir = '/Data/data23/NMME/CESM1.D/'; 
my $host = 'ftp.cgd.ucar.edu';				#ftp host
my $remotedir = qw(/pub/nmme/);               #array of directories
@datelist = ();
@newfiles = ();

# assign two-digit month number for current month in which script is run to $curmon
#$curmon = "12";

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

chdir "/Data/data23/NMME/CESM1.D/$localmondir" or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

#$curmondir = "$curmon" . "/";

#print "$curmondir\n";

@newfiles =  getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d$curmon\d\d.1x1.Mrsov_ens\d\d.nc$)/);

@newfiles2 = getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d$curmon\d\d.1x1.Tsmin_ens\d\d.nc$)/);

@newfiles3 = getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d$curmon\d\d.1x1.Tsmax_ens\d\d.nc$)/);

@newfiles4 = getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d$curmon\d\d.1x1.precip_ens\d\d.nc$)/);

@newfiles5 = getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d$curmon\d\d.1x1.runoff_ens\d\d.nc$)/);

@newfiles6 = getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d$curmon\d\d.1x1.sst_ens\d\d.nc$)/);

@newfiles7 = getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d$curmon\d\d.1x1.t_ref_ens\d\d.nc$)/);

@newfiles8 = getdatafiles("ftp://$host$remotedir",qr/(\d\d\d\d$curmon\d\d.1x1.z200_ens\d\d.nc$)/);

#@newfiles = qw(20120501.1x1.precip_ens01.nc);

if(@newfiles4) {

 foreach $fil (@newfiles4) {
    if($fil =~ /(\d\d\d\d\d\d)01.1x1.precip_ens01.nc/) {
        push(@datelist,$1);
    }
 }

 print "@newfiles4\n";
 print "@datelist\n";

}  # end if(@newfiles4)


exit;
