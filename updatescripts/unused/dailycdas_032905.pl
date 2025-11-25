#!/usr/bin/perl
# ------------------
# expecting one filename as argument
# ------------------

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";
my ($user, $passwd) = get_credential("anonymous");

$GNUDATE="/ClimateGroup/network/gnu/bin/date";
require LWP::UserAgent;
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

$ftpdir="pub/incoming";
$ftpurldir=~s./.%2F.g;
$finaldir="/Data/data6/ncep-ncar/daily/update";

# only runs if expiration time is passed
	my $ua = LWP::UserAgent->new();
	$ua->agent("IRI Data Library");
	my $req = HTTP::Request->new(GET => "http://iridl.ldeo.columbia.edu/SOURCES/.NOAA/.NCEP-NCAR/.CDAS-1/.DAILY/");

	$res = $ua->request($req);
$oldtime= $res->header('Expires');
    $expires = `$GNUDATE -d "$oldtime" +"%s"`;
chop $expires;
if($expires > time){
    exit;
}

$try=0;
$url="http://ingrid.ldeo.columbia.edu/";
$url="http://nomad2.ncep.noaa.gov/cgi-bin/ftp2u_drot_r1.sh";
#$url="http://wesley.wwb.noaa.gov/cgi-bin/ftp2u_drot_cdas.sh";
for($try=1;$try<10;$try++){
if($try>1){
	sleep 300;
}
$now=localtime(time);
print "Getting Daily CDAS at $now\n";
&geturl($url,$file);
if(!$file){
print "Return code $code from HTTP\n";
#open (larry,"|mail elrosen");
#print larry "Return code $code: 500 means nsadmin probably down on crunch.\n";
#close larry;
}
else
{
    $foundcnt="";
    $parsedcnt=0;
    $foundlist ="";
    while($file=~m/"((grb2d|pgb).\d\d\d\d\d\d\d\d)"/g){
	$parsedcnt +=1;
	$foundfile=$1;
	if(! -f "$finaldir/$foundfile"){
	    if($foundcnt){
		print "Did not already have $finaldir/$foundfile\n";
		$url .= "&";
		$foundcnt +=1;
	    }
	    else {
		$foundcnt=1;
#adds '?' to the url in prep for adding the filenames
    $url .= "?";
	    }
	    $url .= "file=$foundfile";
	    $foundlist .=" $foundfile";
	}
    }
    if($parsedcnt > 0){
    if($foundcnt){
	$url .= "&machine=$machine";
	$url .= "&user=$user";
	$url .= "&passwd=$passwd";
	$url .= "&ftpdir=$ftpdir";
#needs to be changed to results=SAVE and code modified accordingly
	$url .= "&results=FTP";
	$url .= "&prefix=";
	&geturl ($url,$file);
	$count=0;
	while($file=~m/Transfer complete/g){
	    $count=$count+1;
	}
	if($count > 1){
	    print "$count/$foundcnt files transfered\n";
	    print "moving $foundlist\n";
	system("cd /usr/ftp/pub/incoming; mv $foundlist $finaldir");
	system("cd /Data/data6/ncep-ncar/daily/prs/ ; ./makelinks.pl");
	system("cd /Data/data6/ncep-ncar/daily/flux/ ; ./makelinks.pl");
	system("cd /Data/data6/ncep-ncar/daily/ ; pmake all");
	}
    }
    else {
	print "No files needed\n";
    }
	exit;
}
    else {
	print  "$url returned\n$file";
    }
}
}
print "Giving up\n";
exit;
sub geturl {
  local($url)=@_;
  &dbg("Retrieving $url");
  if($package{'libwww-perl'} || $package{'jfriedl'}) {
  &dbg(" using www-perl\n");
    &gu();
    if($code==401) {
      &prompt("\nDocument requires username and password\n\nUsername: ",$user);
      &prompt("Password: ",$pass);
      &gu($user,$pass);
    }
    $_[1]=$cont;
  } elsif(defined $geturl) {
    &dbg("...");
    $_[1]=`$geturl '$url'`;
    if($?) {
      &dbg("\n*** Error opening $url\n");
      return 0;
    }
    &dbg("done\n");
    if($_[1]=~/\r?\n\r?\n/) {
      $_[1]=$';
      $dhead=$`;
      ($code)=$dhead=~/HTTP\/\S+ +(\d+)/i;
      ($contyp)=$dhead=~/Content-type:\s+(.*)/i;
    } else {
      $code=500;
    }
  }
  $_[0]=$url;
  $code<300;
}
sub gu {
  if($package{'libwww-perl'}) {
      require LWP::UserAgent;
#    $ua=LWP::UserAgent->new(timeout => 1000*60);
      $ua=new LWP::UserAgent;
      $ua->timeout(1000*60);
    $req = HTTP::Request->new(GET => $url);
    $req->authorization_basic(@_) if(@_);
    $ua->agent($spoof) if($spoof);
    my $res = $ua->request($req);
    $code=$res->code;
    $contyp=$res->header('content-type');
    $cont=$res->content;
  } else {
    require "www.pl";
    @opts=@_?("authorization=$_[0]:$_[1]"):();
    push(@opts,"quiet") if(!$opt_d);
    $www::useragent=$spoof if($spoof);
    ($status,$memo,%info)=&www::open_http_url(*FILE,$url,@opts);
    $code=$info{'CODE'};
    ($contyp)=$info{'HEADER'}=~/Content-type:\s+(.*)/i;
    $cont=<FILE>;
  }
}
sub dbg {
  print STDERR $_[0];
  print DBG $_[0];
}
