#!/usr/bin/perl
# ------------------
# expecting one filename as argument
# ------------------

use File::Basename;
my $libdir = dirname(__FILE__) . "/perl";
require "$libdir/credentials.pl";
my ($user, $passwd) = get_credential("anonymous");

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
$sys="sgi62";
#$sys="sgi51";
# machine that receives the file
$machine="crunch.ldeo.columbia.edu";

$ftpdir="pub/incoming";
$ftpurldir=~s./.%2F.g;
$finaldir="/Data/data6/ncep-ncar/daily/update";

print "Getting Daily CDAS\n";
$url="http://ingrid.ldeo.columbia.edu/";
$url="http://$sys.wwb.noaa.gov:8080/cgi-bin/ftp2u_drot_cdas.sh";
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
    $url="http://$sys.wwb.noaa.gov:8080/cgi-bin/ftp2u_drot_cdas.sh?";
    while($file=~m/"((grb2d|pgb).\d\d\d\d\d\d\d\d)"/g){
	$foundfile=$1;
	if(! -f "$finaldir/$foundfile"){
	    if($foundcnt){
		$url .= "&";
		$foundcnt +=1;
	    }
	    else {
		$foundcnt=1;
	    }
	    $url .= "file=$foundfile";
	}
    }
    if($foundcnt){
	$url .= "&machine=$machine";
	$url .= "&user=$user";
	$url .= "&passwd=$passwd";
	$url .= "&ftpdir=$ftpdir";
	$url .= "&prefix=";
	&geturl ($url,$file);
	$count=0;
	while($file=~m/Transfer complete/g){
	    $count=$count+1;
	}
	if($count > 1){
	    print "$count/$foundcnt files transfered\n";
	system("mv /usr/ftp/pub/incoming/{pgb,grb2d}.* $finaldir");
	system("cd /Data/data6/ncep-ncar/daily/prs/ ; ./makelinks.pl");
	system("cd /Data/data6/ncep-ncar/daily/flux/ ; ./makelinks.pl");
	system("cd /Data/data6/ncep-ncar/daily/ ; pmake all");
	}
    }
    else {
	print "No files needed\n";
    }
}
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
