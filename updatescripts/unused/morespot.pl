#! /usr/bin/perl
# run in /local3/datatransfer/getspot

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";
my ($user, $passwd) = get_credential("vgt_vito");

chdir "/Data/data21/cnes/spot/scratch" or die "Couldn't chdir to output directory\n";
# table of prefixes
%stable = (
	   Africa => "af",
	   africa => "af",
	   "W-Asia" => "wa",
	   "N-Asia" => "as",
	   "SE-Asia" => "se",
"N-America" => "na",
"Central-America" => "ca",
"S-America" => "sa",
"Asian-Islands" => "ai",
"Australasia" => "au",
"Europe" => "eu",
	   );
# table of directory names
%ltable = (
	   Africa => "africa",
	   africa => "africa",
	   "N-Asia" => "nasia",
	   "W-Asia" => "wasia",
	   "SE-Asia" => "seasia",
	   "N-America" => "namerica",
	   "Central-America" => "camerica",
	   "S-America" => "samerica",
	   "Asian-Islands" => "aislands",
	   "Australasia" => "austasia",
	   "Europe" => "europe",
	   );
# table of dataset names
%dstable = (
	   Africa => "africa",
	   africa => "africa",
	   "N-Asia" => "north-asia",
	   "W-Asia" => "west-asia",
	   "SE-Asia" => "south-easia",
	   "N-America" => "north-america",
	   "Central-America" => "central-america",
	   "S-America" => "south-america",
	   "Asian-Islands" => "aisian-islands",
	   "Australasia" => "australia-asia",
	   "Europe" => "europe",
	   );
# reverse table: directory to source names
%otable = (
	   "africa" => "Africa",
           "nasia" => "N-Asia",
           "wasia" => "W-Asia",
           "seasia" => "SE-Asia",
	   "namerica" => "N-America",
	   "camerica" => "Central-America",
	   "samerica" => "S-America",
	   "aislands" => "Asian-Islands",
	   "austasia" => "Australasia",
	   "europe" => "Europe",
	   );
# dekad to date
%dates = (
	  1 => 1,
	  2 => 11,
	  3 => 21,
	  );
# source name to option number
%nROIs = (
"Africa" => "0",
"N-America" => "1",
"Central-America" => "2",
"S-America" => "3",
"N-Asia" => "4",
"W-Asia" => "5",
"SE-Asia" => "6",
"Asian-Islands" => "7",
"Australasia" => "8",
"Europe" => "9",
	 );
# year to option number (now set in getyearoptions)
#%yeartooption = (
#		 1998 => "0",
#		 1999 => "1",
#		 2000 => "2",
#		 2001 => "3",
#		 2002 => "4",
#		 2003 => "5",
#		 2004 => "6",
#		 ) ;
# day to option number
%daytooption = (
	  1 => "0",
	  11 => "1",
	  21 => "2",
	  );

use POSIX "ctime";
require LWP::UserAgent;
use HTTP::Request::Common qw(POST);
use HTTP::Cookies;
# creates web access object
$ua = new LWP::UserAgent;
$ua->cookie_jar(HTTP::Cookies->new(file => "lwpcookies.txt",autosave => 1));

#$url = "http://free.vgt.vito.be/login.php";
#$req= HTTP::Request->new(GET =>$url);
#$res = $ua->request($req);
#$page=$res->content;
#print $page;

# main program
&login;
&homepage;
print "downloaded $downloaded files\n";
if ($freespace < 0){
    print "over limit\n";
}
if($downloaded == 0 && $freespace > 0){
    &getyearoptions;
    &checkfornew;
    &homepage;
print "downloaded $downloaded files\n";
}
if($occupiedspace){
    print "Occupied space is $occupiedspace.\n";
}
if($freespace){
    print "Free space is $freespace.\n";
}
exit;

sub login {
#Sets Cookie by logging in

$req = POST 'http://free.vgt.vito.be/login.php',[ EMAIL => $user, PASSWORD => $passwd ];

$res = $ua->request($req);
$page=$res->as_string;
#print $page;
}
sub homepage {
# gets home page
$url = "http://free.vgt.vito.be/home.php";
$req= HTTP::Request->new(GET =>$url);
$res = $ua->request($req);
$page=$res->content;
#print $page;
$downloaded=0;
$freespace="";
$occupiedspace="";
while($page=~/<a href=\"([^\"]+\.ZIP)">/g){
$url = "http://free.vgt.vito.be/$1";
$url =~ /\/([^\/]+ZIP)/;
$filename = $1;
$filename =~ /([^_]+)__(..)(..)(..)(..)_([^_]+)__([^_]+).ZIP/;
$dataname = $1;
$year = "$2$3";
$syear= "$3";
$month = $4;
$day = $5;
$mdekad = 1+($day - 1 )/10;
$var = $6;
$oplace = $7;
$place=$ltable{"$oplace"};
if (!$place){
print "need to add $oplace to ltable list\n";
exit;
}
#if ($place eq "africa"){
#$rootdir = "/Data/data1/iri/applications/vobsomer";
#$var = ".";
#}
#else {
$rootdir = "/Data/data21/cnes/spot/data";
#}
if ( ! -e "$rootdir/$place/$var/spot/binfiles/" ){
system "mkdir -p $rootdir/$place/$var/spot/binfiles/";
}
$splace = "da";
$splace= $stable{"$oplace"};
if (!$splace){
print "need to add $oplace to stable list\n";
exit;
}
$newfilename="$rootdir/$place/$var/spot/binfiles/$splace$syear$month$mdekad.bin";
if ( -e $newfilename ) {
print "have $newfilename\n";
}
else {
if ( -e $filename ) {
print "need $newfilename from $filename\n";
}
else {
print "need $newfilename from $url\n";
$req= HTTP::Request->new(GET =>$url);
$res = $ua->request($req,$filename);
}
system "unzip $filename 0001/0001_NDV.HDF";
if ( -e "0001/0001_NDV.HDF" ){
system "../hdp dumpsds -d -o $newfilename -b 0001/0001_NDV.HDF";
system "rm -r 0001";
system "ls -l $newfilename";
$downloaded += 1;
}
else {
print "file not created";
}
}
}
if($page =~/The total size of your active products is +([^ ]+ [MG]?B)/){
$occupiedspace = "$1";
}
if($page =~/There is +([^ ]+ [MG]?B) free space to add new products./){
$freespace = "$1";
}
}

