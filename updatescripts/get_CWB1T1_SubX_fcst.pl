#!/usr/bin/perl -w
# Script to update Models SubX CWB1T1 forecast 
# Aug 21, 2018
# Nov 13 2023 - Migrated to dlupdates - jeff turmelle
#
# The contact person at Taiwan Central Weather Bureau (CWB) for this model is Chia-Ling Wu, rensa@cwb.gov.tw
# Tel: +886-2-2349-1318
# Central Weather Bureau
# 64, Gongyuan Road, Taipei 10048, Taiwan (R.O.C.)
#
# Other associated email contacts at CWB are:  Jyh-Wen Hwu <jwhwu@cwb.gov.tw>; rfs19 <rfs19@cwb.gov.tw>; <river@cwb.gov.tw>
#
# This model is not actually an official member of the SubX suite of forecasts, but follows the same conventions.  The 
# model is initialized on Tuesdays, Wednesdays, Fridays, and Sundays each week, but these are released every Thursday. 
#
# See the documentation.txt file in /Data/SubX/CWB/CWB1T1/forecast/ for more information
#
# The data files are downloaded from the following remote ftp location at CWB:
#
# ftp://pds.cwb.gov.tw/575
#
# The data files are downloaded locally to /Data/SubX/CWB/CWB1T1/forecast/ 
#
# The dataset in the Data Library is not with the other SubX datasets in the public Data Library, but rather in mbell's DL space:
#
# http://iridl.ldeo.columbia.edu/home/.mbell/.SubX/.CWB/.CWB1T1/
#
#
use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";

my ($user, $passwd) = get_credential("subx_cwb");

my $lcldir = '/Data/SubX/CWB/CWB1T1/forecast/'; 
my $host = 'pds.cwb.gov.tw';				#ftp host
my $remotedir = '/575';               #array of directories
@datelist = ();
@newfiles = ();
#@newfiles1 = ();

chomp $lcldir;
chomp $remotedir;

# get weekly files

chdir $lcldir or die "Couldn't change local directory! (1)\n";

$whatdir = `pwd`;
print "$whatdir\n";

@newfiles =  system ("wget --ftp-user=$user --ftp-password=$passwd --no-check-certificate -A '*.grb' -N -r -l1 -e robots=off --no-parent -nd ftp://$host$remotedir/");

system("chmod 644 *.grb");

exit;

