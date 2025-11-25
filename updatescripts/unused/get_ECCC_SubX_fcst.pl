#!/usr/bin/perl -w
# Script to update Models SubX CMC ECCC GEPS5 forecasts 
# Jan 25, 2018
# Nov 13 2023 - Migrated to dlupdates - jeff turmelle
#
# The contact person at CMC for this model is Hai Lin, Hai.Lin@canada.ca , Research Scientist, Meteorological Research Division, 
# Environment and Climate Change Canada / Government of Canada, Tel: 514 421-7276
#
# See the documentation.txt file in /Data/SubX/ECCC/GEPS5/documentation.txt for more information
#
# This model's forecasts are initialized and released weekly on Thursdays.  As of 4 July 2019, the real-time forecasts
# are for the GEPS6 version of the model.
#
# The data files are downloaded from the following remote http location at CMC:
#
# All variables:  https://collaboration.cmc.ec.gc.ca/cmc/ensemble/subX/realtime/
#
# The data files are downloaded locally to phoenix to /Data/SubX/ECCC/GEPS6/forecast 
#
# The dataset in the Data Library is here:  http://iridl.ldeo.columbia.edu/SOURCES/.Models/.SubX/.ECCC/.GEPS6/ 
#
# ------
#
# ROMI files based upon CMC ECCC GEPS6 forecasts:
#
# The contact person at Columbia University APAM is Shuguang Wang, sw2526@columbia.edu
#
# The ROMI files are now downloaded from:  http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/
#
# The data files are downloaded locally to phoenix to /Data/SubX/ECCC/GEPS6/ROMI/
#
# --------
#
# More information about the SubX project and each of the models can be found here:
#
# http://cola.gmu.edu/kpegion/subx/index.html
#
#
use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

my $lcldir = '/Data/SubX/ECCC/GEPS7/forecast/'; 
my $host = 'collaboration.cmc.ec.gc.ca';				#http host
my $remotedir = '/cmc/ensemble/subX/realtime/';               #array of directories
@datelist = ();
@newfiles = ();
@newfiles2 = ();
@newfiles20 = ();
@dates = ();

chomp $lcldir;
chomp $remotedir;
chomp $datedir;
chomp $datedirn;

$curdate = `date +%Y%m%d`;
chomp $curdate;

$curdate00 = "$curdate" . '00';
chomp $curdate00;

$startdate = '20211111';
#$startdate = '20180125';
chomp $startdate;

$startdate00 = "$startdate" . '00';
chomp $startdate00;

$checkdate = $startdate;
chomp $checkdate;

$checkdate00 = $startdate00;
chomp $checkdate00;

$plus1 = "+1 week";

$minus8 = "-8 week";

$eightweeksagodate = `date -d "$curdate $minus8" +%Y%m%d`;
chomp $eightweeksagodate; 

print "8 weeks ago was:";
print "$eightweeksagodate\n";

#$ict = 0;

#while (($checkdate00 <= $curdate00) && ($ict < 52)) {
while ($checkdate00 <= $curdate00) {
    #++$ict;
    $nextdate = `date -d "$checkdate $plus1" +%Y%m%d`;
    chomp $nextdate;

    $nextdate00 = "$nextdate" . '00';
    chomp $nextdate00;
    print "$nextdate00\n";

    $checkdate = $nextdate;
    chomp $checkdate;

    $checkdate00 = $nextdate00;
    chomp $checkdate00;
    print "$checkdate00\n";

    if ($nextdate >= $eightweeksagodate) {

	# get weekly files 

	chdir $lcldir or die "Couldn't change local directory! (1)\n";

	$whatdir = `pwd`;
	print "$whatdir\n";

	# $newfiles =  system ("wget --user=anonymous --password=mbell\@iri.columbia.edu -A 'subX_realtime_ECCC*.tar' -N -r -l1 -e robots=off --no-parent -nd https://$host$remotedir$nextdate00/");

	@newfiles = getdatafiles("https://$host$remotedir$nextdate00/",qr/(subX_realtime_ECCC_\d\d\d\d\d\d\d\d00_m\d\d.tar$)/);

	#subX_realtime_ECCC_2018092000_m20.tar

	if(@newfiles) {
	    #    foreach $fil (<subX_realtime_ECCC_*00_m*.tar>) {
	    foreach $fil (@newfiles) {
		if($fil =~ /subX_realtime_ECCC_($nextdate00)_m\d\d.tar/) {
		    system("tar -xvf $fil");
		    system("rm -rf $fil");
		    print "$fil\n";
		}
	    }
	}
    }
} # end of while loop

# download ROMI forecast files
#chdir "/Data/SubX/ECCC/GEPS7/ROMI" or die "Couldn't change local directory! (2)\n";

#$whatdir = `pwd`;
#print "$whatdir\n";

#  ECCC_GEM_2019_02_11.nc 
#  http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/

#@newfiles20 = getdatafiles("http://silence.appmath.columbia.edu/romi_realtime_forecasts/ncfiles/",qr/(ECCC_GEM_\d\d\d\d_\d\d_\d\d.nc$)/);

exit;