sub getyearoptions {
# gets form for requesting data
$url = "http://free.vgt.vito.be/query.php";
$req= HTTP::Request->new(GET =>$url);
$res = $ua->request($req);
$page=$res->content;
#print $page;
if($page =~ /<select name="TO_YEAR">(.+)<\/select><select name="TO_MONTH">/){
    $yearoptions=$1;
    while($yearoptions =~/<option value="(\d+)">(\d+)<\/option>/g){
	print "adding option $1 for $2\n";
	$yeartooption{"$2"} = $1;
}
}
}
sub checkfornew {
#figures out what is needed.
$rootdir = "/Data/data21/cnes/spot/data/";
print "figures out what is needed\n";
opendir topdir, $rootdir;
@allplaces= grep !/^\.\.?$/, readdir topdir;
closedir topdir;
foreach $place (@allplaces){
    $oplace = $otable{"$place"};
    if(!$oplace){
	next;
    }
    print "$oplace ($place)\n";
opendir vardir, "$rootdir/$place";
@allvars = grep !/^\.\.?$/, readdir vardir;
    closedir vardir;
foreach $var (@allvars){
    print "$var ";
if ( -e "$rootdir/$place/$var/spot/binfiles/" ){
opendir timedir, "$rootdir/$place/$var/spot/binfiles/";
    $maxtday=1;
    $maxtmon=1;
    $maxtyear=1998;
    while ($timefile = readdir timedir){
	if($timefile =~ /..(\d\d)(\d\d)(\d)\.bin/){
	    $syear=$1;
	    $month=$2;
	    $dekad=$3;
	    if($syear>97){
		$year="19$syear";
	    }
	    else {
		$year="20$syear";
	    }
	    $day = $dates{"$dekad"};
	    if($year>$maxtyear){
		$maxtday=$day;
		$maxtmon=$month;
		$maxtyear=$year;
	    }
	    elsif($year == $maxtyear){
		if($month > $maxtmon){
		    $maxtday=$day;
		    $maxtmon=$month;
		}
		elsif($month == $maxtmon){
		    if($day > $maxtday){
			$maxtday=$day;
		    }
		}
	    }
    }
    }
    closedir timedir;
    print "have until $maxtday $maxtmon $maxtyear ";
    $nexttday = $maxtday;
    $nexttmon = $maxtmon;
    $nexttyear = $maxtyear;
    if($nexttday < 21){
	$nexttday += 10;
    }
    else {
	$nexttday = "01";
	if ($nexttmon < 12){
	    $nexttmon += 1;
	}
	else {
	    $nexttmon = 1;
	    $nexttyear +=1;
	}
    }
}
else {
# start from the beginning
$nexttday = "01";
$nexttmon = "4";
$nexttyear = "1998";
}

    $nROI = $nROIs{"$oplace"};
    print "start with $nexttday $nexttmon $nexttyear\n";
    $frommonoption=$nexttmon-1;
    $req = POST 'http://free.vgt.vito.be/result.php',[ TYPE => '0', INSTRUMENT => '0', FORMAT => '0', ROI => "$nROI", FROM_YEAR => $yeartooption{"$nexttyear"}, FROM_MONTH => "$frommonoption", FROM_DAY => $daytooption{"$nexttday"}, TO_YEAR => $yeartooption{"$nexttyear"}, TO_MONTH => "11", TO_DAY => "2" ];
$res = $ua->request($req);
$page=$res->content;
    %newids= ();
#    print $page;
    $foundone="";
while($page=~/<input name="([^"]+)"/g){
$id = $1;
if($id ne "SelectAll"){
$newids{$id}="on";
$foundone="1";
}
}
if($foundone){
    $req = POST 'http://free.vgt.vito.be/activate.php',[%newids];

$res = $ua->request($req);
$page=$res->content;
    if($page=~/There is not enough free space/){
print "There is not enough free space to add more\n";
}
else {
	%confirmid= ();
	foreach $id (keys %newids){
	    $confirmid{$id} = "1";
	}
	$confirmid{"CONFIRMED"}="1";
	$req = POST 'http://free.vgt.vito.be/activate.php',[%confirmid];

	$res = $ua->request($req);
	$page=$res->as_string;
#print $page;
print "has been confirmed.\n";
    }
}
else {
print "no new datasets found.\n"
}
}
}
}


