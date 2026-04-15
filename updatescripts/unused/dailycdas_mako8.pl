#!/usr/bin/perl
# ------------------
# expecting one filename as argument
# ------------------
$GNUDATE="/bin/date";
require LWP::UserAgent;

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/getdatafiles.pl";

%package = (
PerlMagick => 0,
ImageMagick => 0,
pbmplus => 0,
netpbm => 0,
djpeg => 0,
Ghostscript => 0,
TeX => 0,
dvips => 0,
'libwww-perl' => 1,
jfriedl => 0,
) ;
#$sys="sgi62";
#$sys="sgi51";
# machine that receives the file
$machine="crunch.ldeo.columbia.edu";

$ENV{"http_proxy"}="http://iriproxy.iri.columbia.edu:3128";

my ($user, $passwd) = get_credential("anonymous");

#$ftpdir="pub/incoming";
#$ftpurldir=~s./.%2F.g;
$finaldir="/Data/data6/ncep-ncar/daily/update";

# only runs if expiration time is passed
	my $ua = LWP::UserAgent->new();
	$ua->agent("IRI Data Library");
	my $req = HTTP::Request->new(GET => "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/");

	$res = $ua->request($req);
$oldtime= $res->header('Expires');
    $expires = `$GNUDATE -d "$oldtime" +"%s"`;
chop $expires;
#if($expires > time){
#    exit;
#}

print "Getting Daily CDAS at $now\n";

# wget from http://nomad3.ncep.noaa.gov/pub/reanalysis-1/daily/rotating/

chdir "$finaldir" or die "Couldn't change local directory! (1)\n"; 

# These "system" commands using "wget" will not work due to blocking by NCEP
# system("cd $finaldir;/usr/freeware/bin/wget -A 'grb2d.200?????' -N -r -l1 -e robots=off --no-parent -nd http://nomad3.ncep.noaa.gov/pub/reanalysis-1/daily/rotating/");
#
# system("cd $finaldir;/usr/freeware/bin/wget -A 'pgb.200?????' -N -r -l1 -e robots=off --no-parent -nd http://nomad3.ncep.noaa.gov/pub/reanalysis-1/daily/rotating/");


# begin -- temporary location of data during late Dec 2007 - Jan 2008 nomad3 crash
#
#getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/wd51we/tmp_cdas/rot_daily/",qr/(grb2d.200\d\d\d\d\d$)/);
#
#getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/wd51we/tmp_cdas/rot_daily/",qr/(pgb.200\d\d\d\d\d$)/);
#
# end -- temporary location ... nomad3 crash 

# temporary ftp location of data during loss of NOMADS servers beginning in Sep 2014

getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/wd51we/reanalysis-1/daily/rotating/",qr/(grb2d.20\d\d\d\d\d\d$)/);

getdatafiles("ftp://ftp.cpc.ncep.noaa.gov/wd51we/reanalysis-1/daily/rotating/",qr/(pgb.20\d\d\d\d\d\d$)/);

# end of temporary ftp location 

#getdatafiles("http://nomad3.ncep.noaa.gov/pub/reanalysis-1/daily/rotating/",qr/(grb2d.20\d\d\d\d\d\d$)/);

#getdatafiles("http://nomad3.ncep.noaa.gov/pub/reanalysis-1/daily/rotating/",qr/(pgb.20\d\d\d\d\d\d$)/);


# system("cd /Data/data6/ncep-ncar/daily/prs/ ; ./makelinks.pl");
# system("cd /Data/data6/ncep-ncar/daily/flux/ ; ./makelinks.pl");
# system("cd /Data/data6/ncep-ncar/daily/ ; make -f makefile_mako8 all");
exit;
