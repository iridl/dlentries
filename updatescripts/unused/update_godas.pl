#!/usr/bin/perl
#Script updates new and modified GODAS data files
#EKG 24 Sep 2004

if( -e "/opt/sfw/bin/date") {
$GNUDATE = "/opt/sfw/bin/date";
}
elsif(-e "/ClimateGroup/network/gnu/bin/date"){
$GNUDATE = "/ClimateGroup/network/gnu/bin/date";
}
else {
$GNUDATE = "date";
}

use LWP::Simple;
use LWP::UserAgent;
use HTTP::Response;
use HTTP::Request;
use HTTP::Date;
use File::Listing;

# only runs if expiration time is passed
	my $ua = LWP::UserAgent->new();
	$ua->agent("IRI Data Library");
	my $req = HTTP::Request->new(GET => "http://iridl.ldeo.columbia.edu/expert/SOURCES/.CMA/.BCC/.GODAS/");

	$res = $ua->request($req);
$oldtime= $res->header('Expires');
    $expires = `$GNUDATE -d "$oldtime" +"%s"`;
chop $expires;
if($expires > time){
    exit;
}

chdir("/beluga/data/datag/CMA/BCC/GODAS/");
@filenames=();
my $url = 'http://ncc.cma.gov.cn/to_iri_updated/';			#url for data
system ("/usr/freeware/bin/wget --cache=off -o wget_output $url");
open (filelist, "index.html");

while ($line=<filelist>) {
	if ($line=~/(bccocn2\d{5}\.dat)/) { push (@filenames,$1); }	#@filenames contains all data files available on website
}
for $filename (@filenames) {
	my $filepath="$url$filename";
	my ($type, $length, $mtime) = head($filepath);	#get mod time of file on website -> used for reassignment after download

	$modtime = (stat("$filename"))[10];		#gives modtime the time of last modification of current version of file
	if ($modtime == 0) {$modtime=1;}		#creates generic modtime so new files will be downloaded

	my $ua = LWP::UserAgent->new();
	$ua->agent("IRI Data Library");
	my $req = HTTP::Request->new(GET => $filepath);
	$req->header('If-Modified-Since' =>  HTTP::Date::time2str($modtime+60));
	$res = $ua->request($req,$filename);		#download file based on date of modification
		
	utime $mtime, $mtime, $filename;		#sets access and modification time to that of original file

	if ($res->is_success()) {
		print "$filename : Latest version has been downloaded.\n";
	}
	else {
		print "$filename : File has not been modified or operation failed.\n";
	}
}							#end filename loop
system ("rm -f index.html");
